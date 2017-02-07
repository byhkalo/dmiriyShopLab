//
//  OrdersManager.swift
//  studioProectoveShops
//
//  Created by Dmitriy Gaponenko on 11.09.16.
//  Copyright © 2016 Dmitriy Gaponenko. All rights reserved.
//

import Foundation
import FirebaseDatabase
import FirebaseAuth
import ReactiveSwift

class OrdersManager {
    
    static let sharedInstance = OrdersManager()
    
    var ref: FIRDatabaseReference
    
    init() {
        self.ref = FIRDatabase.database().reference()
    }
    
    func getOrders(index: Int, count: Int) -> SignalProducer <Array<OrderModel>, NSError> {
        return SignalProducer { (sink, disposable) -> () in
            self.ref.child(Constants.Orders).observe(FIRDataEventType.value,
                                                     with: { (snapshot) in
                    var ordersViewModels = [OrderModel]()
                    
                    for list in snapshot.children {
                        let order = OrderModel.init(snapshot: list as! FIRDataSnapshot)
                        ordersViewModels.append(order)
                    }
                    sink.send(value: ordersViewModels)
                    //                sink.sendCompleted()
            })
        }
    }
    
    func getOrderByID(_ identifier: String) -> SignalProducer <Array<OrderModel>, NSError> {
        return SignalProducer { (sink, disposable) -> () in
            self.ref.child(Constants.Orders).child(identifier).observe(FIRDataEventType.value,
                                                                         with: { (snapshot) in
                                                                            var orderModels = [OrderModel]()
                                                                            
                                                                            let order = OrderModel.init(snapshot: snapshot)
                                                                            orderModels.append(order)
                                                                            
                                                                            sink.send(value: orderModels)
                                                                            sink.sendCompleted()
            })
        }
    }
    
    func createNewOrderShopIdentifier(_ shopModel: ShopModel, deliveryDate: Date, createDate: Date, totalPrice: Float, productArray: Dictionary<String, NSNumber>, dayPlan: DayPlanModel? = nil, completionHandler: @escaping (_ orderModel: OrderModel?) ->()) {
        
        let order = OrderModel(identifier: "", shopModel: shopModel, deliveryDate: deliveryDate, createDate: createDate, totalPrice: totalPrice, productArray: productArray)
        let dictPresentation = order.dictionaryPresentationWithoutId()
        
        self.ref.child(Constants.Orders).childByAutoId().setValue(dictPresentation) { (error, reference) in
            let identifier = reference.key
            self.getOrderByID(identifier)
                .on(failed: { print("Error. OrdersManager.swift. LINE 63. Error = \($0)") },
                    value: { (orderModels) in
                        if let dayPlan = dayPlan { dayPlan.addOrders(orderModels) }
                        completionHandler(orderModels.first)
                }).start()
        }
    }
}
