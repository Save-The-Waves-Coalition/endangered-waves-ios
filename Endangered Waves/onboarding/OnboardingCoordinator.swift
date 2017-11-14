//
//  OnboardingCoordinator.swift
//  Endangered Waves
//
//  Created by Matthew Morey on 11/14/17.
//  Copyright © 2017 Save The Waves. All rights reserved.
//

import UIKit

protocol OnboardingCoordinatorDelegate: class {
    func coordinatorDidFinishOnboarding(_ coordinator: OnboardingCoordinator)
}

class OnboardingCoordinator {

    weak var delegate: OnboardingCoordinatorDelegate?

    var rootViewController: UIViewController

    init(with rootViewController: UIViewController) {
        self.rootViewController = rootViewController
    }

    func start() {
        let onboardingVC = OnboardingViewController.instantiate()
        onboardingVC.delegate = self
        rootViewController.present(onboardingVC, animated: false, completion: nil)
    }

    func stop() {
        delegate?.coordinatorDidFinishOnboarding(self)
    }
}

extension OnboardingCoordinator: OnboardingViewControllerDelegate {
    func controller(_ controller: OnboardingViewController, didTapSkipButton button: UIButton) {
        rootViewController.dismiss(animated: true, completion: nil)
        stop()
    }
}
