//
//  ProductModel.swift
//  studioProectoveShops
//
//  Created by Dmitriy Gaponenko on 11.09.16.
//  Copyright © 2016 Dmitriy Gaponenko. All rights reserved.
//

import Foundation
import FirebaseDatabase

class ProductModel: NSObject, ModelProtocol {
    
    let identifier: String
    let name: String
    let price: Float
    let descriptionProduct: String
    let inStorage: Int
    
    convenience init(model: Dictionary<String, AnyObject>) {
        let productProp = Constants.Product.self
        self.init(identifier            : model[productProp.Identifier]! as! String,
                  name                  : model[productProp.Name]! as! String,
                  descriptionProduct    : model[productProp.Description]! as! String,
                  price                 : (model[productProp.Price]! as! NSNumber).floatValue,
                  inStorage             : (model[productProp.InStorage]! as! NSNumber).intValue)
    }
    
    convenience init(snapshot: FIRDataSnapshot) {
        var value = snapshot.value! as! Dictionary<String, AnyObject>
        value[Constants.Product.Identifier] = snapshot.key as AnyObject?
        self.init(model: value)
    }
    
    init(identifier: String, name: String, descriptionProduct: String, price: Float, inStorage: Int) {
        
        self.identifier = identifier
        self.name = name
        self.price = price
        self.descriptionProduct = descriptionProduct
        self.inStorage = inStorage
    }
    
    func dictionaryPresentation() -> Dictionary<String, Any> {
        let productProp = Constants.Product.self
        
        let productDictionary : [String : Any] =
            [productProp.Identifier   : identifier as AnyObject,
             productProp.Name         : name as AnyObject,
             productProp.Price        : NSNumber(value: price),
             productProp.Description  : descriptionProduct as AnyObject,
             productProp.InStorage    : NSNumber(value: inStorage)]
        return productDictionary
    }

    
}
