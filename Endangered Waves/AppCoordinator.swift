//
//  AppCoordinator.swift
//  Endangered Waves
//
//  Created by Matthew Morey on 11/14/17.
//  Copyright © 2017 Save The Waves. All rights reserved.
//

import UIKit
import FirebaseAuth

final class UserMananger {

    static let shared = UserMananger()

    var user: User?
    var handle: AuthStateDidChangeListenerHandle?

    init() {

        handle = Auth.auth().addStateDidChangeListener({ (auth, user) in
            guard let user = user else {
                self.user = nil
                return
            }

            self.user = user
        })

        if user == nil {
            // User doesn't currently exist so log them in anonymously
            Auth.auth().signInAnonymously(completion: nil)
        }
    }
}

class AppCoordinator: Coordinator {

    var userManager: UserMananger!

    override func start() {
        userManager = UserMananger.shared
        showContent()
        if isFirstLaunch() {
            showOnboarding()
        } else if UserDefaultsHandler.shouldShowSurveryAlert() {
            showAppSurveyAlert()
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

    func showAppSurveyAlert() {
        let alert = UIAlertController(title: "Hello!", message: nil, preferredStyle: .alert)

        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        rootViewController.present(alert, animated: true, completion: nil)
    }

    // MARK: Miscellaneous helper functions

    func isFirstLaunch() -> Bool {
        let hasBeenLaunchedBeforeFlag = "hasBeenLaunchedBeforeFlag"
        let isFirstLaunch = !UserDefaults.standard.bool(forKey: hasBeenLaunchedBeforeFlag)
        if isFirstLaunch {
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
