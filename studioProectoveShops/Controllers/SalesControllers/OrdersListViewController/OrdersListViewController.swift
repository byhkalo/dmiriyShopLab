//
//  OrdersListViewController.swift
//  studioProectoveShops
//
//  Created by Dmitriy Gaponenko on 11.09.16.
//  Copyright © 2016 Dmitriy Gaponenko. All rights reserved.
//

import UIKit
import Foundation
import ReactiveSwift

class OrdersListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    var ordersArray: [OrderModel]?
    
    
    static func controllerFromStoryboard() -> OrdersListViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: String(describing: OrdersListViewController.classForCoder())) as! OrdersListViewController
        return controller
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadOrders()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func loadOrders() {
        OrdersManager.sharedInstance.getOrders(index: 0, count: 20)
            .on(failed: { (error) in
                print("(OrdersListViewController) Get Error from firebase = \(error)")
            }) { (orderModels) in
                self.ordersArray = self.sortedOrdersArrayByCreateDate(orderModels)
                self.tableView.reloadData()
            }.start()
    }
    
    //    MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ordersArray?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let simpleTableIdentifier = "OrderTableViewCell";
        
        var cell = tableView.dequeueReusableCell(withIdentifier: simpleTableIdentifier) as? OrderTableViewCell
        if (cell == nil) {
            let nib = Bundle.main.loadNibNamed(simpleTableIdentifier, owner: self, options: nil)
            cell = nib?.first as? OrderTableViewCell
        }
        
        cell?.fillByModel(ordersArray![indexPath.row])
        
        return cell!
        
    }
    
    //    MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    //    MARK: - Sort func
    
    func sortedOrdersArrayByCreateDate(_ ordersArray: [OrderModel]) -> [OrderModel] {
        
        var sortOrders = ordersArray
        
        sortOrders.sort { (firstOrder, secondOrder) -> Bool in
            return firstOrder.createDate.compare(secondOrder.createDate as Date) == ComparisonResult.orderedDescending
        }
        
        return sortOrders
    }
    
    //    MARK: - Actions
    
    @IBAction func backButtonAction(_ sender: AnyObject) {
        _ = navigationController?.popViewController(animated: true)
    }
    
    @IBAction func addOrderButtonAction(_ sender: AnyObject) {
        navigationController?.pushViewController(CreateOrderViewController.controllerFromStoryboard(), animated: true)
    }
}
