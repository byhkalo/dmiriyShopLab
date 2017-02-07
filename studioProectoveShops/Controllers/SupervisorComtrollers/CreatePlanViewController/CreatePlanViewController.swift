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
        
        var shopsModels = [ShopModel]()
        
        ShopsManager.sharedInstance
            .getShopsConnectedUser(user: userDetail)
            .on(failed: { (error) in
                print("Error. CreatePlanViewController.swift. LINE 32. Error = \(error)")
            }) { (shopModels) in
                var planShop = [ShopModel]()
                let pickerDate = self.planDatePicker.date
                
                for helpShop in shopsModels {
                    let dayDelta = Converter.dayDelta(dateOne: pickerDate, dateTwo: helpShop.lastVisitDate)
                    
                    let fDayDelta = Float(dayDelta)
                    let fPlanFrequancy = Float(helpShop.planFrequency == 0 ? 1 : helpShop.planFrequency)
                    
                    let value = fDayDelta.truncatingRemainder(dividingBy: fPlanFrequancy)
                    if value == 0.0 {
                        planShop.append(helpShop)
                    }
                }
                shopsModels = planShop
                
                DayPlanManager.sharedInstance.createNewPlan(userModel: self.userDetail, date: pickerDate, shopsModels: shopsModels) { (isSuccess) in
                    if !isSuccess {
                        print("Error. CreatePlanViewController.swift. LINE 29. Error = Can't create plan")
                    } else {
                        self.backButtonPressed(nil)
                    }
                }
                
        }.start()
        
    }
    
    @IBAction func backButtonPressed(_ sender: UIBarButtonItem?) {
        _ = navigationController?.popViewController(animated: true)
    }
    
}
