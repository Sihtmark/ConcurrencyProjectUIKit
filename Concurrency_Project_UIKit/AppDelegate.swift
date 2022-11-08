//
//  AppDelegate.swift
//  Concurrency_Project_UIKit
//
//  Created by Sergei Poluboiarinov on 07/11/2022.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        window?.backgroundColor = .systemBackground
//        window?.rootViewController = ViewController()
        window?.rootViewController = Queue()
        
        return true
    }
}

