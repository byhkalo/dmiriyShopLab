//
//  AppDelegate.swift
//  studioProectoveShops
//
//  Created by Dmitriy Gaponenko on 09.09.16.
//  Copyright © 2016 Dmitriy Gaponenko. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var router: RouterManager?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        FIRApp.configure()
        
//        try! FIRAuth.auth()!.signOut()
        
        rootController { (rootController) in
            DispatchQueue.main.async {
                let navController = UINavigationController.init(rootViewController: rootController)
                
                self.router = RouterManager(navigationController: navController)
                self.configurateWindow(rootController: navController)
            }
        }
        
        let helpController = UIViewController()
        helpController.view.backgroundColor = UIColor.white
        configurateWindow(rootController: helpController)
        
        return true
    }
    
    func configurateWindow(rootController: UIViewController) {
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.rootViewController = rootController
        self.window?.makeKeyAndVisible()
    }
    
    func rootController(comletionHandler: @escaping ((UIViewController) -> ())) {
        if let _ = FIRAuth.auth()?.currentUser {
            var controller = UIViewController()

            UserModel.getCurrentUser(volunteer: { (userModel) in
                controller = userModel.isAdminSupervisor ? SupervisorMenuViewController.instantiateFromStoryboard() : ViewController.instantiateFromStoryboard()
                comletionHandler(controller)
            })
            
        } else {
            comletionHandler(SignInViewController())
        }
    }
}

