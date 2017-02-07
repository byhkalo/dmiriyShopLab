//
//  DayPlanManager.swift
//  studioProectoveShops
//
//  Created by Konstantyn Byhkalo on 2/2/17.
//  Copyright © 2017 Dmitriy Gaponenko. All rights reserved.
//

import Foundation
import FirebaseDatabase
import FirebaseAuth
import ReactiveSwift

class DayPlanManager {
    
    static let sharedInstance = DayPlanManager()
    
    var ref: FIRDatabaseReference
    
    init() {
        self.ref = FIRDatabase.database().reference()
    }
    
    func createNewPlan(userModel: UserModel, date: Date, shopsModels: [ShopModel], completionHandler: @escaping (_ isSuccess: Bool) ->()) {
        
        let shopsDictModels = ShopModel.listDictionaryPresentation(models: shopsModels)
        
        let dpProp = Constants.DayShopsPlan.self
        let newPlan : [String : Any] = [dpProp.Date : Converter.sringFromDate(date),
                                        dpProp.UserId : userModel.identifier,
                                        dpProp.ShopsList : shopsDictModels,
                                        dpProp.TotalSum : NSNumber(value: 0.0)]
        // firstly create new Plan
        self.ref.child(Constants.DayPlans).childByAutoId().setValue(newPlan) { (error, reference) in
            if error == nil {
                let identifier = reference.key
                // after - set this plan to user
                self.getPlanByID(identifier).on(value: { (dayPlansModels) in
                    userModel.addPlan(dayPlansModels)
                    completionHandler(error == nil)
                }).start()
            }
        }
    }
    
//    MARK: - Get Plans
    
    func getPlan(user userModel: UserModel) -> SignalProducer <Array<DayPlanModel>, NSError> {
        return SignalProducer { (sink, disposable) -> () in
            self.ref.child(Constants.DayPlans)
                .queryOrdered(byChild: Constants.DayShopsPlan.UserId)
                .queryStarting(atValue: userModel.identifier).observe(FIRDataEventType.value,
                                                    with: { (snapshot) in
                                                        var postsViewModels = [DayPlanModel]()
                                                        
                                                        for list in snapshot.children {
                                                            let plan = DayPlanModel.init(snapshot: list as! FIRDataSnapshot)
                                                            postsViewModels.append(plan)
                                                        }
                                                        sink.send(value: postsViewModels)
                                                        //                sink.sendCompleted()
            })
        }
    }
    
    func getPlanByID(_ identifier: String) -> SignalProducer <Array<DayPlanModel>, NSError> {
        return SignalProducer { (sink, disposable) -> () in
            self.ref.child(Constants.DayPlans).child(identifier).observe(FIRDataEventType.value,
                                                      with: { (snapshot) in
                                                        var planModels = [DayPlanModel]()
                                                        
                                                        let plan = DayPlanModel.init(snapshot: snapshot)
                                                        planModels.append(plan)
                                                        
                                                        sink.send(value: planModels)
                                                        sink.sendCompleted()
                })
        }
    }
    
//    MARK: - Get Shops 
    
    func getShopsConnectedToPlan(dayPlan: DayPlanModel) -> SignalProducer <Array<ShopModel>, NSError> {
        
        return getShops(connectedToPlan: true, dayPlan: dayPlan)
    }
    
    func getShopsNotConnectedToPlan(dayPlan: DayPlanModel) -> SignalProducer <Array<ShopModel>, NSError> {
        
        return getShops(connectedToPlan: false, dayPlan: dayPlan)
    }
    
    private func getShops(connectedToPlan isConnected:Bool, dayPlan: DayPlanModel) -> SignalProducer <Array<ShopModel>, NSError> {
        
        return SignalProducer { (sink, disposable) -> () in
            self.ref.child(Constants.Shops)
                .observe(FIRDataEventType.value,
                         with: { (snapshot) in
                            var shopsModels = [ShopModel]()
                            let ownShopsList = dayPlan.shopsList ?? [ShopModel]()
                            
                            for list in snapshot.children {
                                let shop = ShopModel.init(snapshot: list as! FIRDataSnapshot)
                                
                                var isContain = false
                                for ownShop in ownShopsList {
                                    if shop.identifier == ownShop.identifier {
                                        isContain = true
                                    }
                                }
                                
                                switch (isContain, isConnected) {
                                case (true, true): shopsModels.append(shop)
                                case (false, false): shopsModels.append(shop)
                                default: break
                                }
                            }
                            
                            sink.send(value: shopsModels)
                            //                sink.sendCompleted()
                })
        }
    }
    
}
