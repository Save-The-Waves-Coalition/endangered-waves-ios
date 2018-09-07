//
//  AppCoordinator.swift
//  Endangered Waves
//
//  Created by Matthew Morey on 11/14/17.
//  Copyright © 2017 Save The Waves. All rights reserved.
//

import UIKit
import FirebaseAuth
import SafariServices


// TODO: remove me when i get the comp stuff out of here
import FirebaseFirestore


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

        // TODO: Don't show survey alert if showing a competition
        showCompetitionInfo()

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
        let alert = UIAlertController(title: "Please help improve the app by taking a survey.", message: nil, preferredStyle: .alert)

        let noAction = UIAlertAction(title: "No Thanks", style: .cancel, handler: nil)
        alert.addAction(noAction)

        let okAction = UIAlertAction(title: "Yes", style: .default) { (action) in
            let url  = URL(string: Constants.appSurveyURL)!
            let safariViewController = SFSafariViewController(url: url)
            safariViewController.preferredControlTintColor = Style.colorSTWBlue
            self.rootViewController.present(safariViewController, animated: true, completion: nil)
        }
        alert.addAction(okAction)

        rootViewController.present(alert, animated: true, completion: nil)
    }

    func showCompetitionInfo() {

        let query = Firestore.firestore().collection("competitions").order(by: "startDate", descending: true)
        query.getDocuments { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    print("\(document.documentID) => \(document.data())")

                    if let competition = Competition.createCompetitionWithSnapshot(document) {

                        print("Title: \(competition.title)")
                        let rightNow = Date()
                        if rightNow.isBetween(competition.startDate, and: competition.endDate) {
                            print("Comp is on boyz!!!!")

                            let competitionCoordinator = CompetitionCoordinator(with: self.rootViewController)
                            competitionCoordinator.delegate = self
                            self.childCoordinators.append(competitionCoordinator)
                            competitionCoordinator.start()
                        }



                    }
                    
                }
            }
        }


    }

    // MARK: Miscellaneous helper functions
    // TODO: move to user defaults helper class
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

// MARK: CompetitionCoordinatorDelegate
extension AppCoordinator: CompetitionCoordinatorDelegate {
    func coordinatorDidFinishShowingCompetition(_ coordinator: CompetitionCoordinator) {
        removeChildCoordinator(coordinator)
    }
}
