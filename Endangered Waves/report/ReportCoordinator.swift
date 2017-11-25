//
//  ReportCoordinator.swift
//  Endangered Waves
//
//  Created by Matthew Morey on 11/25/17.
//  Copyright © 2017 Save The Waves. All rights reserved.
//

import UIKit

protocol ReportCoordinatorDelegate: class {
    func coordinatorDidFinishViewingReport(_ coordinator: ReportCoordinator)
}

class ReportCoordinator: Coordinator {

    weak var delegate: ReportCoordinatorDelegate?

    var report: Report!

    init(with rootViewController: UIViewController, report: Report) {
        super.init(with: rootViewController)
        self.report = report
    }

    override func start() {
        guard let navVC = rootViewController as? NavigationViewController else {
            return
        }
        let vc = ReportDetailViewController.instantiate()
        vc.delegate = self
        vc.report = report
        navVC.pushViewController(vc, animated: true)
    }

    override func stop() {
        delegate?.coordinatorDidFinishViewingReport(self)
    }
}

extension ReportCoordinator: ReportDetailViewControllerDelegate {
    func finishedViewingDetailsViewController(_ viewController: ReportDetailViewController) {
        stop()
    }
}
