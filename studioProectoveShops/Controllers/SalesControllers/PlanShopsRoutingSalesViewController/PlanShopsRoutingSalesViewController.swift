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
    var currentLocation: CLLocation?
    
    var routingShops = [ShopModel]()
    
    let maxShopCount = 5
    let kilometrCost = 3
    
    override func viewDidLoad() {
        super.viewDidLoad()
        LocationManager.sharedInstance.secondDelegate = self
        mapView.delegate = self
        
        currentLocation = LocationManager.sharedInstance.currentLocation
        
        if currentLocation != nil {
            findBestRouting()
            addRoutesOverLayForMapView()
        }
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        LocationManager.sharedInstance.secondDelegate = nil
        LocationManager.sharedInstance.locationManager.startUpdatingLocation()
    }
    
    
    func findBestRouting() {
        
        if shopsModels.count <= maxShopCount {
            routingShops = shopsModels
            return
        }
        
        let cs = combinationsWithoutRepetitionFrom(elements: shopsModels, taking: maxShopCount)
        
        var bestCombinationSum: Float = 0.0
        var bestCombination = [ShopModel]()
        
        for combination in cs {
            let combinationSum = calculateRouteCost(shopsModels: combination)
            if combinationSum > bestCombinationSum {
                bestCombinationSum = combinationSum
                bestCombination = combination
            }
        }
        
        routingShops = bestCombination.count == 0 ? cs.first! : bestCombination
    }

    func calculateRouteCost(shopsModels: [ShopModel]) -> Float {
        
        var distance: Float = 0.0
        var ordersBill: Float = 0.0
        
        for (index, shop) in shopsModels.enumerated(){
            
            let sourceLocation = index == 0 ? self.currentLocation : CLLocation.locationFromShop(shopsModels[index-1])
            let destLocation = CLLocation.locationFromShop(shop)
            distance += Float((sourceLocation?.distance(from: destLocation))!)
            
            if let orders = shop.orderArrayConv {
                for order in orders  {
                    ordersBill += order.totalPrice ?? 0.0
                }
            }
        }
        
        return ordersBill - (distance * Float(kilometrCost))
    }
    
//    MARK: - Sort Shops Combinations
    
    func combinationsWithoutRepetitionFrom<T>(elements: [T], taking: Int) -> [[T]] {
        guard elements.count >= taking else { return [] }
        guard elements.count > 0 && taking > 0 else { return [[]] }
        
        if taking == 1 {
            return elements.map {[$0]}
        }
        
        var combinations = [[T]]()
        for (index, element) in elements.enumerated() {
            var reducedElements = elements
            reducedElements.removeFirst(index + 1)
            combinations += combinationsWithoutRepetitionFrom(elements: reducedElements, taking: taking - 1).map {[element] + $0}
        }
        
        return combinations
    }

    
//    MARK: - Build Routing
    
    func addRoutesOverLayForMapView(){
        
        if routingShops.count > 1 {
            for (index, shop) in routingShops.enumerated() {
                
                let locationOne = index == 0 ? currentLocation : CLLocation.locationFromShop(routingShops[index-1])
                configurateFor(locationOne: locationOne!, locationTwo: CLLocation.locationFromShop(shop))
                
                if index == 0 {
                    addAnnotation(location: currentLocation!)
                }
                addAnnotation(location: CLLocation.locationFromShop(shop))
            }
        }
    }
    
    func addAnnotation(location: CLLocation) {
        let annotation = MKPointAnnotation()
        annotation.coordinate = location.coordinate
        mapView.addAnnotation(annotation)
    }
    
    func configurateFor(locationOne: CLLocation, locationTwo: CLLocation) {
        
        let sourceLocation = locationOne
        let destinationLocation = locationTwo
        
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
        
        if let location = LocationManager.sharedInstance.currentLocation, currentLocation == nil  {
            self.currentLocation = location
            findBestRouting()
            addRoutesOverLayForMapView()
        }
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
            } else {
                polylineRenderer.strokeColor =
                    UIColor.orange.withAlphaComponent(0.75)
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

extension CLLocation {
    static func locationFromShop(_ shop: ShopModel) -> CLLocation {
        return CLLocation(latitude: Double((shop.lat)), longitude: Double((shop.lon)))
    }
}
