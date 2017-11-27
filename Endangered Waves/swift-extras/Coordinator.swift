//
//  Coordinator.swift
//  Endangered Waves
//
//  Created by Matthew Morey on 11/14/17.
//  Copyright © 2017 Save The Waves. All rights reserved.
//

import UIKit

class Coordinator {

    var rootViewController: UIViewController
    var childCoordinators = [AnyObject]()

    init(with rootViewController: UIViewController) {
        self.rootViewController = rootViewController
    }

    func start() {
        fatalError("Must override.")
    }

    func stop() {
        fatalError("Must override.")
    }

    func addFullScreenChildViewController(viewController: UIViewController, toViewController parentViewController: UIViewController) {
        parentViewController.addChildViewController(viewController)
        addFullScreenSubview(subView: viewController.view, toView: parentViewController.view)
        viewController.didMove(toParentViewController: parentViewController)
    }

    func removeChildViewController(viewController: UIViewController, fromViewController parentViewController: UIViewController) {
        viewController.willMove(toParentViewController: nil)
        viewController.view.removeFromSuperview()
        viewController.removeFromParentViewController()
    }

    func addFullScreenSubview(subView: UIView, toView parentView: UIView) {
        subView.translatesAutoresizingMaskIntoConstraints = false
        parentView.addSubview(subView)
        var viewBindingsDictionary = [String: AnyObject]()
        viewBindingsDictionary["subView"] = subView
        parentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[subView]|",
                                                                 options: [], metrics: nil, views: viewBindingsDictionary))
        parentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[subView]|",
                                                                 options: [], metrics: nil, views: viewBindingsDictionary))
    }

    func removeChildCoordinator(_ coordinator: Coordinator) {
        if let index = childCoordinators.index(where: { (item) -> Bool in
            return item === coordinator }) {
            childCoordinators.remove(at: index)
        } else {
            fatalError("Coordinator wasn't in child coordinator array.")
        }
    }
}
