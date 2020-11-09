//
//  AppDelegate.swift
//  Movies
//
//  Created by Eugene Kurapov on 09.11.2020.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        window?.backgroundColor = .movieDarkPurple
        
        let navigationController = UINavigationController(rootViewController: CollectionsViewController())
        window?.rootViewController = navigationController
        
        return true
    }
    
}

