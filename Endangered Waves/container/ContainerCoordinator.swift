//
//  ContainerCoordinator.swift
//  Endangered Waves
//
//  Created by Matthew Morey on 11/14/17.
//  Copyright © 2017 Save The Waves. All rights reserved.
//

import UIKit
import SafariServices
import SDWebImage

class ContainerCoordinator: Coordinator {

    weak var currentViewController: UIViewController?

    lazy var containerNavViewController: ContainerNavViewController = {
        let viewController = ContainerNavViewController.instantiate()
        if let topVC = viewController.topViewController as? ContainerViewController {
            self.containerViewController = topVC
            containerViewController.delegate = self
            _ = containerViewController.view // This forces the view to load: https://stackoverflow.com/a/29322364
        }
        return viewController
    }()
    var containerViewController: ContainerViewController!

    lazy var mapViewController: ReportsMapViewController = {
        let viewController = ReportsMapViewController.instantiate()
        viewController.delegate = self
        return viewController
    }()

    lazy var listViewController: ReportsTableViewController = {
        let viewController = ReportsTableViewController.instantiate()
        viewController.delegate = self
        return viewController
    }()

    var competition: Competition?

    override func start() {
        // Add container to root
        addFullScreenChildViewController(viewController: containerNavViewController, toViewController: rootViewController)

        // Add map to container
        containerViewController.addChild(mapViewController)
        addFullScreenSubview(subView: mapViewController.view, toView: containerViewController.containerView)
        mapViewController.didMove(toParent: containerViewController)

        // Set map as the currently shown controller
        currentViewController = mapViewController
    }

    func showMapComponent() {
        guard let identifier = currentViewController?.restorationIdentifier, identifier != "ReportsMapComponent" else {
            return
        }

        cycleFromViewController(oldViewController: self.currentViewController!, toViewController: mapViewController)
        currentViewController = mapViewController
    }

    func showListComponent() {
        guard let identifier = currentViewController?.restorationIdentifier, identifier != "ReportsListComponent" else {
            return
        }

        cycleFromViewController(oldViewController: self.currentViewController!, toViewController: listViewController)
        currentViewController = listViewController
    }

    func showAddComponent() {
        let newReportCoordinator = NewReportCoordinator(with: rootViewController, andCompetition: competition)
        newReportCoordinator.delegate = self
        childCoordinators.append(newReportCoordinator)
        newReportCoordinator.start()
    }

    func showAddComponentWithCompetition(_ competition: Competition) {
        let newReportCoordinator = NewReportCoordinator(with: rootViewController, andCompetition: competition)
        newReportCoordinator.delegate = self
        childCoordinators.append(newReportCoordinator)
        newReportCoordinator.start()
    }

    func showInformationComponent() {
        let informationCoordinator = InformationCoordinator(with: rootViewController)
        informationCoordinator.delegate = self
        childCoordinators.append(informationCoordinator)
        informationCoordinator.start()
    }

    func showReportDetailsComponentForReport(_ report: Report) {
        let reportCoordinator = ReportCoordinator(with: containerNavViewController, report: report)
        reportCoordinator.delegate = self
        childCoordinators.append(reportCoordinator)
        reportCoordinator.start()
    }

    func cycleFromViewController(oldViewController: UIViewController, toViewController newViewController: UIViewController) {

        oldViewController.willMove(toParent: nil)
        containerViewController.addChild(newViewController)
        addFullScreenSubview(subView: newViewController.view, toView: containerViewController.containerView)
        newViewController.view.alpha = 0
        newViewController.view.layoutIfNeeded()
        UIView.animate(withDuration: 0.25, animations: {
            newViewController.view.alpha = 1
            oldViewController.view.alpha = 0
        },
                       completion: { finished in
                        oldViewController.view.removeFromSuperview()
                        oldViewController.removeFromParent()
                        newViewController.didMove(toParent: self.containerViewController)
        })

    }

    fileprivate func showTakeAction() {
        let url = URL(string: "http://www.savethewaves.org/endangered-waves/take-action/")!
        let safariViewController = SFSafariViewController(url: url)
        safariViewController.preferredControlTintColor = Style.colorSTWBlue
        self.containerViewController.present(safariViewController, animated: true, completion: nil)
    }

    fileprivate func showSharingWithReport(_ report: Report) {
        if let firstImageURLString = report.imageURLs.first, let firstImageURL = URL(string: firstImageURLString) {
            SDWebImageManager.shared().loadImage(with: firstImageURL,
                                                 options: [],
                                                 progress: nil,
                                                 completed: { (image, data, error, cacheType, finished, imageURL) in
                if let image = image {
                    let imageActivity = ImageActivity(image: image)
                    let shareText = "\(report.description) \(report.type.hashTagString()) #endangeredwaves"
                    let messageActivity = TextActivity(message: shareText)

                    let activityItems: [Any] = [imageActivity, messageActivity]

                    let activityViewController = UIActivityViewController(activityItems: activityItems, applicationActivities: [])
                    self.containerViewController.present(activityViewController, animated: true, completion: nil)
                }
            })
        }
    }

    fileprivate func showSuccessfulSubmissionAlertWithReport(_ report: Report) {

        // swiftlint:disable line_length
        var message = """
            Thank you for being a part of the solution. We'll make sure the right people see this report. Please help us out by taking action and sharing your report.
            """
        if report.type == .competition {
            if let competition = competition {
                message = """
                Thank you for being a part of the solution. We'll announce the winner of the \(competition.title) shortly after the end of the challenge. Please help us out by taking action and sharing your report.
                """
            } else {
                message = """
                Thank you for being a part of the solution. We'll announce the winner of the Challenge shortly after the end of the challenge. Please help us out by taking action and sharing your report.
                """
            }
        }
        // swiftlint:enable line_length

        let alertViewController = UIAlertController(title: "Thank You 🤙",
                                                    message: message,
                                                    preferredStyle: .actionSheet)

        let takeAction = UIAlertAction(title: "Take Action", style: .default, handler: { (_) in
            self.showTakeAction()
        })
        alertViewController.addAction(takeAction)

        let shareAction = UIAlertAction(title: "Share Issue", style: .default, handler: { (_) in
            self.showSharingWithReport(report)
        })
        alertViewController.addAction(shareAction)

        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertViewController.addAction(okAction)

        self.containerViewController.present(alertViewController, animated: true, completion: nil)
    }
}

// MARK: ContainerViewControllerDelegate
extension ContainerCoordinator: ContainerViewControllerDelegate {
    func controller(_ controller: ContainerViewController, didTapInfoButton button: UIBarButtonItem) {
        showInformationComponent()
    }

    func controller(_ controller: ContainerViewController, didTapMapButton button: UIButton) {
        showMapComponent()
    }

    func controller(_ controller: ContainerViewController, didTapListButton button: UIButton) {
        showListComponent()
    }

    func controller(_ controller: ContainerViewController, didTapAddButton button: UIButton) {
        showAddComponent()
    }
}

// MARK: NewReportCoordinatorDelegate
extension ContainerCoordinator: NewReportCoordinatorDelegate {
    func coordinator(_ coordinator: NewReportCoordinator, didFinishNewReport report: Report?) {
        removeChildCoordinator(coordinator)
        if let report = report {
            showSuccessfulSubmissionAlertWithReport(report)
        }
    }
}

// MARK: ReportsMapViewControllerDelegate
extension ContainerCoordinator: ReportsMapViewControllerDelegate {
    func viewController(_ viewController: ReportsMapViewController, didRequestDetailsForReport report: Report) {
        showReportDetailsComponentForReport(report)
    }
}

// MARK: ReportsTableViewControllerDelegate
extension ContainerCoordinator: ReportsTableViewControllerDelegate {
    func viewController(_ viewController: ReportsTableViewController, didRequestDetailsForReport report: Report) {
        showReportDetailsComponentForReport(report)
    }
}

// MARK: InformationCoordinatorDelegate
extension ContainerCoordinator: InformationCoordinatorDelegate {
    func coordinatorDidFinish(_ coordinator: InformationCoordinator) {
        removeChildCoordinator(coordinator)
    }
}

// MARK: ReportCoordinatorDelegate
extension ContainerCoordinator: ReportCoordinatorDelegate {
    func coordinatorDidFinishViewingReport(_ coordinator: ReportCoordinator) {
        removeChildCoordinator(coordinator)
    }
}
