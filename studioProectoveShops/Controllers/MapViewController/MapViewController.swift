//
//  MapViewController.swift
//  studioProectoveShops
//
//  Created by Dmitriy Gaponenko on 9/13/16.
//  Copyright © 2016 Dmitriy Gaponenko. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var mapView: MKMapView!
    
    
    
    var sourceLocation: CLLocation? {
        didSet {
            addRoutesOverLayForMapView()
        }
    }
    var destinationLocation: CLLocation? {
        didSet {
            addRoutesOverLayForMapView()
        }
    }
    
    
    static func controllerFromStoryboard() -> MapViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: String(describing: MapViewController())) as! MapViewController
        return controller
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        LocationManager.sharedInstance.secondDelegate = self
        mapView.delegate = self
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        LocationManager.sharedInstance.secondDelegate = nil
        LocationManager.sharedInstance.locationManager.startUpdatingLocation()
    }
    
    func addRoutesOverLayForMapView(){
        if let sourceLocation = sourceLocation, let destinationLocation = destinationLocation {
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
            directions.calculate (completionHandler: {
                (response: MKDirectionsResponse?, error: NSError?) in
                if error == nil {
                    self.showRoute(response!)
                }
                else{
                    print("trace the error \(error?.localizedDescription)")
                }
            } as! MKDirectionsHandler)

        }
    }
    
    func showRoute(_ response:MKDirectionsResponse){
        for route in response.routes {
            mapView.add(route.polyline, level: MKOverlayLevel.aboveRoads)
//            var routeSeconds = route.expectedTravelTime
//            let routeDistance = route.distance
//            print("distance between two points is \(routeSeconds) and \(routeDistance)")
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
    
    @IBAction func backButtonAction(_ sender: AnyObject) {
        _ = navigationController?.popViewController(animated: true)
    }
}
