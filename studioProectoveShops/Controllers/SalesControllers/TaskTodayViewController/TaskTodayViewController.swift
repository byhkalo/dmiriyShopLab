//
//  TaskTodayViewController.swift
//  studioProectoveShops
//
//  Created by Dmitriy Gaponenko on 9/13/16.
//  Copyright © 2016 Dmitriy Gaponenko. All rights reserved.
//

import UIKit
import CoreLocation

class TaskTodayViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    var selectedShop: ShopModel?
    var shopsArray: [ShopModel]?
    var distanceDictionary = [String: NSNumber]()
    
    static func controllerFromStoryboard() -> TaskTodayViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: String(describing: TaskTodayViewController.classForCoder())) as! TaskTodayViewController
        return controller
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getAllShops()
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    //    MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shopsArray?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let simpleTableIdentifier = "ShopMapTableViewCell";
        var cell = tableView.dequeueReusableCell(withIdentifier: simpleTableIdentifier) as? ShopMapTableViewCell
        if (cell == nil) {
            let nib = Bundle.main.loadNibNamed(simpleTableIdentifier, owner: self, options: nil)
            cell = nib?.first as? ShopMapTableViewCell
        }
        let shop = shopsArray![indexPath.row]
        
        let distance = distanceDictionary[shop.identifier]?.floatValue
        cell?.fillByModel(shop, distance: distance!)
        
        if let selectedShop = selectedShop {
            if selectedShop.identifier == shopsArray![indexPath.row].identifier {
                tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
            }
        }
        
        return cell!
    }
    
    //    MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        selectedShop = shopsArray![indexPath.row]
        let destShop = shopsArray![indexPath.row]
        let mapViewController = MapViewController.controllerFromStoryboard()
        if indexPath.row == 0 {
            if let curretnLocation = LocationManager.sharedInstance.currentLocation {
                mapViewController.sourceLocation = curretnLocation
            } else {
                router().displayAlertTitle("Sorry", message: "We can't get your curretn Location")
            }
        } else {
            let sourceShop = shopsArray![indexPath.row - 1]
            mapViewController.sourceLocation = CLLocation(latitude: Double((sourceShop.lat)), longitude: Double((sourceShop.lon)))
        }
        mapViewController.destinationLocation = CLLocation(latitude: Double((destShop.lat)), longitude: Double((destShop.lon)))
        
         navigationController?.pushViewController(mapViewController, animated: true)
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
    //    MARK: - Sort func
    
    func sortedShopsArrayByNearestLocation(_ shopsArray: [ShopModel]) -> [ShopModel] {
        
        var validShops = [ShopModel]()
        
        for shopModel in shopsArray {
            var lastVisitDay = Converter.dateFromDayString(Converter.daySringFromDate(shopModel.lastVisitDate))
            lastVisitDay = lastVisitDay?.addingTimeInterval(24 * 60 * 60 * Double(shopModel.planFrequency))
            if Date().addingTimeInterval(24 * 60 * 60 * 2).compare(lastVisitDay!) == ComparisonResult.orderedDescending {
                validShops.append(shopModel)
            }
        }
        
        func findNearestShopToLocation(_ sourceLocation: CLLocation) -> ShopModel? {
            guard validShops.count > 0 else {
                return nil
            }
            
            var nearestShop: ShopModel!
            var distance: CLLocationDistance? = nil
            
            for shop in validShops {
                let destLocation = CLLocation(latitude: Double(shop.lat), longitude: Double(shop.lon))
                if distance == nil {
                    distance = sourceLocation.distance(from: destLocation)
                }
                
                print("search distance \(sourceLocation.distance(from: destLocation))")
                
                if sourceLocation.distance(from: destLocation) <= distance! {
                    distance = sourceLocation.distance(from: destLocation)
                    nearestShop = shop
                }
            }
            
            print("distance between locations \(distance)\n\n")
            
            validShops.remove(at: validShops.index(of: nearestShop)!)
            distanceDictionary[nearestShop.identifier] = NSNumber(value: Float(distance!))
            return nearestShop
        }
        
        var sortedArray = [ShopModel]()
        
        for i in 0..<validShops.count {
            if i == 0 {
                if let curretnLocation = LocationManager.sharedInstance.locationManager.location {
                    let nearestShopModel = findNearestShopToLocation(curretnLocation)
                    if let nearestShopModel = nearestShopModel {
                        sortedArray.append(nearestShopModel)
                    } else {
                        break
                    }
                } else {
                    router().displayAlertTitle("Sorry", message: "We can't get your curretn Location")
                }
            } else {
                
                let curretnLocation = CLLocation(latitude: Double((sortedArray.last?.lat)!), longitude: Double((sortedArray.last?.lon)!))
                let nearestShopModel = findNearestShopToLocation(curretnLocation)
                if let nearestShopModel = nearestShopModel {
                    sortedArray.append(nearestShopModel)
                } else {
                    break
                }
            }
        }
        
        return sortedArray
    }
    
    //    MARK: - Actions
    
    @IBAction func backButtonAction(_ sender: AnyObject) {
        _ = navigationController?.popViewController(animated: true)
    }
    
}
