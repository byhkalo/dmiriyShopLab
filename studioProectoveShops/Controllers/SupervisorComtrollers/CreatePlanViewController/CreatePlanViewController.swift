//
//  CreatePlanViewController.swift
//  studioProectoveShops
//
//  Created by Konstantyn Byhkalo on 2/2/17.
//  Copyright © 2017 Dmitriy Gaponenko. All rights reserved.
//

import UIKit

class CreatePlanViewController: UIViewController {

    @IBOutlet weak var planDatePicker: UIDatePicker!
    
    var userDetail: UserModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        planDatePicker.date = Date().addingTimeInterval(24 * 60 * 60) // set next date
    }

    //    MARK: - Actions
    
    @IBAction func savePlan(_ sender: UIBarButtonItem) {
        
        DayPlanManager.sharedInstance.createNewPlan(userModel: userDetail, date: planDatePicker.date) { (isSuccess) in
            if !isSuccess {
                print("Error. CreatePlanViewController.swift. LINE 29. Error = Can't create plan")
            } else {
                self.backButtonPressed(nil)
            }
        }
    }
    
    @IBAction func backButtonPressed(_ sender: UIBarButtonItem?) {
        _ = navigationController?.popViewController(animated: true)
    }
    
}
