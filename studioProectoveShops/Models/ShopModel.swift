//
//  ShopModel.swift
//  studioProectoveShops
//
//  Created by Dmitriy Gaponenko on 10.09.16.
//  Copyright © 2016 Dmitriy Gaponenko. All rights reserved.
//

import Foundation
import FirebaseDatabase

class ShopModel: NSObject {
    
    let name: String
    let identifier: String
    let lastVisitDate: Date
    let lat: Float
    let lon: Float
    let planFrequency: Int
    let orderArray: Dictionary<String, Dictionary<String, NSNumber>>?
    
    convenience init(model: Dictionary<String, AnyObject>) {
        let coordinate = model[Constants.Shop.Coordinate] as! NSDictionary
        self.init(name: model[Constants.Shop.Name]! as! String,
                  identifier: model[Constants.Shop.Identifier]! as! String,
                  lastVisitDate: Converter.dateFromString(model[Constants.Shop.LastVisitDate]! as! String)!,
                  lat: (coordinate["lat"]! as! NSNumber).floatValue,
                  lon: (coordinate["lon"]! as! NSNumber).floatValue,
                  planFrequency: (model[Constants.Shop.PlanFrequency]! as! NSNumber).intValue,
                  orderArray: model[Constants.Shop.Orders] as? Dictionary<String, Dictionary<String, NSNumber>>)
    }
    convenience init(snapshot: FIRDataSnapshot) {
        var value = snapshot.value! as! Dictionary<String, AnyObject>
        value[Constants.Shop.Identifier] = snapshot.key as AnyObject?
        self.init(model: value)
    }
    
    init(name:String, identifier: String, lastVisitDate: Date, lat: Float, lon: Float, planFrequency: Int, orderArray: Dictionary<String, Dictionary<String, NSNumber>>?) {
        self.name = name
        self.identifier = identifier
        self.lastVisitDate = lastVisitDate
        self.lat = lat
        self.lon = lon
        self.planFrequency = planFrequency
        self.orderArray = orderArray
    }
    
    func dictionaryPresentationForOrder() -> Dictionary<String, Any> {
        let shopDictionary : [String : Any] = [Constants.Shop.Identifier: identifier as AnyObject,
                                                     Constants.Shop.Name  : name as AnyObject,
                                                     Constants.Shop.LastVisitDate : Converter.sringFromDate(lastVisitDate) as AnyObject,
                                                     Constants.Shop.Coordinate : ["lat": NSNumber(value: lat as Float), "lon": NSNumber(value: lon as Float)],
                                                     Constants.Shop.PlanFrequency: NSNumber(value: planFrequency as Int)]
        return shopDictionary
    }
}
