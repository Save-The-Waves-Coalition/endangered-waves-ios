//
//  ThreatCategoryTableViewController.swift
//  Endangered Waves
//
//  Created by Tim Johnson on 2/23/21.
//  Copyright © 2021 Save The Waves. All rights reserved.
//

import Foundation
import UIKit

protocol ThreatCategoryTableViewControllerDelegate: class {
    func viewController(_ viewController: ThreatCategoryTableViewController, didSelectThreatCategory category: String)
}

class ThreatCategoryTableViewController: UITableViewController {
    @IBAction func cancelButtonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

    weak var threatCategorySelectionDelegate: ThreatCategoryTableViewControllerDelegate?
    var selectedThreatCategory: String?

    // MARK: View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Set up the nav bar title
        let label = UILabel()
        label.text = "THREAT CATEGORY".localized()
        label.adjustsFontSizeToFitWidth = true
        label.font = Style.fontBrandonGrotesqueBlack(size: 20)
        self.navigationItem.titleView = label
    }

    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if cell.textLabel?.text == selectedThreatCategory {
            cell.setSelected(true, animated: false)
        }
    }

    // MARK: UITableViewDelegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) else {
            assertionFailure("⚠️: Cell not found for selected row in Threat Category table view")
            return
        }

        guard let threatCategory = cell.textLabel?.text else {
            assertionFailure("⚠️: Cell label doesn't contain expected text in Threat Category table view")
            return
        }
        threatCategorySelectionDelegate?.viewController(self, didSelectThreatCategory: threatCategory)

        self.dismiss(animated: true, completion: nil)
    }

    // MARK: UITableViewDelegate
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView,
              let headerLabel = header.textLabel else {
            return
        }

        headerLabel.font = Style.fontBrandonGrotesqueBlack(size: 12)
    }
}
