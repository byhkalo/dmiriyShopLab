//
//  UsersManager.swift
//  studioProectoveShops
//
//  Created by Konstantyn Byhkalo on 2/1/17.
//  Copyright © 2017 Dmitriy Gaponenko. All rights reserved.
//

import Foundation
import FirebaseDatabase
import FirebaseAuth
import ReactiveSwift

enum GetUserError: Error {
    case userIsNotAdmin
}

class UsersManager {
    
    static let sharedInstance = UsersManager()
    
    var ref: FIRDatabaseReference
    
    init() {
        self.ref = FIRDatabase.database().reference()
    }
    
    func getSalesConnectedToAdmin(userModel: UserModel) throws -> SignalProducer <Array<UserModel>, NSError> {
        
        return try getSales(connectedToUser: true, userModel: userModel)
    }
    
    func getSalesNotConnectedToAdmin(userModel: UserModel) throws -> SignalProducer <Array<UserModel>, NSError> {
        
        return try getSales(connectedToUser: false, userModel: userModel)
    }

    
    func getSales(connectedToUser isConnected:Bool, userModel: UserModel) throws -> SignalProducer <Array<UserModel>, NSError> {
        
        guard userModel.isAdminSupervisor == true else {
            throw GetUserError.userIsNotAdmin
        }
        
        return SignalProducer { (sink, disposable) -> () in
            self.ref.child(Constants.Users)
                .observe(FIRDataEventType.value,
                         with: { (snapshot) in
                            var userModels = [UserModel]()
                            let ownSalesList = userModel.salesList ?? [UserModel]()
                            
                            for list in snapshot.children {
                                let user = UserModel.init(snapshot: list as! FIRDataSnapshot)
                                if user.isAdminSupervisor { continue } // skip Supervisers
                                
                                var isContain = false
                                for ownUser in ownSalesList {
                                    if user.identifier == ownUser.identifier {
                                        isContain = true
                                    }
                                }
                                
                                switch (isContain, isConnected) {
                                case (true, true): userModels.append(user)
                                case (false, false): userModels.append(user)
                                default: break
                                }
                            }
                            
                            sink.send(value: userModels)
                            //                sink.sendCompleted()
                })
        }
    }


}
