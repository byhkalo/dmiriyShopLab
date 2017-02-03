//
//  PlanShopDetailSalesViewController.swift
//  studioProectoveShops
//
//  Created by Konstantyn Byhkalo on 2/3/17.
//  Copyright © 2017 Dmitriy Gaponenko. All rights reserved.
//

import UIKit
import MapKit

class PlanShopDetailSalesViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    
    var userDetail: UserModel!
    var dayPlanDetail: DayPlanModel!
    var shopDetail: ShopModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        showShopLocation()
    }
    
//    MARK: - Present Shop
    
    func showShopLocation(){
        if let shopModel = shopDetail {
            
            let shopLocation = CLLocation(latitude: Double(shopModel.lat), longitude: Double(shopModel.lon))
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = shopLocation.coordinate
            annotation.title = shopModel.name
            mapView.addAnnotation(annotation)
            
            let userCoordinate = shopLocation.coordinate
            let eyeCoordinate = shopLocation.coordinate
            let mapCamera = MKMapCamera(lookingAtCenter: userCoordinate, fromEyeCoordinate: eyeCoordinate, eyeAltitude: 2000.0)
            mapView.camera = mapCamera
        }
    }
    
//    MARK: - Actions
    
    @IBAction func addOrderButtonPressed(_ sender: AnyObject) {
        let controller = PlanCreateOrderSalesViewController.instantiateFromStoryboard()
        controller.shopModel = shopDetail
        controller.userDetail = userDetail
        controller.dayPlanDetail = dayPlanDetail
        navigationController?.pushViewController(controller, animated: true)
    }
    
    @IBAction func backButtonPressed(_ sender: UIBarButtonItem) {
        _ = navigationController?.popViewController(animated: true)
    }
    
}
