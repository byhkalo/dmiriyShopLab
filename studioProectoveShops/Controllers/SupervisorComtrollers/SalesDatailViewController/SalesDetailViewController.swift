//
//  SalesDetailViewController.swift
//  studioProectoveShops
//
//  Created by Konstantyn Byhkalo on 2/2/17.
//  Copyright © 2017 Dmitriy Gaponenko. All rights reserved.
//

import UIKit

class SalesDetailViewController: UIViewController {

    var adminSuperviser: UserModel!
    var userDetail: UserModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
//    MARK: - Actions
    
    @IBAction func dayPlanButtonPressed(_ sender: UIButton) {
        let controller = PlanListViewController.instantiateFromStoryboard()
        controller.userDetail = userDetail
        navigationController?.pushViewController(controller, animated: true)
    }

    @IBAction func allOrdersListButtonPressed(_ sender: UIButton) {
        let controller = TodayOrdersViewController.instantiateFromStoryboard()
        controller.userDetail = userDetail
        navigationController?.pushViewController(controller, animated: true)
    }
    
    @IBAction func currentLocationButtonPressed(_ sender: UIButton) {
        let controller = SalesLocationViewController.instantiateFromStoryboard()
        controller.userDetail = userDetail
        navigationController?.pushViewController(controller, animated: true)
    }
    
    @IBAction func graphsForPlanButtonPressed(_ sender: UIButton) {
        navigationController?.pushViewController(PlanGraphViewController.instantiateFromStoryboard(), animated: true)
    }
    
    @IBAction func backButtonPressed(_ sender: UIBarButtonItem) {
        _ = navigationController?.popViewController(animated: true)
    }
    
}
