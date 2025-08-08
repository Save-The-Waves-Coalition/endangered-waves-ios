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
    func controller(_ controller: ContainerViewController, didTapProfileButton button: UIBarButtonItem)

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
        // MDM 2023-01-13 - No longer needed, need to redo all of the status bars do us the island with iOS 14
        // Hide the status bar
//        statusBarShouldBeHidden = true
//        UIView.animate(withDuration: 0.25) {
//            self.setNeedsStatusBarAppearanceUpdate()
//        }
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

    @IBAction func profileButtonWasTapped(_ sender: UIBarButtonItem) {
        showActionSheet()
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

//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        statusBarShouldBeHidden = false
//        UIView.animate(withDuration: 0.25) {
//            self.setNeedsStatusBarAppearanceUpdate()
//        }
//    }
//
//    var statusBarShouldBeHidden = false
//    override var prefersStatusBarHidden: Bool {
//        return statusBarShouldBeHidden
//    }
//
//    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
//        return .slide
//    }

    // Function to display Action Sheet
    @objc func showActionSheet() {
        let actionSheet = UIAlertController(title: "Choose an option", message: "", preferredStyle: .actionSheet)

        // Profile Action
        let profileAction = UIAlertAction(title: "Profile", style: .default) { _ in
            self.openProfile()
        }

        // Logout Action
//        let logoutAction = UIAlertAction(title: "Logout", style: .destructive) { _ in
//            self.showLogoutAlert(in: self)
//        }

        // Cancel Action
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)

        // Add actions to the Action Sheet
        actionSheet.addAction(profileAction)
        //actionSheet.addAction(logoutAction)
        actionSheet.addAction(cancelAction)

        // Present the Action Sheet
        present(actionSheet, animated: true, completion: nil)
    }

    // Function for Profile Action
    func openProfile() {
        // Navigate to Profile screen or show profile details
        let profileVC = ProfileViewController()
        navigationController?.pushViewController(profileVC, animated: true)
    }

    // Function for Logout Action
    func performLogout() {
        let user: AuthDataUserModel? = nil
        Global.storeModelInUserDefault(obj: user, key: .currentUser)
        self.navigationController?.popToRootViewController(animated: true)
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            appDelegate.switchToLogin()
        }
    }
    func showLogoutAlert(in viewController: UIViewController) {
        let alert = UIAlertController(title: "Are you sure?",
                                      message: "You want to logout?",
                                      preferredStyle: .alert)
        // Logout Action
        let logoutAction = UIAlertAction(title: "Logout", style: .destructive) { _ in
            self.performLogout()
        }

        // Cancel Action
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)

        // Add actions to alert
        alert.addAction(cancelAction)
        alert.addAction(logoutAction)

        // Present alert
        viewController.present(alert, animated: true, completion: nil)
    }
}

// MARK: 📖 StoryboardInstantiable
extension ContainerViewController: StoryboardInstantiable {
    static var storyboardName: String { return "container" }
    static var storyboardIdentifier: String? { return "ContainerComponent" }
}
