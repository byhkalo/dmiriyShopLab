//
//  Constants.swift
//  studioProectoveShops
//
//  Created by Dmitriy Gaponenko on 09.09.16.
//  Copyright © 2016 Dmitriy Gaponenko. All rights reserved.
//



struct Constants {
    static let Shops = "shops"
    static let Orders = "orders"
    static let Products = "products"
    static let Users = "users"
    static let DayPlans = "dayPlans"
    
    struct Shop {
        static let Name = "name"
        static let Identifier = "anyShopIdentifier" // check way for copy in Firebase
        static let Coordinate = "coordinate"
        static let LastVisitDate = "lastVisitDate"
        static let Orders = "orders"
        static let PlanFrequency = "planFrequency"
    }
    
    struct Order {
        static let Identifier = "identifier"
        static let ShopModel = "shopModel"
        static let DeliveryDate = "deliveryDate"
        static let CreateDate = "createDate"
        static let OrderElementArray = "orderElementArray"
        static let TotalPrice = "totalPrice"
    }
    
    struct Product {
        static let Name = "name"
        static let Identifier = "identifier"
        static let Price = "price"
        static let Description = "description"
        static let InStorage = "inStorage"
        static let Image = "image"
    }
    
    struct Cell {
        static let cellIdentifier = "PostCell"
    }
    
    struct UserProperties {
        static let UserId = "userId"
        static let IsAdminSupervisor = "isAdmin"
        static let DisplayName = "displayName"
        static let SupervisorID = "supervisorID"
        static let ShopsList = "shopsList"
        static let OrdersList = "ordersList"
        static let Location = "location"
        static let Lat = "lat"
        static let Lon = "lon"
        static let PlanList = "dayShopsPlan"
        static let SalesList = "salesList"
    }
    
    struct DayShopsPlan {
        static let Identifier = "identifier"
        static let UserId = "userID"
        static let Date = "date"
        static let ShopsList = "shopsList"
        static let TotalSum = "totalSum"
        static let OrdersList = "ordersList"
    }
    
}
