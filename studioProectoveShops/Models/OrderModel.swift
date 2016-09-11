//
//  OrderModel.swift
//  studioProectoveShops
//
//  Created by Dmitriy Gaponenko on 11.09.16.
//  Copyright © 2016 Dmitriy Gaponenko. All rights reserved.
//

import Foundation
import FirebaseDatabase

class OrderModel: NSObject {
    
    let identifier: String
    let shopModel: ShopModel
    let deliveryDate: NSDate
    let productArray: Array<Dictionary<String, NSNumber>>?
    
    convenience init(model: Dictionary<String, AnyObject>) {
        self.init(identifier: model[Constants.Order.Identifier]! as! String,
                  shopModel: ShopModel(model:model[Constants.Order.ShopModel]! as! Dictionary<String, AnyObject>),
                  deliveryDate: Converter.dateFromString(model[Constants.Shop.LastVisitDate]! as! String)!,
                  productArray: model[Constants.Order.OrderElementArray] as? Array<Dictionary<String, NSNumber>>)
    }
    
    convenience init(snapshot: FIRDataSnapshot) {
        var value = snapshot.value! as! Dictionary<String, AnyObject>
        value[Constants.Order.Identifier] = snapshot.key
        self.init(model: value)
    }
    
    init(identifier: String, shopModel: ShopModel, deliveryDate: NSDate, productArray: Array<Dictionary<String, NSNumber>>?) {
        
        self.identifier = identifier
        self.shopModel = shopModel
        self.deliveryDate = deliveryDate
        self.productArray = productArray
    }
}
