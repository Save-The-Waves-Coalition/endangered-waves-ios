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

    lazy var auth = Auth.auth()
    var authStateListenerHandle: AuthStateDidChangeListenerHandle?

    func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]? = nil) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        let rootViewController = ContainerNavViewController.instantiate()
        window?.rootViewController = rootViewController
        return true
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        BuddyBuildSDK.setup()
        FirebaseApp.configure()



        // TODO: Move this out of the app delegate
        authStateListenerHandle = auth.addStateDidChangeListener({ (auth, user) in
            if let user = user {
                print("User is signed in: \(user)")
            } else {
                print("User is not signed in")

                auth.signInAnonymously(completion: { (user, error) in
                    guard let user = user else {
                        if let error = error {
                            print("⚠️: Couldn't anonymously sign the user in \(error.localizedDescription)")
                        }
                        return
                    }


                    print("User is anonymously signed in: \(user)")
                })
            }
        })

        window?.makeKeyAndVisible()
        return true
    }
}

