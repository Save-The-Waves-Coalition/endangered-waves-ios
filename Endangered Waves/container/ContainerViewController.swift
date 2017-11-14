//
//  ContainerViewController.swift
//  Endangered Waves
//
//  Created by Matthew Morey on 11/7/17.
//  Copyright © 2017 Save The Waves. All rights reserved.
//

import UIKit

class ContainerViewController: UIViewController {

    @IBOutlet weak var containerView: UIView!
    
    weak var currentViewController: UIViewController?

    override func viewDidLoad() {
        currentViewController = ReportsNavMapViewController.instantiate()
        currentViewController?.view.translatesAutoresizingMaskIntoConstraints = false
        addChildViewController(currentViewController!)
        addSubview(subView: (currentViewController?.view)!, toView: containerView)
        super.viewDidLoad()
    }

    func addSubview(subView: UIView, toView parentView:UIView) {
        parentView.addSubview(subView)

        var viewBindingsDictionary = [String: AnyObject]()
        viewBindingsDictionary["subView"] = subView
        parentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[subView]|",
                                                                 options: [], metrics: nil, views: viewBindingsDictionary))
        parentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[subView]|",
                                                                 options: [], metrics: nil, views: viewBindingsDictionary))
    }

    @IBAction func mapButtonWasTapped(_ sender: UIButton) {
        showMapComponent()
    }

    @IBAction func listButtonWasTapped(_ sender: UIButton) {
        showListComponent()
    }

//    @IBAction func mapButtonWasTapped(_ sender: UIBarButtonItem) {
//        guard let identifier = currentViewController?.restorationIdentifier else {
//            // TODO what should we do here
//            return
//        }
//
//        switch identifier {
//        case "ReportsNavListComponent":
//            // Switch to map view
//            showMapComponent()
//        default:
//            // Switch to list view
//            showListComponent()
//        }
//    }

    func showMapComponent() {
        guard let identifier = currentViewController?.restorationIdentifier, identifier != "ReportsNavMapComponent" else {
            return
        }

        let viewController = ReportsNavMapViewController.instantiate()
        viewController.view.translatesAutoresizingMaskIntoConstraints = false
        cycleFromViewController(oldViewController: self.currentViewController!, toViewController: viewController)
        currentViewController = viewController
    }

    func showListComponent() {
        guard let identifier = currentViewController?.restorationIdentifier, identifier != "ReportsNavListComponent" else {
            return
        }

        let viewController = ReportsNavListViewController.instantiate()
        viewController.view.translatesAutoresizingMaskIntoConstraints = false
        cycleFromViewController(oldViewController: self.currentViewController!, toViewController: viewController)
        currentViewController = viewController
    }

    
    func cycleFromViewController(oldViewController: UIViewController, toViewController newViewController: UIViewController) {
        oldViewController.willMove(toParentViewController: nil)
        self.addChildViewController(newViewController)
        self.addSubview(subView: newViewController.view, toView:self.containerView!)
        newViewController.view.alpha = 0
        newViewController.view.layoutIfNeeded()
        UIView.animate(withDuration: 0.25, animations: {
            newViewController.view.alpha = 1
            oldViewController.view.alpha = 0
        },
                       completion: { finished in
                        oldViewController.view.removeFromSuperview()
                        oldViewController.removeFromParentViewController()
                        newViewController.didMove(toParentViewController: self)
        })
    }

}
