//
//  SignUpViewController.swift
//  studioProectoveShops
//
//  Created by Dmitriy Gaponenko on 09.09.16.
//  Copyright © 2016 Dmitriy Gaponenko. All rights reserved.
//

import UIKit
import ReactiveSwift
import Result
import Firebase

class SignUpViewController: UIViewController, UITextFieldDelegate {

    var mainView : SignUpView? {
        return self.view as? SignUpView
    }
    
    var textFields : Array <UITextField?> {
        return [mainView?.userNameTextField, mainView?.emailTextField, mainView?.passwordTextField, mainView?.confPassTextField]
    }
    
    //MARK: - Loading View
    
    override func viewDidLoad() {
        textFieldReturnButton()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        clearTextFields()
    }
    
    //MARK: - Private
    
    fileprivate func clearTextFields() {
        self.textFields.forEach { $0?.text = "" }
    }
    
//    MARK: - Actions
    
    @IBAction func signUpButtonPressed(_ sender: UIButton) {
        guard mainView?.passwordTextField.text == mainView?.confPassTextField.text else {
            router().displayAlertTitle("Sorry", message: "Password field in't equal to confirm password field")
            return
        }
        
        var isEmpty = false
        self.textFields.forEach({ (textField) in
            if textField?.text == "" {
                isEmpty = true
            }
        })
        
        guard isEmpty == false else {
            router().displayAlertTitle("Error", message: "please check emain and password fields (any os empty)")
            return
        }
        
        AuthManager.sharedInstance.signalForRegisterUserByEmail((mainView?.emailTextField.text)!, password: (mainView?.passwordTextField.text)!, userName: (mainView?.userNameTextField.text)!)
            .on(failed: { (error) in
                router().displayAlertTitle("Error", message: "please check emain and password")
            }) { (authUser) in
                self.configurateUser(user: authUser)
                router().showBlogTabBarController()
        }.start()
    }
    
    @IBAction func signInButtonPressed(_ sender: UIButton) {
        router().showSignInController()
        print("Button SignIn pressed")
    }
    
    @IBAction func switchWalueChanged(_ sender: UISwitch) {
        mainView?.passwordTextField.isSecureTextEntry = sender.isOn
        mainView?.confPassTextField.isSecureTextEntry = sender.isOn
    }
    
    func textFieldReturnButton() {
        for (index, value) in textFields.enumerated() {
            value?.reactive.controlEvents(.primaryActionTriggered).observe({ (event) in
                let textField = event.value
                textField?.resignFirstResponder()
                if (textField! != self.textFields.last!) {
                    let helpIndex = index + 1
                    self.textFields[helpIndex]!.becomeFirstResponder()
                }
            })?.dispose()
        }
    }
}

extension SignUpViewController {
    
    func configurateUser(user: FIRUser) {
    
        let ref = FIRDatabase.database().reference()
        let usersRef = ref.child("users")
        let uProp = Constants.UserProperties.self
        
        let location = [uProp.Lat : NSNumber(floatLiteral: 0.0),
                        uProp.Lon : NSNumber(floatLiteral: 0.0)
            ] as [String : Any]
        
        let newUser = [
            uProp.UserId            : user.uid,
            uProp.DisplayName       : (user.displayName! as String),
            uProp.SupervisorID      : "",
            uProp.Location          : location,
            uProp.OrdersList        : [],
            uProp.ShopsList         : [],
            uProp.PlanList          : []
            ] as [String : Any]
        
        usersRef.child(user.uid).setValue(newUser)
        print(usersRef.child(user.uid))
    }
    
}
