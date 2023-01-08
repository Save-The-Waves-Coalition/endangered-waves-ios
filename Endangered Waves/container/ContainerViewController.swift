//
//  ContainerViewController.swift
//  Endangered Waves
//
//  Created by Matthew Morey on 11/7/17.
//  Copyright © 2017 Save The Waves. All rights reserved.
//

import UIKit

protocol ContainerViewControllerDelegate: AnyObject {
    func controller(_ controller: ContainerViewController, didTapMapButton button: UIButton)
    func controller(_ controller: ContainerViewController, didTapListButton button: UIButton)
    func controller(_ controller: ContainerViewController, didTapAddButton button: UIButton)
    func controller(_ controller: ContainerViewController, didTapInfoButton button: UIBarButtonItem)
}

class ContainerViewController: UIViewController {

    weak var delegate: ContainerViewControllerDelegate?

    @IBOutlet weak var containerView: UIView!

    @IBOutlet weak var mapButton: UIButton!
    @IBAction func mapButtonWasTapped(_ sender: UIButton) {
        applyActiveStyleToButton(sender)
        applyInactiveStyleToButton(listButton)
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

    @IBOutlet weak var listButton: UIButton!
    @IBAction func listButtonWasTapped(_ sender: UIButton) {
        applyActiveStyleToButton(sender)
        applyInactiveStyleToButton(mapButton)
        delegate?.controller(self, didTapListButton: sender)
    }

    @IBAction func inforButtonWasTapped(_ sender: UIBarButtonItem) {
        delegate?.controller(self, didTapInfoButton: sender)
    }

    func applyActiveStyleToButton(_ button: UIButton) {
        button.tintColor = .black
        button.isSelected = true
    }

    func applyInactiveStyleToButton(_ button: UIButton) {
        button.tintColor = Style.colorSTWGrey
        button.isSelected = false
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Set up the nav bar title
        let label = UILabel()
        label.text = "REPORTED ISSUES".localized()
        label.adjustsFontSizeToFitWidth = true
        label.font = Style.fontBrandonGrotesqueBlack(size: 20)
        self.navigationItem.titleView = label

        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil) // Hack to remove the "Back" text
        navigationItem.backBarButtonItem?.tintColor = Style.colorSTWBlue
        applyActiveStyleToButton(mapButton)
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

// MARK: 📖 StoryboardInstantiable
extension ContainerViewController: StoryboardInstantiable {
    static var storyboardName: String { return "container" }
    static var storyboardIdentifier: String? { return "ContainerComponent" }
}
