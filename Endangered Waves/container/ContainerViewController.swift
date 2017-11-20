//
//  ContainerViewController.swift
//  Endangered Waves
//
//  Created by Matthew Morey on 11/7/17.
//  Copyright © 2017 Save The Waves. All rights reserved.
//

import UIKit

protocol ContainerViewControllerDelegate: class {
    func controller(_ controller: ContainerViewController, didTapMapButton button: UIButton)
    func controller(_ controller: ContainerViewController, didTapListButton button: UIButton)
    func controller(_ controller: ContainerViewController, didTapAddButton button: UIButton)
}

class ContainerViewController: UIViewController {

    weak var delegate: ContainerViewControllerDelegate?

    @IBOutlet weak var containerView: UIView!

    @IBAction func mapButtonWasTapped(_ sender: UIButton) {
        delegate?.controller(self, didTapMapButton: sender)
    }

    @IBAction func addButtonWasTapped(_ sender: UIButton) {
        // Hide the status bar
        statusBarShouldBeHidden = true
        UIView.animate(withDuration: 0.25) {
            self.setNeedsStatusBarAppearanceUpdate()
        }
        delegate?.controller(self, didTapAddButton: sender)
    }

    @IBAction func listButtonWasTapped(_ sender: UIButton) {
        delegate?.controller(self, didTapListButton: sender)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        statusBarShouldBeHidden = false
        UIView.animate(withDuration: 0.25) {
            self.setNeedsStatusBarAppearanceUpdate()
        }
    }

    var statusBarShouldBeHidden = false
    override var prefersStatusBarHidden: Bool {
        return statusBarShouldBeHidden
    }

    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return .slide
    }
}

extension ContainerViewController: StoryboardInstantiable {
    static var storyboardName: String { return "container" }
    static var storyboardIdentifier: String? { return "ContainerComponent" }
}
