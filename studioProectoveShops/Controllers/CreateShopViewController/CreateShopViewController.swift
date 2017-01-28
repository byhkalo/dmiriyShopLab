//
//  CreateShopViewController.swift
//  studioProectoveShops
//
//  Created by Dmitriy Gaponenko on 10.09.16.
//  Copyright © 2016 Dmitriy Gaponenko. All rights reserved.
//

import UIKit
import Foundation
import CoreLocation

class CreateShopViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var shopNameTextField: UITextField!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var planFrequancyPicker: UIPickerView!
    @IBOutlet weak var latLabel: UILabel!
    @IBOutlet weak var lonLabel: UILabel!
    
    var shopLocation: CLLocation?
    
    static func controllerFromStoryboard() -> CreateShopViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: String(describing: CreateShopViewController())) as! CreateShopViewController
        return controller
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        shopNameTextField.delegate = self
        addressTextField.delegate = self
        planFrequancyPicker.dataSource = self
        planFrequancyPicker.delegate = self
    }
    
//    MARK: - UITextFieldDelegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

//    MARK: - UIPickerViewDataSource
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 100
    }

//    MARK: - UIPickerViewDelegate
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let myString = String(row)
        let myAttribute = [NSForegroundColorAttributeName: UIColor.white]
        let myAttrString = NSAttributedString(string: myString, attributes: myAttribute)
        return myAttrString
    }
    
//    MARK: - Actions
    
    @IBAction func backButtonAction(_ sender: AnyObject) {
        _ = navigationController?.popViewController(animated: true)
    }
    
    @IBAction func tryToGetLocationFromAddress(_ sender: AnyObject) {
        print("tryToGetLocationFromAddress")
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(addressTextField.text!) { (placemarks, error) in
            guard let placemarks = placemarks else {
                router().displayAlertTitle("Sorry", message: "We can't find address")
                return
            }
            for (_, placemark) in placemarks.enumerated() {
                let lat = String(placemark.location!.coordinate.latitude)
                let lon = String(placemark.location!.coordinate.longitude)
                self.shopLocation = placemark.location
                print("coordinate lon = \(lon), lat = \(lat)")
                DispatchQueue.main.async {
                    self.latLabel.text = lat
                    self.lonLabel.text = lon
                }
            }
        }
    }
    
    @IBAction func getCurrentLocationAction(_ sender: AnyObject) {
        if let helpLocation = LocationManager.sharedInstance.currentLocation {
            shopLocation = helpLocation
            let lat = String(helpLocation.coordinate.latitude)
            let lon = String(helpLocation.coordinate.longitude)
            self.latLabel.text = lat
            self.lonLabel.text = lon
            print("getCurrentlocationButtonAction")
        }
    }
    
    @IBAction func createShopButtonAction(_ sender: AnyObject) {
        print("createShopButtonAction")
        guard let currentLocation = shopLocation else {
            router().displayAlertTitle("Sorry", message: "Location hasn't been selected")
            return
        }
        guard let shopName = shopNameTextField.text, shopName.characters.count > 0 else {
            router().displayAlertTitle("Sorry", message: "Input shop name")
            return
        }
        
        let lat = Float(currentLocation.coordinate.latitude)
        let lon = Float(currentLocation.coordinate.longitude)
        let planFrequancy = planFrequancyPicker.selectedRow(inComponent: 0)
        
        ShopsManager.sharedInstance.createNewShopName(shopName, lastVisitDate: Date(), lat:lat , lon: lon, planFrequency: planFrequancy) { (isSuccess) in
            router().displayAlertTitle("Success", message: "Shop has been created successfully")
        }
        
    }
}
