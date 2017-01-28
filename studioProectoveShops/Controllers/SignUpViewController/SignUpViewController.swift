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
    
    @IBAction func signUpButtonPressed(_ sender: UIButton) {
    }
    @IBAction func signInButtonPressed(_ sender: UIButton) {
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
