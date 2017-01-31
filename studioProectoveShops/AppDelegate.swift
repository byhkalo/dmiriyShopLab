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
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        
        
        let blogTabBarController = storyboard.instantiateViewController(withIdentifier: String(describing: ViewController.classForCoder()))
        
//        try! FIRAuth.auth()!.signOut()
        
        let rootController = FIRAuth.auth()?.currentUser == nil ? SignInViewController() : blogTabBarController
        let navController = UINavigationController.init(rootViewController: rootController)
        
        self.router = RouterManager(navigationController: navController)
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.rootViewController = navController
        self.window?.makeKeyAndVisible()
        
        return true
    }
}

