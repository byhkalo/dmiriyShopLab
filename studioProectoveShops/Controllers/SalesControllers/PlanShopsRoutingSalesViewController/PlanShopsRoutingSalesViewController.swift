//
//  PlanShopsRoutingSalesViewController.swift
//  studioProectoveShops
//
//  Created by Konstantyn Byhkalo on 2/3/17.
//  Copyright © 2017 Dmitriy Gaponenko. All rights reserved.
//

import UIKit
import MapKit

class PlanShopsRoutingSalesViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    
    var shopsModels: [ShopModel]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        TODO: - ROUTING
    }
    
//    MARK: - Actions
    
    @IBAction func backButtonPressed(_ sender: UIBarButtonItem) {
        _ = navigationController?.popViewController(animated: true)
    }
    
}
