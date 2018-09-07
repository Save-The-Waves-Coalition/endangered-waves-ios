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

    private lazy var backgroundVC: UIViewController = {
        let backgroundVC = UIViewController()
        backgroundVC.view.backgroundColor = .clear
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        backgroundVC.view.addGestureRecognizer(tap)
        return backgroundVC
    }()

    private lazy var competitionVC: CompetitionViewController = {
        let competitionVC = CompetitionViewController.instantiate()
        competitionVC.competitionDelegate = self
        competitionVC.transitioningDelegate = competitionVC
        competitionVC.modalPresentationStyle = .custom
        return competitionVC
    }()

    override func start() {
        presentWithViewController(rootViewController)
    }

    func presentWithViewController(_ viewController: UIViewController) {
        addFullScreenChildViewController(viewController: backgroundVC, toViewController: viewController)
        viewController.present(competitionVC, animated: true, completion: nil)
    }

    override func stop() {
        delegate?.coordinatorDidFinishShowingCompetition(self)
    }

    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        removeChildViewController(viewController: backgroundVC, fromViewController: rootViewController)
        competitionVC.dismiss(animated: true, completion: nil)
        stop()
    }
}

extension CompetitionCoordinator: CompetitionViewControllerDelegate {
    func controller(_ controller: CompetitionViewController, didTapCloseButton button: UIButton?) {
        removeChildViewController(viewController: backgroundVC, fromViewController: rootViewController)
        controller.dismiss(animated: true, completion: nil)
        stop()
    }
}
