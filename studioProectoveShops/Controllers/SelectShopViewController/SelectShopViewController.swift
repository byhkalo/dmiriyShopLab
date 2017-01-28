//
//  SelectShopViewController.swift
//  studioProectoveShops
//
//  Created by Dmitriy Gaponenko on 11.09.16.
//  Copyright © 2016 Dmitriy Gaponenko. All rights reserved.
//

import UIKit
import CoreLocation

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}


typealias SelectShopBlock = (_ shopModel: ShopModel) -> ()

class SelectShopViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    var selectedShop: ShopModel?
    var selectBlock: SelectShopBlock?
    var shopsArray: [ShopModel]?
    
    static func controllerFromStoryboard() -> SelectShopViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: String(describing: SelectShopViewController())) as! SelectShopViewController
        return controller
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getAllShops()
        
        searchBar.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
    }

//    MARK: - UISearchBarDelegate
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        findShop()
    }
    
    func searchBarResultsListButtonClicked(_ searchBar: UISearchBar) {
        findShop()
    }
    
//    MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shopsArray?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let simpleTableIdentifier = "ShopTableViewCell";
        var cell = tableView.dequeueReusableCell(withIdentifier: simpleTableIdentifier) as? ShopTableViewCell
        if (cell == nil) {
            let nib = Bundle.main.loadNibNamed(simpleTableIdentifier, owner: self, options: nil)
            cell = nib?.first as? ShopTableViewCell
        }
        
        cell?.fillByModel(shopsArray![indexPath.row])
        
        if let selectedShop = selectedShop {
            if selectedShop.identifier == shopsArray![indexPath.row].identifier {
                tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
            }
        }
        
        return cell!
    }
    
//    MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedShop = shopsArray![indexPath.row]
    }
    
//    MARK: - Get Shop Functions
    
    func getAllShops() {
        ShopsManager.sharedInstance.getShops(index: 0, count: 20)
            .on(failed: { (error) in
                print("(SelectShopViewController) Get Error from firebase = \(error)")
            }) { (shopModels) in
                self.shopsArray = self.sortedShopsArrayByNearestLocation(shopModels)
                self.tableView.reloadData()
            }.start()
    }
    
    func findShop() {
        guard let searchShopName = searchBar!.text else {
            return
        }
        
        searchBar.resignFirstResponder()
        ShopsManager.sharedInstance.getShopsByName(searchShopName)
            .on(failed: { (error) in
                print("(SelectShopViewController) Get Error from firebase = \(error)")
            }) { (shopModels) in
                self.shopsArray = self.sortedShopsArrayByNearestLocation(shopModels)
                self.tableView.reloadData()
            }.start()
    }
    
//    MARK: - Sort func
    
    func sortedShopsArrayByNearestLocation(_ shopsArray: [ShopModel]) -> [ShopModel] {
        
        if let currentLocation = LocationManager.sharedInstance.currentLocation {
            
            let kShopModel = "shopModel"
            let kDistance = "distance"
            
            var presentingShopsArray: Array<Dictionary<String, AnyObject>> = Array()
            
            for (_, shopModel) in shopsArray.enumerated() {
                let shopLocation = CLLocation(latitude: Double(shopModel.lat), longitude: Double(shopModel.lon))
                let distance = currentLocation.distance(from: shopLocation)
                let dict = [kShopModel: shopModel, kDistance: NSNumber(value: Float(distance))]
                presentingShopsArray.append(dict)
            }

            presentingShopsArray.sort(by: { (dictionaryFirst, dictionaryNext) -> Bool in
                let distanceFirst = (dictionaryFirst[kDistance] as? NSNumber)?.floatValue
                let distanceNext = (dictionaryNext[kDistance] as? NSNumber)?.floatValue
                return distanceFirst < distanceNext
            })
            
            var sortedArray = [ShopModel]()
            
            for dictionary in presentingShopsArray {
                let shopModel = dictionary[kShopModel] as! ShopModel
                sortedArray.append(shopModel)
            }
            
            return sortedArray
        } else {
            
            return shopsArray
        }
    }
    
//    MARK: - Actions
    
    @IBAction func backButtonAction(_ sender: AnyObject) {
        _ = navigationController?.popViewController(animated: true)
    }
    
    @IBAction func selectShopAction(_ sender: AnyObject) {
        if let selectedShop = selectedShop {
            if let selectBlock = selectBlock {
                selectBlock(selectedShop)
            }
            _ = navigationController?.popViewController(animated: true)
        } else {
            router().displayAlertTitle("Sorry", message: "Please, select shop from list")
        }
    }
}
