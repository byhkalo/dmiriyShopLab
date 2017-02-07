//
//  SaleShopListViewControiller.swift
//  studioProectoveShops
//
//  Created by Konstantyn Byhkalo on 2/7/17.
//  Copyright © 2017 Dmitriy Gaponenko. All rights reserved.
//

import UIKit

class SaleShopListViewControiller: PlanDetailViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func loadShops() {
        ShopsManager.sharedInstance
            .getShopsConnectedUser(user: userDetail)
            .on(failed: { (error) in
                print("Error. SaleShopListViewControiller.swift LINE 22. \nError = \(error)")
            }) { (shopModels) in
                self.shopsList = shopModels
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
        }.start()
    }

//    MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete:
            shopsList.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            userDetail.replaceShopsBy(shopsList)
        default:
            return
        }
    }
    
//    MARK: - Actions

    override func addExtraShopToPlan(_ sender: UIBarButtonItem) {
        let controller = AddShopToListViewController.instantiateFromStoryboard()
        controller.userDetail = userDetail
        controller.dayPlanDetail = dayPlanDetail
        navigationController?.pushViewController(controller, animated: true)
    }
    
}
