//
//  InformationCoordinator.swift
//  Endangered Waves
//
//  Created by Matthew Morey on 11/21/17.
//  Copyright © 2017 Save The Waves. All rights reserved.
//

import UIKit

protocol InformationCoordinatorDelegate: class {
    func coordinatorDidFinish(_ coordinator: InformationCoordinator)
}

class InformationCoordinator: Coordinator {

    weak var delegate: InformationCoordinatorDelegate?

    override func start() {
        let informationNavVC = InformationNavController.instantiate()
        let informationVC = informationNavVC.topViewController as! InformationViewController
        informationVC.delegate = self
        rootViewController.present(informationNavVC, animated: true, completion: nil)
    }

    override func stop() {
        delegate?.coordinatorDidFinish(self)
    }
}

extension InformationCoordinator: InformationViewControllerDelegate {
    func viewController(_ viewController: InformationViewController, didTapDoneButton button: UIBarButtonItem) {
        viewController.dismiss(animated: true, completion: nil)
        stop()
    }
}
