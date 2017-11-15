//
//  AppCoordinator.swift
//  Endangered Waves
//
//  Created by Matthew Morey on 11/14/17.
//  Copyright © 2017 Save The Waves. All rights reserved.
//

import UIKit
import FirebaseAuth

class AppCoordinator: Coordinator {

    override func start() {
        showContent()
        if isFirstLaunch() {
            showOnboarding()
        }
    }

    func showContent() {
        let containerCoordinator = ContainerCoordinator(with: rootViewController)
        childCoordinators.append(containerCoordinator)
        containerCoordinator.start()
    }

    func showOnboarding() {
        let onboardingCoordinator = OnboardingCoordinator(with: rootViewController)
        onboardingCoordinator.delegate = self
        childCoordinators.append(onboardingCoordinator)
        onboardingCoordinator.start()
    }

    // MARK: Miscellaneous helper functions

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

// MARK: OnboardingCoordinatorDelegate
extension AppCoordinator: OnboardingCoordinatorDelegate {
    func coordinatorDidFinishOnboarding(_ coordinator: OnboardingCoordinator) {
        removeChildCoordinator(coordinator)
    }
}


// MARK: Scratchpad

//lazy var auth = Auth.auth()
//var authStateListenerHandle: AuthStateDidChangeListenerHandle?

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
