//
//  PlanDetailViewController.swift
//  studioProectoveShops
//
//  Created by Konstantyn Byhkalo on 2/2/17.
//  Copyright © 2017 Dmitriy Gaponenko. All rights reserved.
//

import UIKit

class PlanDetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet var tableView: UITableView!
    
    var userDetail: UserModel!
    var dayPlanDetail: DayPlanModel!
    var shopsList = [ShopModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadShops()
    }

    func loadShops() {
        DayPlanManager.sharedInstance
            .getShopsConnectedToPlan(dayPlan: dayPlanDetail)
            .on(failed: { (error) in
                print("Error.PlanDetailViewController.swift LINE 31. \nError = \(error)")
            }) { (shopModels) in
                self.shopsList = shopModels
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }.start()
    }
    
    //    MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shopsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellIdentifier = "cellIdentifier";
        
        var cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)
        
        if (cell == nil) {
            cell = UITableViewCell(style: .default, reuseIdentifier: cellIdentifier)
        }
        
        if let cell = cell {
            let shopModel = shopsList[indexPath.row]
            cell.textLabel?.text = shopModel.name + " " + shopModel.identifier
            return cell
        }
        
        
        return UITableViewCell()
    }
    
//    MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
//    MARK: - Actions
    
    @IBAction func addExtraShopToPlan(_ sender: UIBarButtonItem) {
        let controller = AddShopToPlanViewController.instantiateFromStoryboard()
        controller.userDetail = userDetail
        controller.dayPlanDetail = dayPlanDetail
        navigationController?.pushViewController(controller, animated: true)
    }
    
    @IBAction func backButtonPressed(_ sender: UIBarButtonItem) {
        _ = navigationController?.popViewController(animated: true)
    }

}
