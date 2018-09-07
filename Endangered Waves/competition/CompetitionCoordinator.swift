//
//  CompetitionCoordinator.swift
//  Endangered Waves
//
//  Created by Matthew Morey on 9/6/18.
//  Copyright © 2018 Save The Waves. All rights reserved.
//

import UIKit

protocol CompetitionCoordinatorDelegate: class {
    func coordinatorDidFinishShowingCompetition(_ coordinator: CompetitionCoordinator)
}

class CompetitionCoordinator: Coordinator {

    weak var delegate: CompetitionCoordinatorDelegate?

    override func start() {
        presentWithViewController(rootViewController)
    }

    func presentWithViewController(_ viewController: UIViewController) {
        let competitionVC = CompetitionViewController.instantiate()
        competitionVC.competitionDelegate = self


        competitionVC.transitioningDelegate = competitionVC
        competitionVC.modalPresentationStyle = .custom

        viewController.present(competitionVC, animated: true, completion: nil)
    }

    override func stop() {
        delegate?.coordinatorDidFinishShowingCompetition(self)
    }
}

extension CompetitionCoordinator: CompetitionViewControllerDelegate {
    func controller(_ controller: CompetitionViewController, didTapCloseButton button: UIButton?) {
        controller.dismiss(animated: true, completion: nil)
        stop()
    }
}
