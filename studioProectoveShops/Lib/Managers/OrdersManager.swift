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
    
    func createNewOrderShopIdentifier(_ shopModel: ShopModel, deliveryDate: Date, createDate: Date, totalPrice: Float, productArray: Dictionary<String, NSNumber>, completionHandler: @escaping (_ isSuccess: Bool) ->()) {
        let newOrder : [String : AnyObject] = [Constants.Order.ShopModel : shopModel.dictionaryPresentationForOrder() as AnyObject,
                                              Constants.Order.DeliveryDate : Converter.sringFromDate(deliveryDate) as AnyObject,
                                              Constants.Order.CreateDate : Converter.sringFromDate(createDate) as AnyObject,
                                              Constants.Order.TotalPrice : NSNumber(value: totalPrice as Float),
                                              Constants.Order.OrderElementArray : productArray as AnyObject]
        
        self.ref.child(Constants.Orders).childByAutoId().setValue(newOrder) { (error, reference) in
            completionHandler(error == nil)
        } 
    }
}
