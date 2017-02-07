//
//  AddShopToListViewController.swift
//  studioProectoveShops
//
//  Created by Konstantyn Byhkalo on 2/7/17.
//  Copyright © 2017 Dmitriy Gaponenko. All rights reserved.
//

import UIKit

class AddShopToListViewController: AddShopToPlanViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func loadShops() {
        ShopsManager.sharedInstance
            .getShopsNotConnectedToUser(user: userDetail)
            .on(failed: { (error) in
                print("Error. AddShopToListViewController.swift LINE 22 \nError = \(error.debugDescription)")
            }) { (shopModels) in
                self.shopsList = shopModels
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
        }.start()
    }
    
//    MARK: - Action
    
    override func addShopToPlan(_ sender: UIBarButtonItem) {
        userDetail.addShops(selectedShops)
    }
    
}
