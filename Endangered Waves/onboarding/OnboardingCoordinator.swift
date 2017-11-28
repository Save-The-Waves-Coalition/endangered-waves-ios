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

class OnboardingCoordinator: Coordinator {

    weak var delegate: OnboardingCoordinatorDelegate?

    override func start() {
        let onboardingVC = OnboardingViewController.instantiate()
        onboardingVC.onboardingDelegate = self
        rootViewController.present(onboardingVC, animated: false, completion: nil)
    }

    // TODO: Deviating from the `start` convention, is this okay
    func presentWithViewController(_ viewController: UIViewController) {
        let onboardingVC = OnboardingViewController.instantiate()
        onboardingVC.onboardingDelegate = self
        viewController.present(onboardingVC, animated: true, completion: nil)
    }

    override func stop() {
        delegate?.coordinatorDidFinishOnboarding(self)
    }
}

extension OnboardingCoordinator: OnboardingViewControllerDelegate {
    func controller(_ controller: OnboardingViewController, didTapSkipButton button: UIButton?) {
        controller.dismiss(animated: true, completion: nil)
        stop()
    }
}
