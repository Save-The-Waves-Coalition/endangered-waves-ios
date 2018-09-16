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

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    var appCoordinator: AppCoordinator = {
        let coordinator = AppCoordinator(with: RootViewController())
        return coordinator
    }()

    func application(_ application: UIApplication,
                     willFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {

        // If the user is listening to music, this code makes sure the music does NOT stop when taking a picture
        do {
            try AVAudioSession.sharedInstance().setCategory(.ambient, mode: .default)
        } catch {}

        FirebaseApp.configure()
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = appCoordinator.rootViewController

        styleApp()
//        listOutFonts()

        return true
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window?.makeKeyAndVisible()
        appCoordinator.start()
        return true
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

        UINavigationBar.appearance().backgroundColor = UIColor.white

        UIPageControl.appearance().pageIndicatorTintColor = UIColor(white: 1.0, alpha: 0.22)
        UIPageControl.appearance().currentPageIndicatorTintColor = UIColor.white
        UIPageControl.appearance().backgroundColor = UIColor.clear
    }

    private func listOutFonts() {
        for family: String in UIFont.familyNames {
            print("\(family)")
            for names: String in UIFont.fontNames(forFamilyName: family) {
                print("== \(names)")
            }
        }
    }
}
