//
//  TodayOrdersViewController.swift
//  studioProectoveShops
//
//  Created by Konstantyn Byhkalo on 2/2/17.
//  Copyright © 2017 Dmitriy Gaponenko. All rights reserved.
//

import UIKit

class TodayOrdersViewController: OrdersListViewController {

//    @IBOutlet var tableView: UITableView!
    
    var userDetail: UserModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func loadOrders() {
        DayPlanManager.sharedInstance
            .getPlan(user: userDetail)
            .on(failed: { print("Error. TodayOrdersViewController.swift LINE 25 \nError = \($0)") })
            { (dayPlanModels) in
                let todayDString = Converter.daySringFromDate(Date())
                
                var findPlan: DayPlanModel?
                
                for plan in dayPlanModels {
                    let planStringDate = Converter.daySringFromDate(plan.date)
                    if todayDString == planStringDate {
                        findPlan = plan
                        break
                    }
                }
                if let findPlan = findPlan {
                    self.ordersArray = findPlan.ordersList ?? [OrderModel]()
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
            }.start()
    }
    
    //    MARK: - Actions
    
    @IBAction func backButtonPressed(_ sender: UIBarButtonItem) {
        _ = navigationController?.popViewController(animated: true)
    }

}
