//
//  AddShopToPlanViewController.swift
//  studioProectoveShops
//
//  Created by Konstantyn Byhkalo on 2/2/17.
//  Copyright © 2017 Dmitriy Gaponenko. All rights reserved.
//

import UIKit

class AddShopToPlanViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet var tableView: UITableView!
    
    var userDetail: UserModel!
    var dayPlanDetail: DayPlanModel!
    
    var shopsList = [ShopModel]()
    var selectedShops = [ShopModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        DayPlanManager.sharedInstance
            .getShopsNotConnectedToPlan(dayPlan: dayPlanDetail)
            .on(failed: { (error) in
                print("Error. AddShopToPlanViewController.swift LINE 32 \nError = \(error.debugDescription)")
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
        selectedShops.append(shopsList[indexPath.row])
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        selectedShops.remove(at: selectedShops.index(of: shopsList[indexPath.row])!)
    }
    
    //    MARK: - Actions
    
    @IBAction func addShopToPlan(_ sender: UIBarButtonItem) {
        dayPlanDetail.addShops(selectedShops)
    }
    
    @IBAction func backButtonPressed(_ sender: UIBarButtonItem?) {
        _ = navigationController?.popViewController(animated: true)
    }
    
}
