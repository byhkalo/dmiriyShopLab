//
//  OrdersListViewController.swift
//  studioProectoveShops
//
//  Created by Dmitriy Gaponenko on 11.09.16.
//  Copyright © 2016 Dmitriy Gaponenko. All rights reserved.
//

import UIKit
import Foundation
import ReactiveCocoa

class OrdersListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    var ordersArray: [OrderModel]?
    
    
    static func controllerFromStoryboard() -> ShopsListViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewControllerWithIdentifier(String(ShopsListViewController)) as! ShopsListViewController
        return controller
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        OrdersManager.sharedInstance.getOrders(index: 0, count: 20)
            .on(failed: { (error) in
                print("(OrdersListViewController) Get Error from firebase = \(error)")
            }) { (orderModels) in
                self.ordersArray = orderModels
                self.tableView.reloadData()
            }.start()
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    //    MARK: - UITableViewDataSource
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ordersArray?.count ?? 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let simpleTableIdentifier = "OrderTableViewCell";
        
        var cell = tableView.dequeueReusableCellWithIdentifier(simpleTableIdentifier) as? OrderTableViewCell
        if (cell == nil) {
            let nib = NSBundle.mainBundle().loadNibNamed(simpleTableIdentifier, owner: self, options: nil)
            cell = nib.first as? OrderTableViewCell
        }
        
        cell?.fillByModel(ordersArray![indexPath.row])
        
        return cell!
        
    }
    
    //    MARK: - UITableViewDelegate
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    //    MARK: - Actions
    
    @IBAction func backButtonAction(sender: AnyObject) {
        navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func addShopButtonAction(sender: AnyObject) {
        navigationController?.pushViewController(CreateShopViewController.controllerFromStoryboard(), animated: true)
    }
}
