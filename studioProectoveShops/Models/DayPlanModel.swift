//
//  DayPlanModel.swift
//  studioProectoveShops
//
//  Created by Konstantyn Byhkalo on 1/31/17.
//  Copyright © 2017 Dmitriy Gaponenko. All rights reserved.
//

import Foundation
import FirebaseDatabase

class DayPlanModel: NSObject, ModelProtocol {
    private let ref = FIRDatabase.database().reference()
    
    let identifier: String
    let userID: String
    let date: Date
    var shopsList: [ShopModel]?
    var ordersList: [OrderModel]?
    var totalSum: Float
    
    convenience init(model: Dictionary<String, Any>) {
        let dpmProp = Constants.DayShopsPlan.self
        
        let stringDateOfBirth = model[dpmProp.Date] as! String
        let helpDate = Converter.dateFromString(stringDateOfBirth) ?? Date()
        
        self.init(identifier            : model[dpmProp.Identifier]! as! String,
                  userID                : model[dpmProp.UserId]! as! String,
                  date                  : helpDate,
                  shopsList             : ShopModel.initArray(snapshotArray: model[dpmProp.ShopsList] as? Array<Dictionary<String, Any>>),
                  ordersList            : OrderModel.initArray(snapshotArray: model[dpmProp.OrdersList] as? Array<Dictionary<String, Any>>),
                  totalSum              : (model[dpmProp.TotalSum] as? NSNumber)?.floatValue ?? 0)
    }
    
    convenience init(snapshot: FIRDataSnapshot) {
        var value = snapshot.value! as! Dictionary<String, AnyObject>
        value[Constants.Product.Identifier] = snapshot.key as AnyObject?
        self.init(model: value)
    }
    
    init(identifier: String, userID: String, date: Date, shopsList: [ShopModel]?, ordersList: [OrderModel]?, totalSum: Float) {
        
        self.identifier = identifier
        self.userID = userID
        self.date = date
        self.shopsList = shopsList
        self.ordersList = ordersList
        self.totalSum = totalSum
    }
    
    func dictionaryPresentation() -> Dictionary<String, Any> {
        let dpmProp = Constants.DayShopsPlan.self
        
        let productDictionary : [String : Any] =
            [dpmProp.Identifier : identifier,
             dpmProp.UserId     : userID,
             dpmProp.Date       : Converter.sringFromDate(date),
             dpmProp.ShopsList  : ShopModel.listDictionaryPresentation(models: shopsList) ,
             dpmProp.OrdersList : OrderModel.listDictionaryPresentation(models: ordersList),
             dpmProp.TotalSum   : NSNumber(value: totalSum)]
        return productDictionary
    }

    
    class func initArray(snapshotArray: Array<Dictionary<String, Any>>?) -> [DayPlanModel]?  {
        if let dictArray = snapshotArray {
            var plansArray = [DayPlanModel]()
            for helpPlanModel in dictArray {
                plansArray.append(DayPlanModel(model: helpPlanModel))
            }
            return plansArray
        }
        return nil
    }
    
//    MARK: - Add Elements
    
    func addOrders(_ addOrdersList: [OrderModel]) {
        if addOrdersList.count > 0 {
            var helpOrdersList = self.ordersList ?? [OrderModel]()
            helpOrdersList.append(contentsOf: addOrdersList)
            
            var totalSum = Float(0.0)
            for order in helpOrdersList {
                totalSum += order.totalPrice ?? 0.0
            }
            
            self.ordersList = helpOrdersList
            self.totalSum = totalSum
            self.updatePlanInformation()
        }
    }
    
    func addShops(_ addShopsList: [ShopModel]) {
        if addShopsList.count > 0 {
            var helpShopsList = self.shopsList ?? [ShopModel]()
            helpShopsList.append(contentsOf: addShopsList)
            
            self.shopsList = helpShopsList
            self.updatePlanInformation()
        }
    }
    
    func updatePlanInformation() {
        let childUpdates = ["\(self.identifier)": dictionaryPresentation()]
        ref.child(Constants.DayPlans).updateChildValues(childUpdates)
    }
}
