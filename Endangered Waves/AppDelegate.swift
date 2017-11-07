//
//  AppDelegate.swift
//  Endangered Waves
//
//  Created by Matthew Morey on 11/1/17.
//  Copyright © 2017 Save The Waves. All rights reserved.
//

import UIKit
import Firebase
import BuddyBuildSDK

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        BuddyBuildSDK.setup()
        FirebaseApp.configure()
        return true
    }
}

