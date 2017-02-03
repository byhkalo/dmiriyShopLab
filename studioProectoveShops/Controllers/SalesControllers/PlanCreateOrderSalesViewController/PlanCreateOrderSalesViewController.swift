//
//  PlanCreateOrderSalesViewController.swift
//  studioProectoveShops
//
//  Created by Konstantyn Byhkalo on 2/3/17.
//  Copyright © 2017 Dmitriy Gaponenko. All rights reserved.
//

import UIKit

class PlanCreateOrderSalesViewController: CreateOrderViewController {

    var userDetail: UserModel!
    var dayPlanDetail: DayPlanModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    override func createOrderAction(_ sender: AnyObject) {
        
        guard let shopModel = shopModel, let productsOrderDictionary = productsOrderDictionary else {
            router().displayAlertTitle("Sorry", message: "Please, Check your order")
            return
        }
        
        OrdersManager.sharedInstance
            .createNewOrderShopIdentifier(shopModel,
                                          deliveryDate: deliveryDatePicker.date,
                                          createDate: Date(),
                                          totalPrice: totalPrice,
                                          productArray: productsOrderDictionary,
                                          dayPlan: dayPlanDetail) { (isSuccess) in
                                            
                                            ShopsManager.sharedInstance.insertOrderToShopId(shopModel.identifier, newOrderValue: productsOrderDictionary).on(failed: { (error) in
                                                print("Fucking Eror from FireBase. Error: \(error)")
                                            }, value: { (isSuccess) in
                                                if isSuccess {
                                                    print("Maybe success from FireBase")
                                                } else {
                                                    print("Maybe NOT successfully from FireBase")
                                                }
                                            }).start()
                                            
                                            for productModel in self.productsModelsArray {
                                                let oldStorageCount = productModel.inStorage
                                                let orderCount = (self.productsOrderDictionary![productModel.identifier])?.intValue
                                                let newValue = oldStorageCount - orderCount!
                                                
                                                ProductsManager.sharedInstance
                                                    .changeInStorageCountByProductId(productModel.identifier, newValue: newValue)
                                                    .on(failed: { (error) in
                                                        print("Fucking Eror from FireBase. Error: \(error)")
                                                    }, value: { (isSuccess) in
                                                        if isSuccess {
                                                            print("Maybe success from FireBase")
                                                        } else {
                                                            print("Maybe NOT successfully from FireBase")
                                                        }
                                                    }).start()
                                            }
                                            
                                            DispatchQueue.main.async(execute: {
                                                _ = self.navigationController?.popViewController(animated: true)
                                                router().displayAlertTitle("Success", message: "Order has been placed successfully")
                                            })
        }
        
        print("createOrderAction")
    }
    

}
