//
//  ViewController.swift
//  studioProectoveShops
//
//  Created by Dmitriy Gaponenko on 09.09.16.
//  Copyright © 2016 Dmitriy Gaponenko. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.setHidesBackButton(true, animated: true)
//        self.navigationController!.navigationItem.leftBarButtonItem = UIBarButtonItem()
//        self.navigationItem.leftBarButtonItem = nil
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        self.navigationController?.navigationItem.leftBarButtonItem = nil
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func mapButtonAction(sender: AnyObject) {
        print("mapButtonAction")
    }
    
    @IBAction func orderListButtonAction(sender: AnyObject) {
        print("orderListButtonAction")
    }
    
    @IBAction func shopsListButtonAction(sender: AnyObject) {
        print("shopsListButtonAction")
        navigationController?.pushViewController(ShopsListViewController.controllerFromStoryboard(), animated: true)
    }
}

