//
//  ViewController.swift
//  studioProectoveShops
//
//  Created by Dmitriy Gaponenko on 09.09.16.
//  Copyright © 2016 Dmitriy Gaponenko. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let locationManager = LocationManager.sharedInstance.locationManager
        print("location manager = \(locationManager)")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        self.navigationController?.navigationItem.leftBarButtonItem = nil
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func mapButtonAction(_ sender: AnyObject) {
        print("mapButtonAction")
        navigationController?.pushViewController(TaskTodayViewController.controllerFromStoryboard(), animated: true)
    }
    
    @IBAction func orderListButtonAction(_ sender: AnyObject) {
        print("orderListButtonAction")
        navigationController?.pushViewController(OrdersListViewController.controllerFromStoryboard(), animated: true)
    }
    
    @IBAction func shopsListButtonAction(_ sender: AnyObject) {
        print("shopsListButtonAction")
        navigationController?.pushViewController(ShopsListViewController.controllerFromStoryboard(), animated: true)
    }
    
    @IBAction func planListButtonAction(_ sender: AnyObject) {
        print("planListButtonAction")
        UserModel.getCurrentUser { (userModel) in
            let controller = PlanListSalesViewController.instantiateFromStoryboard()
            controller.userDetail = userModel
            DispatchQueue.main.async {
                self.navigationController?.pushViewController(controller, animated: true)
            }
        }
    }
    
    @IBAction func logoutAction(_ sender: AnyObject) {
        print("logoutAction")
        router().logOut()
    }
    
}

