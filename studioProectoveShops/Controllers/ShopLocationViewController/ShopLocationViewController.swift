//
//  ShopLocationViewController.swift
//  studioProectoveShops
//
//  Created by Dmitriy Gaponenko on 9/13/16.
//  Copyright © 2016 Dmitriy Gaponenko. All rights reserved.
//

import UIKit
import MapKit

class ShopLocationViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    var shopModel: ShopModel? {
        didSet {
//            showShopLocation()
        }
    }
    
    static func controllerFromStoryboard() -> ShopLocationViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: String(describing: ShopLocationViewController())) as! ShopLocationViewController
        return controller
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        showShopLocation()
    }
    
    func showShopLocation(){
        if let shopModel = shopModel {
            
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
    @IBAction func backButtonAction(_ sender: AnyObject) {
        _ = navigationController?.popViewController(animated: true)
    }
}
