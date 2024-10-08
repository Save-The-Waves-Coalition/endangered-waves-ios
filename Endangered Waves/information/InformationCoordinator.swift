//
//  InformationCoordinator.swift
//  Endangered Waves
//
//  Created by Matthew Morey on 11/21/17.
//  Copyright © 2017 Save The Waves. All rights reserved.
//

import UIKit
import SafariServices
import MapKit

protocol InformationCoordinatorDelegate: AnyObject {
    func coordinatorDidFinish(_ coordinator: InformationCoordinator)
}

class InformationCoordinator: Coordinator {

    weak var delegate: InformationCoordinatorDelegate?

    override func start() {
        let informationNavVC = InformationNavController.instantiate()
        if let informationVC = informationNavVC.topViewController as? InformationViewController {
            informationVC.delegate = self
            rootViewController.present(informationNavVC, animated: true, completion: nil)
        }
    }

    override func stop() {
        delegate?.coordinatorDidFinish(self)
    }

    func showOnboardingWithViewController(_ viewController: UIViewController) {
        let onboardingCoordinator = OnboardingCoordinator(with: viewController)
        onboardingCoordinator.delegate = self
        childCoordinators.append(onboardingCoordinator)
        onboardingCoordinator.presentWithViewController(viewController)
    }
}

extension InformationCoordinator: InformationViewControllerDelegate {
    func userWantsToViewTutorialWithViewController(_ viewController: InformationViewController) {
        showOnboardingWithViewController(viewController)
    }

    func viewController(_ viewController: InformationViewController, didTapDoneButton button: UIBarButtonItem) {
        viewController.dismiss(animated: true, completion: nil)
        stop()
    }

    func viewController(_ viewController: InformationViewController, wantsToOpenURL url: URL) {
        let safariViewController = SFSafariViewController(url: url)
        safariViewController.preferredControlTintColor = Style.colorSTWBlue
        viewController.present(safariViewController, animated: true, completion: nil)
    }

    func viewController(_ viewController: InformationViewController, wantsToLaunchAppWithURL url: URL) {
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: convertToUIApplicationOpenExternalURLOptionsKeyDictionary([:]), completionHandler: nil)
        }
    }
}

extension InformationCoordinator: OnboardingCoordinatorDelegate {
    func coordinatorDidFinishOnboarding(_ coordinator: OnboardingCoordinator) {
        removeChildCoordinator(coordinator)
    }
}

// Helper function inserted by Swift 4.2 migrator.
private func convertToUIApplicationOpenExternalURLOptionsKeyDictionary(_ input: [String: Any])
    -> [UIApplication.OpenExternalURLOptionsKey: Any] {
	return Dictionary(uniqueKeysWithValues: input.map { key, value in (UIApplication.OpenExternalURLOptionsKey(rawValue: key), value)})
}
