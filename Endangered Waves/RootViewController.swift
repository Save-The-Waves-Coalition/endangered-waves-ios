//
//  RootViewController.swift
//  Endangered Waves
//
//  Created by Matthew Morey on 11/22/17.
//  Copyright © 2017 Save The Waves. All rights reserved.
//

import UIKit

class RootViewController: UIViewController {

    //
    // ContainerViewController handles the appearance of the status bar
    //

    var statusBarShouldBeHidden = false
    override var prefersStatusBarHidden: Bool {
        return statusBarShouldBeHidden
    }

    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return .slide
    }

    override var childForStatusBarHidden: UIViewController? {
        for viewController in children where viewController is ContainerNavViewController {
            for childViewController in viewController.children where childViewController is ContainerViewController {
                return childViewController
            }
        }
        return nil
    }

    override var childForStatusBarStyle: UIViewController? {
        for viewController in children where viewController is ContainerNavViewController {
            for childViewController in viewController.children where childViewController is ContainerViewController {
                return childViewController
            }
        }
        return nil
    }
}
