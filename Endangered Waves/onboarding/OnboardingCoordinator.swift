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
        onboardingVC.delegate = self
        addFullScreenChildViewController(viewController: onboardingVC, toViewController: rootViewController)
    }

    override func stop() {
        delegate?.coordinatorDidFinishOnboarding(self)
    }
}

extension OnboardingCoordinator: OnboardingViewControllerDelegate {
    func controller(_ controller: OnboardingViewController, didTapSkipButton button: UIButton) {
        removeChildViewController(viewController: controller, fromViewController: rootViewController)
        stop()
    }
}
