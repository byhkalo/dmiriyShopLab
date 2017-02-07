//
//  ShopsManager.swift
//  studioProectoveShops
//
//  Created by Dmitriy Gaponenko on 09.09.16.
//  Copyright © 2016 Dmitriy Gaponenko. All rights reserved.
//

import Foundation
import FirebaseDatabase
import FirebaseAuth
import ReactiveSwift

class ShopsManager {
    
    static let sharedInstance = ShopsManager()
    
    var ref: FIRDatabaseReference
    
    init() {
        self.ref = FIRDatabase.database().reference()
    }
    
    func getShops(index: Int, count: Int) -> SignalProducer <Array<ShopModel>, NSError> {
        return SignalProducer { (sink, disposable) -> () in
            self.ref.child(Constants.Shops).observe(FIRDataEventType.value,
                                                    with: { (snapshot) in
                var postsViewModels = [ShopModel]()
                
                for list in snapshot.children {
                    let shop = ShopModel.init(snapshot: list as! FIRDataSnapshot)
                    postsViewModels.append(shop)
                }
                sink.send(value: postsViewModels)
//                sink.sendCompleted()
            })
        }
    }
    
    func getShopsByName(_ name: String) -> SignalProducer <Array<ShopModel>, NSError> {
        return SignalProducer { (sink, disposable) -> () in
            self.ref.child(Constants.Shops)
                .queryOrdered(byChild: Constants.Shop.Name)
                .queryStarting(atValue: name).observe(FIRDataEventType.value,
                                                      with: { (snapshot) in
                        var postsViewModels = [ShopModel]()
                        
                        for list in snapshot.children {
                            let shop = ShopModel.init(snapshot: list as! FIRDataSnapshot)
                            postsViewModels.append(shop)
                        }
                        sink.send(value: postsViewModels)
                        sink.sendCompleted()
                })
        }
    }
    
//    MARK: - Get Shops For User
    
    func getShopsConnectedUser(user: UserModel) -> SignalProducer <Array<ShopModel>, NSError> {
        
        return getShops(connectedToUser: true, user: user)
    }
    
    func getShopsNotConnectedToUser(user: UserModel) -> SignalProducer <Array<ShopModel>, NSError> {
        
        return getShops(connectedToUser: false, user: user)
    }
    
    private func getShops(connectedToUser isConnected:Bool, user: UserModel) -> SignalProducer <Array<ShopModel>, NSError> {
        
        return SignalProducer { (sink, disposable) -> () in
            self.ref.child(Constants.Shops)
                .observe(FIRDataEventType.value,
                         with: { (snapshot) in
                            var shopsModels = [ShopModel]()
                            let ownShopsList = user.shopsList ?? [ShopModel]()
                            
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

//    MARK: - Create Shop
    
    func createNewShopName(_ name: String, lastVisitDate: Date, lat: Float, lon: Float, planFrequency: Int, completionHandler: @escaping (_ isSuccess: Bool) ->()) {
        let newShop : [String : Any] = [Constants.Shop.Name  : name as AnyObject,
                                              Constants.Shop.LastVisitDate : Converter.sringFromDate(lastVisitDate) as AnyObject,
                                              Constants.Shop.Coordinate : ["lat": NSNumber(value: lat as Float), "lon": NSNumber(value: lon as Float)],
                                              Constants.Shop.PlanFrequency: NSNumber(value: planFrequency as Int)]

        self.ref.child(Constants.Shops).childByAutoId().setValue(newShop) { (error, reference) in
            completionHandler(error == nil)
        } 
    }
    
    func insertOrderToShopId(_ shopId: String, newOrderValue: Dictionary<String, NSNumber>) -> SignalProducer <Bool, NSError> {
        return SignalProducer { (sink, disposable) -> () in
            self.ref.child(Constants.Shops).child(shopId).child(Constants.Shop.Orders).childByAutoId()
                .setValue(newOrderValue, withCompletionBlock: { (error, databaseRef) in
                    if  let error = error {
                        sink.send(error: error as NSError)
                    } else {
                        sink.send(value: true)
                        sink.sendCompleted()
                    }
                })
        }
    }
    
}
