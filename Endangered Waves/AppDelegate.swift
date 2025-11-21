//
//  AppDelegate.swift
//  Endangered Waves
//
//  Created by Matthew Morey on 11/1/17.
//  Copyright © 2017 Save The Waves. All rights reserved.
//

import UIKit
import FirebaseCore
import AVFoundation
import IQKeyboardManagerSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    var appCoordinator: AppCoordinator = {
        let coordinator = AppCoordinator(with: RootViewController())
        return coordinator
    }()

    func application(_ application: UIApplication,
                     willFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        IQKeyboardManager.shared.isEnabled = true
        // If the user is listening to music, this code makes sure the music does NOT stop when taking a picture
        do {
            try AVAudioSession.sharedInstance().setCategory(.ambient, mode: .default)
        } catch {}

        FirebaseApp.configure()
        window = UIWindow(frame: UIScreen.main.bounds)
        styleApp()
//        listOutFonts()

        return true
    }

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window?.makeKeyAndVisible()
        // Create a reference to the the appropriate storyboard
        let storyboard = UIStoryboard(name: ContainerViewController.storyboardName, bundle: nil)

        UIApplication.shared.registerForRemoteNotifications()
        let userInfo = Global.getModelFromUserDefault(model: AuthDataUserModel.self, key: .currentUser)
        if userInfo == nil {
            if let loginVC = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController {
                window?.rootViewController = loginVC
            }
        } else {
            window?.rootViewController = appCoordinator.rootViewController
            appCoordinator.start()
        }

        return true
    }

    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let token1 = String(deviceToken: deviceToken)
        print(token1)

        let token3 = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
        print(token3)
        Global.deviceToken = token3
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        UserDefaultsHandler.incrementNumberOfLaunches()
    }

    private func styleApp() {
        UIBarButtonItem.appearance().setTitleTextAttributes([
            NSAttributedString.Key.font: Style.fontSFProDisplaySemiBold(),
            NSAttributedString.Key.foregroundColor: Style.colorSTWBlue
        ], for: .normal)

        UINavigationBar.appearance().titleTextAttributes = [
            NSAttributedString.Key.font: Style.fontBrandonGrotesqueBlack(size: 20),
            NSAttributedString.Key.foregroundColor: UIColor.black
        ]

        UINavigationBar.appearance().backgroundColor = Style.colorSTWWhite

        UIPageControl.appearance().pageIndicatorTintColor = UIColor(white: 1.0, alpha: 0.22)
        UIPageControl.appearance().currentPageIndicatorTintColor = UIColor.white
        UIPageControl.appearance().backgroundColor = UIColor.clear
    }

    // Helper function used during debugging
    private func listOutFonts() {
        for family: String in UIFont.familyNames {
            print("\(family)")
            for names: String in UIFont.fontNames(forFamilyName: family) {
                print("== \(names)")
            }
        }
    }
    func switchToLogin() {
        let storyboard = UIStoryboard(name: ContainerViewController.storyboardName, bundle: nil)
        if let loginVC = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController {
            window?.rootViewController = loginVC
        }
        window?.makeKeyAndVisible()
    }
}
