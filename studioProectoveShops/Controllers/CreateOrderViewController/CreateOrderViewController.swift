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

    var productsModelsArray: Array<ProductModel>!
    
    var productsOrderDictionary: Dictionary<String, NSNumber>? {
        didSet {
            if productsOrderDictionary != nil {
                updateProductTableView()
            }
        }
    }
    
    static func controllerFromStoryboard() -> CreateOrderViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewControllerWithIdentifier(String(CreateOrderViewController)) as! CreateOrderViewController
        return controller
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        productsTableView.delegate = self
        productsTableView.dataSource = self
        deliveryDatePicker.date = NSDate().dateByAddingTimeInterval(24 * 60 * 60) // set next date
    }

    func updateProductTableView() {
        ProductsManager.sharedInstance.getProducts(index: 0, count: 20)
            .on(failed: { (error) in
                print("(CreateOrderViewController) Get Error from firebase = \(error)")
                }, next: { (productsModels) in
                    var helpModelsArray = [ProductModel]()
                    for model in productsModels {
                        if (self.productsOrderDictionary![model.identifier] != nil) {
                            helpModelsArray.append(model)
                        }
                    }
                    
                    self.productsModelsArray = helpModelsArray
                    dispatch_async(dispatch_get_main_queue(), { 
                        self.productsTableView.reloadData()
                    })
            }).start()
    }
    
//    MARK: - UITableViewDataSource
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return productsOrderDictionary?.count ?? 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "cellIdentifier"
        
        var cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier)
        
        if cell == nil {
            cell = UITableViewCell(style: .Value1, reuseIdentifier: cellIdentifier)
        }
        
        let model = productsModelsArray[indexPath.row]
        
        cell?.textLabel?.text = model.name
        let value = productsOrderDictionary![model.identifier]?.integerValue
        cell?.detailTextLabel?.text = String(value ?? 0)
        
        return cell!
    }
    
//    MARK: - UITableViewDelegate

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
//    MARK: - Actions

    @IBAction func backButtonAction(sender: AnyObject) {
        navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func selectShopAction(sender: AnyObject) {
        let selectShopController = SelectShopViewController.controllerFromStoryboard()
        
        if let shopModel = shopModel {
            selectShopController.selectedShop = shopModel
        }
        selectShopController.selectBlock = { (model: ShopModel) -> () in
            self.shopModel = model
        }
        
        navigationController?.pushViewController(selectShopController, animated: true)
        print("selectShopAction")
    }

    @IBAction func selectProductAction(sender: AnyObject) {
        guard let shopModel = shopModel else {
            router().displayAlertTitle("Sorry", message: "Please, select shop firstly")
            return
        }
        
        let selectProductsController = SelectProductViewController.controllerFromStoryboard()
        selectProductsController.shopModel = shopModel
        selectProductsController.selectBlock = { (productModels: [String: NSNumber]) -> () in
            self.productsOrderDictionary = productModels
        }
        if let helpProductsArray = productsOrderDictionary {
            selectProductsController.currentOrder = helpProductsArray
        }
        
        navigationController?.pushViewController(selectProductsController, animated: true)
        print("selectProductAction")
    }
    
    @IBAction func createOrderAction(sender: AnyObject) {
        
        print("createOrderAction")
    }
    
}
