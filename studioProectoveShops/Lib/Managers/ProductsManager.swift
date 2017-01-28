//
//  ProductsManager.swift
//  studioProectoveShops
//
//  Created by Dmitriy Gaponenko on 11.09.16.
//  Copyright © 2016 Dmitriy Gaponenko. All rights reserved.
//

import Foundation
import FirebaseDatabase
import FirebaseAuth
import ReactiveSwift

class ProductsManager {
    
    static let sharedInstance = ProductsManager()
    
    var ref: FIRDatabaseReference
    
    init() {
        self.ref = FIRDatabase.database().reference()
    }
    
    func getProducts(index: Int, count: Int) -> SignalProducer <Array<ProductModel>, NSError> {
        return SignalProducer { (sink, disposable) -> () in
            self.ref.child(Constants.Products).observe(FIRDataEventType.value,
                                                       with: { (snapshot) in
                    var postsViewModels = [ProductModel]()
                    
                    for list in snapshot.children {
                        let product = ProductModel.init(snapshot: list as! FIRDataSnapshot)
                        postsViewModels.append(product)
                    }
                    sink.send(value: postsViewModels)
                    //                sink.sendCompleted()
            })
        }
    }
    
    func getProductsByName(_ name: String) -> SignalProducer <Array<ProductModel>, NSError> {
        return SignalProducer { (sink, disposable) -> () in
            self.ref.child(Constants.Products)
                .queryOrdered(byChild: Constants.Product.Name)
                .queryStarting(atValue: name).observe(FIRDataEventType.value,
                                                      with: { (snapshot) in
                        var postsViewModels = [ProductModel]()
                        
                        for list in snapshot.children {
                            let product = ProductModel.init(snapshot: list as! FIRDataSnapshot)
                            postsViewModels.append(product)
                        }
                        sink.send(value: postsViewModels)
                        sink.sendCompleted()
                })
        }
    }
    
    func changeInStorageCountByProductId(_ productId: String, newValue: Int) -> SignalProducer <Bool, NSError> {
        return SignalProducer { (sink, disposable) -> () in
            let updatedDict = [Constants.Product.InStorage : NSNumber(value: newValue)]
            
            self.ref.child(Constants.Products).child(productId)
                .updateChildValues(updatedDict, withCompletionBlock: { (error, baseReference) in
                    if let error = error {
                        sink.send(error: error as NSError)
                    } else {
                        sink.send(value: true)
                        sink.sendCompleted()
                    }
                })
        }
    }
    
}
