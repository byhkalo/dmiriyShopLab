//
//  AddSalesViewController.swift
//  studioProectoveShops
//
//  Created by Konstantyn Byhkalo on 2/1/17.
//  Copyright © 2017 Dmitriy Gaponenko. All rights reserved.
//

import UIKit

class AddSalesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet var tableView: UITableView!
    var extraSales = [UserModel]()
    var selectedUsers = [UserModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        UserModel.getCurrentUser { (userModel) in
            do {
                try UsersManager.sharedInstance
                    .getSalesNotConnectedToAdmin(userModel: userModel)
                    .on(failed: { (error) in print("Error: \(error)")
                    }, value: { (userModels) in
                        self.extraSales = userModels
                        self.tableView.reloadData()
                    }).start()
            } catch {
                print("Check user model")
            }
        }
    }

//    MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return extraSales.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellIdentifier = "cellIdentifier"
        var cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)
        
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: cellIdentifier)
        }
        
        if let cell = cell {
            let userModel = extraSales[indexPath.row]
            cell.textLabel?.text = "ExSl " + userModel.name
            return cell
        }
        
        return UITableViewCell()
    }
    
//    MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedUsers.append(extraSales[indexPath.row])
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        selectedUsers.remove(at: selectedUsers.index(of: extraSales[indexPath.row])!)
    }
    
//    MARK: - Actions
    
    @IBAction func backButtonPressed(_ sender: UIBarButtonItem) {
        _ = navigationController?.popViewController(animated: true)
    }
    
    @IBAction func saveButtonPressed(_ sender: UIBarButtonItem) {
        UserModel.getCurrentUser { (userModel) in
            userModel.addSales(self.selectedUsers)
        }
    }
    
}
