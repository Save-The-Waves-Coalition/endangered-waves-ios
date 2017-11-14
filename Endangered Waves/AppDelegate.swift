//
//  AppDelegate.swift
//  Endangered Waves
//
//  Created by Matthew Morey on 11/1/17.
//  Copyright © 2017 Save The Waves. All rights reserved.
//

import UIKit
import FirebaseCore
import BuddyBuildSDK

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    var appCoordinator: AppCoordinator = {
        let c = AppCoordinator(with: UIViewController())
        return c
    }()

    func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]? = nil) -> Bool {
        BuddyBuildSDK.setup()
        FirebaseApp.configure()
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = appCoordinator.rootViewController
        return true
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        window?.makeKeyAndVisible()
        appCoordinator.start()



//        for family: String in UIFont.familyNames
//        {
//            print("\(family)")
//            for names: String in UIFont.fontNames(forFamilyName: family)
//            {
//                print("== \(names)")
//            }
//        }
        return true
    }
}
