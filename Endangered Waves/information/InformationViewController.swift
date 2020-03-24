//
//  InformationViewController.swift
//  Endangered Waves
//
//  Created by Matthew Morey on 11/21/17.
//  Copyright © 2017 Save The Waves. All rights reserved.
//

import UIKit

protocol InformationViewControllerDelegate: class {
    func viewController(_ viewController: InformationViewController, didTapDoneButton button: UIBarButtonItem)
    func viewController(_ viewController: InformationViewController, wantsToOpenURL url: URL)
    func viewController(_ viewController: InformationViewController, wantsToLaunchAppWithURL url: URL)
    func userWantsToViewTutorialWithViewController(_ viewController: InformationViewController)
}

class InformationViewController: UITableViewController {

    weak var delegate: InformationViewControllerDelegate?

    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var appVersionLabel: UILabel!

    @IBAction func didTapDoneButton(_ sender: UIBarButtonItem) {
        delegate?.viewController(self, didTapDoneButton: sender)
    }

    // View Lifecyle

    override func viewDidLoad() {
        super.viewDidLoad()

        if let infoDictionary = Bundle.main.infoDictionary,
            let version = infoDictionary["CFBundleShortVersionString"] as? String,
            let build = infoDictionary["CFBundleVersion"] as? String {
            appVersionLabel.text = "\(version) (\(build))"
        }
    }

    // Actions

    @IBAction func mjdButtonWasTapped(_ sender: UIButton) {
        let url = URL(string: "https://www.valtech.com/")!
        delegate?.viewController(self, wantsToOpenURL: url)
    }

    func isAddressIndexPath(indexPath: IndexPath) -> Bool {
        return indexPath.section == 3 && indexPath.row == 3
    }
}

// MARK: UITableViewDelegate
extension InformationViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0: // Newsletter
                let url = URL(string: "https://www.savethewaves.org/media/newsletters/newsletter-signup/")!
                delegate?.viewController(self, wantsToOpenURL: url)
            case 1: // Donation
                let url  = URL(string: "https://www.savethewaves.org/support-us/donate/")!
                delegate?.viewController(self, wantsToOpenURL: url)
            case 2: // Member
                let url  = URL(string: "https://www.savethewaves.org/member/")!
                delegate?.viewController(self, wantsToOpenURL: url)
            case 3: // Sustaining
                let url  = URL(string: "https://www.savethewaves.org/support-us/sustaining-members/")!
                delegate?.viewController(self, wantsToOpenURL: url)
            default:
                break
            }
        case 1:
            switch indexPath.row {
            case 0: // Facebook
                let url  = URL(string: "https://www.facebook.com/savethewavescoalition")!
                delegate?.viewController(self, wantsToLaunchAppWithURL: url)
            case 1: // Twitter
                let url  = URL(string: "https://twitter.com/savethewaves")!
                delegate?.viewController(self, wantsToLaunchAppWithURL: url)
            case 2: // Instagram
                let url  = URL(string: "https://www.instagram.com/savethewavescoalition")!
                delegate?.viewController(self, wantsToLaunchAppWithURL: url)
            case 3: // Youtube
                let url  = URL(string: "https://www.youtube.com/user/SaveTheWaves/videos")!
                delegate?.viewController(self, wantsToLaunchAppWithURL: url)
            case 4: // LinkedIn
                let url  = URL(string: "https://www.linkedin.com/company/save-the-waves-coalition---www.savethewaves.org/")!
                delegate?.viewController(self, wantsToLaunchAppWithURL: url)
            default:
                break
            }
        case 2:
            switch indexPath.row {
            case 0: // Tutorial
                delegate?.userWantsToViewTutorialWithViewController(self)
            case 1: // Privacy Policy
                let url  = URL(string: "https://www.savethewaves.org/about-us/privacy-policy/")!
                delegate?.viewController(self, wantsToOpenURL: url)
            default:
                break
            }
        case 3:
            switch indexPath.row {
            case 0: // App Survey
                let url  = URL(string: Constants.appSurveyURL)!
                delegate?.viewController(self, wantsToOpenURL: url)
            case 1: // Email
                let url  = URL(string: "https://www.savethewaves.org/about-us/contact-us/#contactus")!
                delegate?.viewController(self, wantsToOpenURL: url)
            case 2: // Telephone
                let url  = URL(string: "telprompt://8314266169")!
                delegate?.viewController(self, wantsToLaunchAppWithURL: url)
            case 3: // Address
                break
            default:
                break
            }
        default:
            break
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }

    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let headerView = view as? UITableViewHeaderFooterView {
            headerView.textLabel?.font = Style.fontBrandonGrotesqueBold(size: 17)
            headerView.textLabel?.textColor = UIColor.black
        }
    }

    override func tableView(_ tableView: UITableView, canPerformAction action: Selector,
                            forRowAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        guard isAddressIndexPath(indexPath: indexPath),
            action == #selector(copy(_:)) else {
                return false
        }

        return true
    }

    override func tableView(_ tableView: UITableView, shouldShowMenuForRowAt indexPath: IndexPath) -> Bool {
        guard isAddressIndexPath(indexPath: indexPath) else {
                return false
        }

        return true
    }

    override func tableView(_ tableView: UITableView, performAction action: Selector, forRowAt indexPath: IndexPath, withSender sender: Any?) {
        guard action == #selector(copy(_:)) else {
            return
        }

        UIPasteboard.general.string = addressLabel.text
    }
}

// MARK: 📖 StoryboardInstantiable
extension InformationViewController: StoryboardInstantiable {
    static var storyboardName: String { return "information" }
    static var storyboardIdentifier: String? { return "InformationComponent" }
}
