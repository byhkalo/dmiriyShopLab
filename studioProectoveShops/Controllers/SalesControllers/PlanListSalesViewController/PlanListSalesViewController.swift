//
//  PlanListSalesViewController.swift
//  studioProectoveShops
//
//  Created by Konstantyn Byhkalo on 2/3/17.
//  Copyright © 2017 Dmitriy Gaponenko. All rights reserved.
//

import UIKit

class PlanListSalesViewController: PlanListViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let controller = PlanDetailSalesViewController.instantiateFromStoryboard()
        controller.userDetail = userDetail
        controller.dayPlanDetail = planList[indexPath.row]
        navigationController?.pushViewController(controller, animated: true)
    }
}
