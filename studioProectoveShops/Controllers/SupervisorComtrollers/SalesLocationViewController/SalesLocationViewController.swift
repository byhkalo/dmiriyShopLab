//
//  SalesLocationViewController.swift
//  studioProectoveShops
//
//  Created by Konstantyn Byhkalo on 2/2/17.
//  Copyright © 2017 Dmitriy Gaponenko. All rights reserved.
//

import UIKit
import MapKit

class SalesLocationViewController: UIViewController {

    @IBOutlet var mapView: MKMapView!
    
    var userDetail: UserModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        showSalesLocation()
    }
    
//    MARK: - Show Location
    
    func showSalesLocation(){
        if let userDetail = userDetail {
            
            let userLocation = CLLocation(latitude: Double(userDetail.lat), longitude: Double(userDetail.lon))
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = userLocation.coordinate
            annotation.title = userDetail.name
            mapView.addAnnotation(annotation)
            
            let userCoordinate = userLocation.coordinate
            let eyeCoordinate = userLocation.coordinate
            let mapCamera = MKMapCamera(lookingAtCenter: userCoordinate, fromEyeCoordinate: eyeCoordinate, eyeAltitude: 2000.0)
            mapView.camera = mapCamera
        }
    }
    
//    MARK: - Actions
    
    @IBAction func backButtonPressed(_ sender: UIBarButtonItem) {
        _ = navigationController?.popViewController(animated: true)
    }

}
