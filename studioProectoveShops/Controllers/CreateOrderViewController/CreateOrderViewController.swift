//
//  CreateOrderViewController.swift
//  studioProectoveShops
//
//  Created by Dmitriy Gaponenko on 11.09.16.
//  Copyright © 2016 Dmitriy Gaponenko. All rights reserved.
//

import UIKit

class CreateOrderViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var shopNameLabel: UILabel!
    @IBOutlet weak var shopLastVisitDateLabel: UILabel!
    @IBOutlet weak var shopPlanFrequancyLabel: UILabel!
    @IBOutlet weak var productsTableView: UITableView!
    @IBOutlet weak var deliveryDatePicker: UIDatePicker!
    
    var shopModel: ShopModel? {
        didSet {
            if let newShopModel = shopModel {
                shopNameLabel.text = newShopModel.name
                shopLastVisitDateLabel.text = Converter.prettySringFromDate(newShopModel.lastVisitDate)
                shopPlanFrequancyLabel.text = String(newShopModel.planFrequency)
            }
        }
    }

    var productsArray: Array<String>? {
        didSet {
            if productsArray != nil {
                productsTableView.reloadData()
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

//    MARK: - UITableViewDataSource
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
//    MARK: - UITableViewDelegate

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
//    MARK: - Actions

    @IBAction func selectShopAction(sender: AnyObject) {
        print("selectShopAction")
    }

    @IBAction func selectProductAction(sender: AnyObject) {
        print("selectProductAction")
    }
    
    @IBAction func createOrderAction(sender: AnyObject) {
        print("createOrderAction")
    }
    
}
