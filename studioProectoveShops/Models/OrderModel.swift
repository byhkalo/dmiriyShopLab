//
//  OrderModel.swift
//  studioProectoveShops
//
//  Created by Dmitriy Gaponenko on 11.09.16.
//  Copyright © 2016 Dmitriy Gaponenko. All rights reserved.
//

import Foundation
import FirebaseDatabase

class OrderModel: NSObject, ModelProtocol {
    
    let identifier: String
    let shopModel: ShopModel
    let deliveryDate: Date
    let createDate: Date
    let totalPrice: Float?
    let productArray: Dictionary<String, NSNumber>?
    
    convenience init(model: Dictionary<String, Any>) {
        self.init(identifier: model[Constants.Order.Identifier]! as! String,
                  shopModel: ShopModel(model:model[Constants.Order.ShopModel]! as! Dictionary<String, AnyObject>),
                  deliveryDate: Converter.dateFromString(model[Constants.Order.DeliveryDate]! as! String)!,
                  createDate: Converter.dateFromString(model[Constants.Order.CreateDate]! as! String)!,
                  totalPrice: ((model[Constants.Order.TotalPrice] as? NSNumber)?.floatValue),
                  productArray: model[Constants.Order.OrderElementArray] as? Dictionary<String, NSNumber>)
    }
    
    convenience init(snapshot: FIRDataSnapshot) {
        var value = snapshot.value! as! Dictionary<String, Any>
        value[Constants.Order.Identifier] = snapshot.key
        self.init(model: value)
    }
    
    init(identifier: String, shopModel: ShopModel, deliveryDate: Date, createDate: Date, totalPrice: Float?, productArray: Dictionary<String, NSNumber>?) {
        
        self.identifier = identifier
        self.shopModel = shopModel
        self.deliveryDate = deliveryDate
        self.createDate = createDate
        self.productArray = productArray
        self.totalPrice = totalPrice
    }
    
    func dictionaryPresentationWithoutId() -> Dictionary<String, Any> {
        let orderProp = Constants.Order.self
        
        let orderDictionary : [String : AnyObject] =
            [orderProp.ShopModel : shopModel.dictionaryPresentation() as AnyObject,
             orderProp.DeliveryDate : Converter.sringFromDate(deliveryDate) as AnyObject,
             orderProp.CreateDate : Converter.sringFromDate(createDate) as AnyObject,
             orderProp.TotalPrice : NSNumber(value: totalPrice ?? 0.0 as Float),
             orderProp.OrderElementArray : productArray as AnyObject]
        
        return orderDictionary
    }
    
    func dictionaryPresentation() -> Dictionary<String, Any> {
        let orderProp = Constants.Order.self
        
        let orderDictionary : [String : AnyObject] =
            [orderProp.Identifier   : identifier as AnyObject,
             orderProp.ShopModel    : shopModel.dictionaryPresentation() as AnyObject,
             orderProp.DeliveryDate : Converter.sringFromDate(deliveryDate) as AnyObject,
             orderProp.CreateDate   : Converter.sringFromDate(createDate) as AnyObject,
             orderProp.TotalPrice   : NSNumber(value: totalPrice ?? 0.0 as Float),
             orderProp.OrderElementArray : productArray as AnyObject]
        
        return orderDictionary
    }
    
    class func initArray(snapshotArray: Array<Dictionary<String, Any>>?) -> [OrderModel]?  {
        if let snapDictArray = snapshotArray {
            var ordersArray = [OrderModel]()
            for helpOrderModel in snapDictArray {
                ordersArray.append(OrderModel(model: helpOrderModel))
            }
            return ordersArray
        }
        return nil
    }
    
}
