//
//  OnboardingViewController.swift
//  Endangered Waves
//
//  Created by Matthew Morey on 11/14/17.
//  Copyright © 2017 Save The Waves. All rights reserved.
//

import UIKit

protocol OnboardingViewControllerDelegate: class {
    func controller(_ controller: OnboardingViewController, didTapSkipButton button: UIButton)
}

class OnboardingViewController: UIViewController {

    weak var delegate: OnboardingViewControllerDelegate?

    @IBAction func skipButtonWasTapped(_ sender: UIButton) {
        delegate?.controller(self, didTapSkipButton: sender)
    }
}

extension OnboardingViewController: StoryboardInstantiable {
    static var storyboardName: String { return "onboarding" }
    static var storyboardIdentifier: String? { return "OnboardingComponent" }
}
