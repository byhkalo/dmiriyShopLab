//
//  SalesRepresentativeModel.swift
//  studioProectoveShops
//
//  Created by Konstantyn Byhkalo on 1/31/17.
//  Copyright © 2017 Dmitriy Gaponenko. All rights reserved.
//

import Foundation
import FirebaseDatabase

class SalesRepresentativeModel: NSObject {
    
    let identifier: String
    let name: String
    let price: Float
    let descriptionProduct: String
    let inStorage: Int
    
    convenience init(model: Dictionary<String, AnyObject>) {
        self.init(identifier: model[Constants.Product.Identifier]! as! String,
                  name: model[Constants.Product.Name]! as! String,
                  descriptionProduct: model[Constants.Product.Description]! as! String,
                  price: (model[Constants.Product.Price]! as! NSNumber).floatValue,
                  inStorage: (model[Constants.Product.InStorage]! as! NSNumber).intValue)
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
}

