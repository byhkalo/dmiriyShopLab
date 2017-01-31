//
//  SalesRepresentativeManager.swift
//  studioProectoveShops
//
//  Created by Konstantyn Byhkalo on 1/31/17.
//  Copyright © 2017 Dmitriy Gaponenko. All rights reserved.
//

import Foundation

import Foundation
import ReactiveSwift
import Firebase
import FirebaseAuth

class SalesRepresentativeManager {
    
    static let sharedInstance = SalesRepresentativeManager()
    
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
}

