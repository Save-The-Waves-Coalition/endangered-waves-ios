//
//  AppCoordinator.swift
//  Endangered Waves
//
//  Created by Matthew Morey on 11/14/17.
//  Copyright © 2017 Save The Waves. All rights reserved.
//

import UIKit
import FirebaseAuth

class AppCoordinator {

    var childCoordinators = [AnyObject]()

    lazy var auth = Auth.auth()
    var authStateListenerHandle: AuthStateDidChangeListenerHandle?

    var navigationController: UINavigationController

    init(with navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        if isFirstLaunch() {
            showOnboarding()
        } else {
            showContent()
        }


        //        authStateListenerHandle = auth.addStateDidChangeListener({ (auth, user) in
        //            if let user = user {
        //                print("User is signed in: \(user)")
        //            } else {
        //                print("User is not signed in")
        //
        //                auth.signInAnonymously(completion: { (user, error) in
        //                    guard let user = user else {
        //                        if let error = error {
        //                            print("⚠️: Couldn't anonymously sign the user in \(error.localizedDescription)")
        //                        }
        //                        return
        //                    }
        //
        //
        //                    print("User is anonymously signed in: \(user)")
        //                })
        //            }
        //        })
    }

    func stop() {
        // TODO
    }

    func showContent() {
        // TODO
    }

    func showOnboarding() {
        let onboardingCoordinator = OnboardingCoordinator(with: navigationController)
        onboardingCoordinator.delegate = self
        childCoordinators.append(onboardingCoordinator)
        onboardingCoordinator.start()
    }

    func isFirstLaunch() -> Bool {
        let hasBeenLaunchedBeforeFlag = "hasBeenLaunchedBeforeFlag"
        let isFirstLaunch = !UserDefaults.standard.bool(forKey: hasBeenLaunchedBeforeFlag)
        if (isFirstLaunch) {
            UserDefaults.standard.set(true, forKey: hasBeenLaunchedBeforeFlag)
            UserDefaults.standard.synchronize()
        }
        return isFirstLaunch
    }
}

extension AppCoordinator: OnboardingCoordinatorDelegate {

    func coordinatorDidFinishOnboarding(_ coordinator: OnboardingCoordinator) {
        if let index = childCoordinators.index(where: { (item) -> Bool in
            return item === coordinator }) {
            childCoordinators.remove(at: index)
        }

        showContent()
    }
}
