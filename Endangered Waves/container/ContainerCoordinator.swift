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

    var containerViewController: ContainerViewController = {
        let vc = ContainerViewController.instantiate()
        return vc
    }()

    var mapNavViewController: ReportsNavMapViewController = {
        let vc = ReportsNavMapViewController.instantiate()
        vc.view.translatesAutoresizingMaskIntoConstraints = false
        return vc
    }()

    var listNavViewController: ReportsNavListViewController = {
        let vc = ReportsNavListViewController.instantiate()
        vc.view.translatesAutoresizingMaskIntoConstraints = false
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

extension ContainerCoordinator: ContainerViewControllerDelegate {
    func controller(_ controller: ContainerViewController, didTapMapButton button: UIButton) {
        print("stop it map")
        showMapComponent()
    }

    func controller(_ controller: ContainerViewController, didTapListButton button: UIButton) {
        print("stop it list")
        showListComponent()
    }

    func controller(_ controller: ContainerViewController, didTapAddButton button: UIButton) {
        print("stop it add")
    }
}
