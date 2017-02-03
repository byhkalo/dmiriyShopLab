//
//  PlanDetailSalesViewController.swift
//  studioProectoveShops
//
//  Created by Konstantyn Byhkalo on 2/3/17.
//  Copyright © 2017 Dmitriy Gaponenko. All rights reserved.
//

import UIKit

class PlanDetailSalesViewController: PlanDetailViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
//    MARK: - UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let controller = PlanShopDetailSalesViewController.instantiateFromStoryboard()
        let shopModel = shopsList[indexPath.row]
        controller.shopDetail = shopModel
        controller.userDetail = userDetail
        controller.dayPlanDetail = dayPlanDetail
        navigationController?.pushViewController(controller, animated: true)
    }
    
//    MARK: - Actions
    
    override func addExtraShopToPlan(_ sender: UIBarButtonItem) {
        // Configurate Routing
        let controller = PlanShopsRoutingSalesViewController.instantiateFromStoryboard()
        controller.shopsModels = shopsList
        navigationController?.pushViewController(controller, animated: true)
    }
    
}
