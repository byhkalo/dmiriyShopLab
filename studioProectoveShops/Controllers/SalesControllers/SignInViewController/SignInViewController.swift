//
//  SignInViewController.swift
//  studioProectoveShops
//
//  Created by Dmitriy Gaponenko on 09.09.16.
//  Copyright © 2016 Dmitriy Gaponenko. All rights reserved.
//

import UIKit
import ReactiveSwift
import Result

class SignInViewController: UIViewController {
    
    var mainView : SignInView! {
        return self.view as? SignInView
    }
    
    //MARK: - Loading View
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func signInButtonPressed(_ sender: UIButton) {
        AuthManager.sharedInstance
            .signalForAuthByEmail(mainView.emailField.text!, password: mainView.passwordField.text!)
            .on(failed: { (error) in
                router().displayAlertTitle("Error", message: "please check emain and password \n Error: \(error)")
            }) { (authUser) in
                UserModel.getCurrentUser(volunteer: { (helpUserModel) in
                    if helpUserModel.isAdminSupervisor {
                        router().showSupervisorMenuViewController()
                    } else {
                        router().showBlogTabBarController()
                    }
                })
                
            }.start()
    }
    
    @IBAction func signUpButtonPressed(_ sender: UIButton) {
        router().showSignUpController()
        print("Button SignUp pressed")
    }
    
}
