//
//  SupervisorMenuViewController.swift
//  studioProectoveShops
//
//  Created by Konstantyn Byhkalo on 1/31/17.
//  Copyright © 2017 Dmitriy Gaponenko. All rights reserved.
//

import UIKit

class SupervisorMenuViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet var tableView: UITableView!
    
    var salesList: [UserModel] = []
    var adminUser: UserModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        UserModel.getCurrentUser { (userModel) in
            self.adminUser = userModel
            try! UsersManager.sharedInstance
                .getSalesConnectedToAdmin(userModel: userModel)
                .on(failed: { (error) in
                    print("Error. SupervisorMenuViewController.swift LINE 33 Error = \(error)")
                }, value: { (userModels) in
                    self.salesList = userModels
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }).start()
        }
    }
    
//    MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return salesList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellIdentifier = "SalesCellIdentifier";
        
        var cell: UITableViewCell! = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)
        if (cell == nil) {
            cell = UITableViewCell(style: .default, reuseIdentifier: cellIdentifier)
        }
        
        let saleUser = salesList[indexPath.row]
        cell.textLabel?.text = saleUser.name + " " + saleUser.identifier
        
        return cell
    }
    
//    MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let controller = SalesDetailViewController.instantiateFromStoryboard()
        controller.adminSuperviser = adminUser
        controller.userDetail = salesList[indexPath.row]
        navigationController?.pushViewController(controller, animated: true)
        
    }
    
//    MARK: - Actions
    
    @IBAction func addExtraSales(_ sender: UIButton) {
        let controller = AddSalesViewController.instantiateFromStoryboard()
        navigationController?.pushViewController(controller, animated: true)
    }
    
    @IBAction func logOutButtonPressed(_ sender: UIBarButtonItem) {
        router().logOut()
    }
    

}
