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
import ReactiveCocoa

class ShopsManager {
    
    static let sharedInstance = ShopsManager()
    
    var ref: FIRDatabaseReference
    
    init() {
        self.ref = FIRDatabase.database().reference()
    }
    
    func getShops(index index: Int, count: Int) -> SignalProducer <Array<ShopModel>, NSError> {
        return SignalProducer { (sink, disposable) -> () in
            self.ref.child(Constants.Shops).observeEventType(FIRDataEventType.Value,
                withBlock: { (snapshot) in
                var postsViewModels = [ShopModel]()
                
                for list in snapshot.children {
                    let shop = ShopModel.init(snapshot: list as! FIRDataSnapshot)
                    postsViewModels.append(shop)
                }
                sink.sendNext(postsViewModels)
                sink.sendCompleted()
            })
        }
    }
    
    func createNewPostTitle(title: String, body: String, user: FIRUser, imageData: NSData?, completionHandler: (isSuccess: Bool) ->()) {
//        let timeStamp = Double(NSDate.timeIntervalSinceReferenceDate())
//        
//        let newPost : [String : AnyObject] = [Constants.kAuthor    : user.displayName as! AnyObject,
//                                              Constants.kTitle     : title as AnyObject,
//                                              Constants.kBody      : body as AnyObject,
//                                              Constants.kTimestamp : NSNumber.init(double: timeStamp) as AnyObject]
//
//        self.ref.child("posts").childByAutoId().setValue(newPost) { (error, reference) in
//            completionHandler(isSuccess: error == nil)
//        }
        
    }
}