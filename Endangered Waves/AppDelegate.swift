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
        let c = AppCoordinator(with: RootViewController())
        return c
    }()

    func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]? = nil) -> Bool {
        BuddyBuildSDK.setup()
        FirebaseApp.configure()
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = appCoordinator.rootViewController



        UIBarButtonItem.appearance().setTitleTextAttributes(
            [
                NSAttributedStringKey.font :  Style.fontSFProDisplaySemiBold(),
                NSAttributedStringKey.foregroundColor : Style.colorSTWBlue,
            ], for: .normal)

        UINavigationBar.appearance().titleTextAttributes = [
            NSAttributedStringKey.font: Style.fontBrandonGrotesqueBold(),
            NSAttributedStringKey.foregroundColor : UIColor.black,
        ]
        
        
        UIPageControl.appearance().pageIndicatorTintColor = UIColor(white: 1.0, alpha: 0.22)
        UIPageControl.appearance().currentPageIndicatorTintColor = UIColor.white
        UIPageControl.appearance().backgroundColor = UIColor.clear
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

class RootViewController: UIViewController {


    var statusBarShouldBeHidden = false
    override var prefersStatusBarHidden: Bool {
        return statusBarShouldBeHidden
    }

    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return .slide
    }

    override var childViewControllerForStatusBarHidden: UIViewController? {
        var childViewController: UIViewController? = nil

        for viewController in childViewControllers {
            if viewController is ContainerViewController {
                childViewController = viewController
                break
            }
        }

        return childViewController
    }

    override var childViewControllerForStatusBarStyle: UIViewController? {
        var childViewController: UIViewController? = nil

        for viewController in childViewControllers {
            if viewController is ContainerViewController {
                childViewController = viewController
                break
            }
        }

        return childViewController
    }
}
