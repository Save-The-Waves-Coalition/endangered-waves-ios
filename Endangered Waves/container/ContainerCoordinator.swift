//
//  ContainerCoordinator.swift
//  Endangered Waves
//
//  Created by Matthew Morey on 11/14/17.
//  Copyright © 2017 Save The Waves. All rights reserved.
//

import UIKit

class ContainerCoordinator: Coordinator {
    override func start() {
        let containerNavVC = ContainerNavViewController.instantiate()
        addFullScreenChildViewController(viewController: containerNavVC, toViewController: rootViewController)
    }
}
