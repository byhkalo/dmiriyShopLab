//
//  AuthManager.swift
//  studioProectoveShops
//
//  Created by Dmitriy Gaponenko on 09.09.16.
//  Copyright © 2016 Dmitriy Gaponenko. All rights reserved.
//


import Foundation
import ReactiveSwift
import Firebase
import FirebaseAuth

class AuthManager {    
    static let sharedInstance = AuthManager()
    
    func signalForAuthByEmail(_ email: String, password: String) -> SignalProducer <FIRUser, NSError> {
        return SignalProducer { (sink, disposable) -> () in
            FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (userSign, error) in
                if error != nil {
                    sink.send(error: error as! NSError)
                } else {
                    sink.send(value: userSign!)
                    sink.sendCompleted()
                }
            })
        }
    }
    
    func signalForRegisterUserByEmail(_ email: String, password: String, userName: String) -> SignalProducer <FIRUser, NSError> {
        return SignalProducer { (sink, disposable) -> () in
            FIRAuth.auth()?.createUser(withEmail: email, password: password,
                completion: { (newUser, error) in
                    if error != nil {
                        sink.send(error: error as! NSError)
                    }
                    
                    // save usertName
                    if let user = newUser {
                        let changeRequest = user.profileChangeRequest()
                        changeRequest.displayName = userName
                        changeRequest.commitChanges { errorChange in
                            if errorChange != nil {
                                sink.send(error: error as! NSError)
                            } else {
                                sink.send(value: newUser!)
                                sink.sendCompleted()
                            }
                        }
                    }
            })
        }
    }
}
