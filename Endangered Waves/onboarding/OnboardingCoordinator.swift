//
//  OnboardingCoordinator.swift
//  Endangered Waves
//
//  Created by Matthew Morey on 11/14/17.
//  Copyright © 2017 Save The Waves. All rights reserved.
//

import UIKit

protocol OnboardingCoordinatorDelegate: AnyObject {
    func coordinatorDidFinishOnboarding(_ coordinator: OnboardingCoordinator)
}

class OnboardingCoordinator: Coordinator {

    weak var delegate: OnboardingCoordinatorDelegate?

    override func start() {
        presentWithViewController(rootViewController)
    }

    func presentWithViewController(_ viewController: UIViewController) {
        let onboardingVC = OnboardingViewController.instantiate()
        onboardingVC.onboardingDelegate = self
        onboardingVC.modalPresentationStyle = .fullScreen
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
