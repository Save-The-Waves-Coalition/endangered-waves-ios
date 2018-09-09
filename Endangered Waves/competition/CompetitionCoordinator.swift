//
//  CompetitionCoordinator.swift
//  Endangered Waves
//
//  Created by Matthew Morey on 9/6/18.
//  Copyright © 2018 Save The Waves. All rights reserved.
//

import UIKit
import SafariServices

protocol CompetitionCoordinatorDelegate: class {
    func coordinatorDidFinishShowingCompetition(_ coordinator: CompetitionCoordinator, andShowNewReport: Bool)
}

class CompetitionCoordinator: Coordinator {

    weak var delegate: CompetitionCoordinatorDelegate?

    var competition: Competition!

    private lazy var competitionVC: CompetitionViewController = {
        let competitionVC = CompetitionViewController.instantiate()
        competitionVC.competitionDelegate = self
        competitionVC.competition = self.competition
        return competitionVC
    }()

    init(with rootViewController: UIViewController, competition: Competition) {
        super.init(with: rootViewController)
        self.competition = competition
    }

    override func start() {
        presentWithViewController(rootViewController)
    }

    func presentWithViewController(_ viewController: UIViewController) {
        addFullScreenChildViewController(viewController: competitionVC, toViewController: viewController)
    }

    override func stop() {
        stop(andShowNewReport: false)
    }

    func stop(andShowNewReport: Bool) {
        delegate?.coordinatorDidFinishShowingCompetition(self, andShowNewReport: andShowNewReport)
    }

    func removeViewControllers() {
        removeChildViewController(viewController: competitionVC, fromViewController: rootViewController)
    }

}

extension CompetitionCoordinator: CompetitionViewControllerDelegate {
    func finishedViewingCompetitionViewController(_ controller: CompetitionViewController, andShowNewReport: Bool) {
        removeViewControllers()
        stop(andShowNewReport: andShowNewReport)
    }
}
