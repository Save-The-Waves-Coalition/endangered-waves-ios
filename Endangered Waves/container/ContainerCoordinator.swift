//
//  ContainerCoordinator.swift
//  Endangered Waves
//
//  Created by Matthew Morey on 11/14/17.
//  Copyright © 2017 Save The Waves. All rights reserved.
//

import UIKit

class ContainerCoordinator: Coordinator {

    weak var currentViewController: UIViewController?

    lazy var containerViewController: ContainerViewController = {
        let vc = ContainerViewController.instantiate()
        return vc
    }()

    lazy var mapNavViewController: ReportsNavMapViewController = {
        let vc = ReportsNavMapViewController.instantiate()
        let topVC = vc.topViewController as! ReportsMapViewController
        topVC.delegate = self
        return vc
    }()

    lazy var listNavViewController: ReportsNavListViewController = {
        let vc = ReportsNavListViewController.instantiate()
        let topVC = vc.topViewController as! ReportsTableViewController
        topVC.delegate = self
        return vc
    }()

    override func start() {
        containerViewController.delegate = self

        addFullScreenChildViewController(viewController: containerViewController, toViewController: rootViewController)

        containerViewController.addChildViewController(mapNavViewController)
        addFullScreenSubview(subView: mapNavViewController.view, toView: containerViewController.containerView)
        mapNavViewController.didMove(toParentViewController: containerViewController)
        currentViewController = mapNavViewController
    }

    func showMapComponent() {
        guard let identifier = currentViewController?.restorationIdentifier, identifier != "ReportsNavMapComponent" else {
            return
        }

        cycleFromViewController(oldViewController: self.currentViewController!, toViewController: mapNavViewController)
        currentViewController = mapNavViewController
    }

    func showListComponent() {
        guard let identifier = currentViewController?.restorationIdentifier, identifier != "ReportsNavListComponent" else {
            return
        }

        cycleFromViewController(oldViewController: self.currentViewController!, toViewController: listNavViewController)
        currentViewController = listNavViewController
    }

    func showAddComponent() {
        let newReportCoordinator = NewReportCoordinator(with: rootViewController)
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


    func cycleFromViewController(oldViewController: UIViewController, toViewController newViewController: UIViewController) {
        oldViewController.willMove(toParentViewController: nil)
        containerViewController.addChildViewController(newViewController)
        addFullScreenSubview(subView: newViewController.view, toView: containerViewController.containerView)
        newViewController.view.alpha = 0
        newViewController.view.layoutIfNeeded()
        UIView.animate(withDuration: 0.25, animations: {
            newViewController.view.alpha = 1
            oldViewController.view.alpha = 0
        },
                       completion: { finished in
                        oldViewController.view.removeFromSuperview()
                        oldViewController.removeFromParentViewController()
                        newViewController.didMove(toParentViewController: self.containerViewController)
        })
    }
}

// MARK: ContainerViewControllerDelegate
extension ContainerCoordinator: ContainerViewControllerDelegate {
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
    func coordinatorDidFinishNewReport(_ coordinator: NewReportCoordinator) {
        removeChildCoordinator(coordinator)
    }
}

// MARK: ReportsMapViewControllerDelegate
extension ContainerCoordinator: ReportsMapViewControllerDelegate {
    func viewController(_ viewController: ReportsMapViewController, didTapInformationButton button: UIBarButtonItem) {
        showInformationComponent()
    }
}

// MARK: ReportsTableViewControllerDelegate
extension ContainerCoordinator: ReportsTableViewControllerDelegate {
    func viewController(_ viewController: ReportsTableViewController, didTapInformationButton button: UIBarButtonItem) {
        showInformationComponent()
    }
}

// MARK: InformationCoordinatorDelegate
extension ContainerCoordinator: InformationCoordinatorDelegate {
    func coordinatorDidFinish(_ coordinator: InformationCoordinator) {
        removeChildCoordinator(coordinator)
    }
}
