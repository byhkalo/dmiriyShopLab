//
//  PlanShopsRoutingSalesViewController.swift
//  studioProectoveShops
//
//  Created by Konstantyn Byhkalo on 2/3/17.
//  Copyright © 2017 Dmitriy Gaponenko. All rights reserved.
//

import UIKit
import MapKit

class PlanShopsRoutingSalesViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var mapView: MKMapView!
    
    var shopsModels: [ShopModel]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        LocationManager.sharedInstance.secondDelegate = self
        mapView.delegate = self
        addRoutesOverLayForMapView()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        LocationManager.sharedInstance.secondDelegate = nil
        LocationManager.sharedInstance.locationManager.startUpdatingLocation()
    }
    
    func addRoutesOverLayForMapView(){
        
        if shopsModels.count > 1 {
            for index in 0...shopsModels.count-1 {
                configurateFor(shopOne: shopsModels[index], shopTwo: shopsModels[index+1])
            }
        }
    }
    
    func configurateFor(shopOne: ShopModel, shopTwo: ShopModel) {
        
        let sourceLocation = CLLocation(latitude: Double((shopOne.lat)), longitude: Double((shopOne.lon)))
        let destinationLocation = CLLocation(latitude: Double((shopTwo.lat)), longitude: Double((shopTwo.lon)))
        
        var source:MKMapItem?
        var destination:MKMapItem?
        let sourcePlacemark = MKPlacemark(coordinate: sourceLocation.coordinate, addressDictionary: nil)
        source = MKMapItem(placemark: sourcePlacemark)
        
        let desitnationPlacemark = MKPlacemark(coordinate: destinationLocation.coordinate, addressDictionary: nil)
        destination = MKMapItem(placemark: desitnationPlacemark)
        let request:MKDirectionsRequest = MKDirectionsRequest()
        request.source = source
        request.destination = destination
        request.transportType = MKDirectionsTransportType.walking
        
        let directions = MKDirections(request: request)
        directions.calculate(completionHandler: {(response, error) in
            if error == nil {
                self.showRoute(response!)
            }
            else{
                print("trace the error \(error?.localizedDescription)")
            }
        })

        
    }
    
    func showRoute(_ response:MKDirectionsResponse){
        for route in response.routes {
            mapView.add(route.polyline, level: MKOverlayLevel.aboveRoads)
        }
        
    }
    
    //    MARK: - CLLocationManagerDelegate
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userCoordinate = LocationManager.sharedInstance.currentLocation?.coordinate
        let eyeCoordinate = LocationManager.sharedInstance.currentLocation?.coordinate
        let mapCamera = MKMapCamera(lookingAtCenter: userCoordinate!, fromEyeCoordinate: eyeCoordinate!, eyeAltitude: 2000.0)
        mapView.camera = mapCamera
        manager.stopUpdatingLocation()
    }
    
    //    MARK: - MKMapViewDelegate
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        
        let polylineRenderer = MKPolylineRenderer(overlay: overlay)
        if (overlay is MKPolyline) {
            if mapView.overlays.count == 1 {
                polylineRenderer.strokeColor =
                    UIColor.blue.withAlphaComponent(0.75)
            } else if mapView.overlays.count == 2 {
                polylineRenderer.strokeColor =
                    UIColor.green.withAlphaComponent(0.75)
            } else if mapView.overlays.count == 3 {
                polylineRenderer.strokeColor =
                    UIColor.red.withAlphaComponent(0.75)
            }
            polylineRenderer.lineWidth = 5
        }
        return polylineRenderer
    }
    
//    MARK: - Actions
    
    @IBAction func backButtonPressed(_ sender: UIBarButtonItem) {
        _ = navigationController?.popViewController(animated: true)
    }
    
}

