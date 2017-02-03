//
//  UserModel.swift
//  studioProectoveShops
//
//  Created by Konstantyn Byhkalo on 1/31/17.
//  Copyright © 2017 Dmitriy Gaponenko. All rights reserved.
//

import Foundation
import CoreLocation
import FirebaseDatabase
import FirebaseAuth

class UserModel: NSObject, ModelProtocol {
    
//    MARK: - Properties
    
    private static let ref = FIRDatabase.database().reference()
    private let ref = FIRDatabase.database().reference()
    private var user: [String : Any]
    
    let identifier: String
    let name: String
    let isAdminSupervisor: Bool
    let supervisorOwnerID: String
    var ordersList: [OrderModel]?
    var shopsList: [ShopModel]?
    var planList: [DayPlanModel]?
    var salesList: [UserModel]?
    var lat: Double!
    var lon: Double!
    
    var location: [String : NSNumber] {
        didSet {
            self.lat = Double(location[Constants.UserProperties.Lat]!)
            self.lon = Double(location[Constants.UserProperties.Lon]!)
            self.user[Constants.UserProperties.Location] = location
            updateUserInformation()
        }
    }
    var updatedLocation: CLLocation! {
        didSet {
            self.location = [Constants.UserProperties.Lat : NSNumber(floatLiteral: updatedLocation.coordinate.latitude),
                             Constants.UserProperties.Lon : NSNumber(floatLiteral: updatedLocation.coordinate.longitude)]
        }
    }
    
//    MARK: - Initialization
    
    init(user: [String : Any]) {
        let uProp = Constants.UserProperties.self
        
        self.user = user
        self.identifier = user[uProp.UserId] as! String
        self.name = user[uProp.DisplayName] as! String
        self.isAdminSupervisor = (user[uProp.IsAdminSupervisor] as! NSNumber).boolValue
        self.supervisorOwnerID = user[uProp.SupervisorID] as! String
        self.ordersList = OrderModel.initArray(snapshotArray: user[uProp.OrdersList] as? Array<Dictionary<String, Any>>)
        self.shopsList = ShopModel.initArray(snapshotArray: user[uProp.ShopsList] as? Array<Dictionary<String, Any>>)
        self.planList = DayPlanModel.initArray(snapshotArray: user[uProp.ShopsList] as? Array<Dictionary<String, Any>>)
        self.salesList = UserModel.initArray(snapshotArray: user[uProp.SalesList] as? Array<Dictionary<String, Any>>)
        
        self.location = user[uProp.Location] as! [String : NSNumber]
        self.lat = Double(self.location[Constants.UserProperties.Lat]!)
        self.lon = Double(self.location[Constants.UserProperties.Lon]!)
    }
    
    convenience init(snapshot: FIRDataSnapshot) {
        var value = snapshot.value! as! Dictionary<String, AnyObject>
        value[Constants.Order.Identifier] = snapshot.key as AnyObject?
        self.init(user: value)
    }
    
    class func initArray(snapshotArray: Array<Dictionary<String, Any>>?) -> [UserModel]?  {
        if let dictArray = snapshotArray {
            var salesArray = [UserModel]()
            for helpUserModel in dictArray {
                salesArray.append(UserModel(user: helpUserModel))
            }
            return salesArray
        }
        return nil
    }
    
    class func getCurrentUser(volunteer:@escaping (UserModel) -> ()) {
        let userID = FIRAuth.auth()?.currentUser?.uid
        ref.child("users").child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? [String : Any]
            if let value = value {
                let user = UserModel(user: value)
                volunteer(user)
            }
        }) { (error) in
            print("Error when try to get UserInfo \n Error: \(error.localizedDescription)")
        }
    }
    
//    MARK: - Add Elements
    
    func addOrders(_ addOrdersList: [OrderModel]) {
        if addOrdersList.count > 0 {
            var helpOrdersList = self.ordersList ?? [OrderModel]()
            helpOrdersList.append(contentsOf: addOrdersList)
            
            self.ordersList = helpOrdersList
            self.updateUserInformation()
        }
    }
    
    func addShops(_ addShopsList: [ShopModel]) {
        if addShopsList.count > 0 {
            var helpShopsList = self.shopsList ?? [ShopModel]()
            helpShopsList.append(contentsOf: addShopsList)
            
            self.shopsList = helpShopsList
            self.updateUserInformation()
        }
    }
    
    func addPlan(_ addPlansList: [DayPlanModel]) {
        if addPlansList.count > 0 {
            var helpPlansList = self.planList ?? [DayPlanModel]()
            helpPlansList.append(contentsOf: addPlansList)
            
            self.planList = helpPlansList
            self.updateUserInformation()
        }
    }
    
    func addSales(_ addSalesList: [UserModel]) {
        if addSalesList.count > 0 {
            var helpSalesList = self.salesList ?? [UserModel]()
            helpSalesList.append(contentsOf: addSalesList)
            
            self.salesList = helpSalesList
            self.updateUserInformation()
        }
    }
//    class func getCurrentUser() -> UserModel {
//        var user: UserModel!
//        
//        let semaphore = DispatchSemaphore.init(value: 0)
//        
//        let group = DispatchGroup()
//        group.enter()
//        self.getCurrentUser { (helpUserModel) in
//            user = helpUserModel
//            group.leave()
//        }
//        
//        group.notify(queue: DispatchQueue.main) { 
//            print("finish")
//            semaphore.signal()
//        }
//        
//        semaphore.wait()
//        return user
//    }
    
    func dictionaryPresentation() -> Dictionary<String, Any> {
        let uProp = Constants.UserProperties.self
        
        user[uProp.UserId] = identifier
        user[uProp.DisplayName] = name
        user[uProp.IsAdminSupervisor] = NSNumber(booleanLiteral: isAdminSupervisor)
        user[uProp.SupervisorID] = supervisorOwnerID
        user[uProp.OrdersList] = OrderModel.listDictionaryPresentation(models: ordersList)
        user[uProp.ShopsList] = ShopModel.listDictionaryPresentation(models: shopsList)
        user[uProp.PlanList] = DayPlanModel.listDictionaryPresentation(models: planList)
        user[uProp.SalesList] = UserModel.listDictionaryPresentation(models: salesList)
        //location configurated automatically in property settings
        
        return user
    }
    
    func updateUserInformation() {
        let childUpdates = ["\(self.identifier)": dictionaryPresentation()]
        ref.child("users").updateChildValues(childUpdates)
    }
    
}

