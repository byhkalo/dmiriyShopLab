//
//  Constants.swift
//  studioProectoveShops
//
//  Created by Dmitriy Gaponenko on 09.09.16.
//  Copyright © 2016 Dmitriy Gaponenko. All rights reserved.
//



struct Constants {
    static let Shops = "shops"
    
    struct Shop {
        static let Name = "name"
        static let Identifier = "anyShopIdentifier" // check way for copy in Firebase
        static let Coordinate = "coordinate"
        static let LastVisitDate = "lastVisitDate"
        static let Orders = "orders"
        static let PlanFrequency = "planFrequency"
    }
    
    struct Cell {
        static let cellIdentifier = "PostCell"
    }
}
