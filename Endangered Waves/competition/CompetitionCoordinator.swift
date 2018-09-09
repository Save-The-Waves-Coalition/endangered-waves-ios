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

    // This VC just exist to capture taps to dismiss the competition modal
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
        // Show background VC to capture taps off the modal view
        addFullScreenChildViewController(viewController: backgroundVC, toViewController: viewController)

        // Show competition modal
        viewController.addChildViewController(competitionVC)

        let subView = competitionVC.view!
        let parentView = viewController.view!
        let viewBindingsDictionary = ["subView": subView]
        subView.translatesAutoresizingMaskIntoConstraints = false
        parentView.addSubview(subView)

        let height =  parentView.bounds.height * 0.6
        let width = parentView.bounds.width * 0.9
        let xCord = (parentView.bounds.width - width) / 2
        let yCord = (parentView.bounds.height - height) / 2
        let viewMetricsDictionary = ["width": width, "height": height, "xCord": xCord, "yCord": yCord]

        parentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-xCord-[subView(width)]",
                                                                 options: [], metrics: viewMetricsDictionary, views: viewBindingsDictionary))
        parentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-yCord-[subView(height)]",
                                                                 options: [], metrics: viewMetricsDictionary, views: viewBindingsDictionary))

        competitionVC.didMove(toParentViewController: viewController)
    }

    override func stop() {
        stop(andShowNewReport: false)
    }

    func stop(andShowNewReport: Bool) {
        delegate?.coordinatorDidFinishShowingCompetition(self, andShowNewReport: andShowNewReport)
    }

    func removeViewControllers() {
        removeChildViewController(viewController: competitionVC, fromViewController: rootViewController)
        removeChildViewController(viewController: backgroundVC, fromViewController: rootViewController)
    }

    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        removeViewControllers()
        stop()
    }
}

extension CompetitionCoordinator: CompetitionViewControllerDelegate {
    func finishedViewingCompetitionViewController(_ controller: CompetitionViewController, andShowNewReport: Bool) {
        removeViewControllers()
        stop(andShowNewReport: andShowNewReport)
    }
}
