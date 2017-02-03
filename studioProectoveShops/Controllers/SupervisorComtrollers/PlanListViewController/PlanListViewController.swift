//
//  PlanListViewController.swift
//  studioProectoveShops
//
//  Created by Konstantyn Byhkalo on 2/2/17.
//  Copyright © 2017 Dmitriy Gaponenko. All rights reserved.
//

import UIKit

class PlanListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet var tableView: UITableView!
    
    var userDetail: UserModel!
    var planList = [DayPlanModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        DayPlanManager.sharedInstance.getPlan(user: userDetail).on(failed: { (error) in
            print("Error. PlanListViewController.swift. LINE 29")
        }) { (dayPlanModels) in
            self.planList = dayPlanModels
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }.start()
    }
    
//    MARK: - UITableViewDataSource

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return planList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let simpleTableIdentifier = "PlanTableViewCell";
        
        var cell = tableView.dequeueReusableCell(withIdentifier: simpleTableIdentifier) as? PlanTableViewCell
        
        if (cell == nil) {
            let nib = Bundle.main.loadNibNamed(simpleTableIdentifier, owner: self, options: nil)
            cell = nib?.first as? PlanTableViewCell
        }
        
        if let cell = cell {
            let planModel = planList[indexPath.row]
            cell.fillByModel(dayPlanModel: planModel)
            return cell
        }
        
        
        return UITableViewCell()
    }
    
//    MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let controller = PlanDetailViewController.instantiateFromStoryboard()
        controller.userDetail = userDetail
        controller.dayPlanDetail = planList[indexPath.row]
        navigationController?.pushViewController(controller, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 94.0
    }
    
//    MARK: - Actions

    @IBAction func createNewPlan(_ sender: UIBarButtonItem) {
        let controller = CreatePlanViewController.instantiateFromStoryboard()
        controller.userDetail = userDetail
        navigationController?.pushViewController(controller, animated: true)
    }
    
    @IBAction func backButtonPressed(_ sender: UIBarButtonItem) {
        _ = navigationController?.popViewController(animated: true)
    }
    
}
