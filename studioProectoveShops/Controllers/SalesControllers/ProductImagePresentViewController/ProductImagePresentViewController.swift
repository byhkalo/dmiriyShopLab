//
//  ProductImagePresentViewController.swift
//  studioProectoveShops
//
//  Created by Konstantyn Byhkalo on 2/8/17.
//  Copyright © 2017 Dmitriy Gaponenko. All rights reserved.
//

import UIKit
import Firebase

class ProductImagePresentViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    
    var urlString: String!
    
    var storage = FIRStorage.storage()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.storage.reference(forURL: urlString).data(withMaxSize: 25 * 2048 * 2048, completion: { (data, error) -> Void in
            let image = UIImage(data: data!)
            DispatchQueue.main.async {
                self.imageView.image = image!
            }
        })
    }

//    MARK: - Actions
    
    @IBAction func backButtonPressed(_ sender: UIBarButtonItem) {
        _ = navigationController?.popViewController(animated: true)
    }
    
}
