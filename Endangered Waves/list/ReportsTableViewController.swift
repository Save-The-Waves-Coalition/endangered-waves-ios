//
//  ReportsTableViewController.swift
//  Endangered Waves
//
//  Created by Matthew Morey on 11/4/17.
//  Copyright © 2017 Save The Waves. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestoreUI

protocol ReportsTableViewControllerDelegate: class {
    func viewController(_ viewController: ReportsTableViewController, didRequestDetailsForReport report: Report)
}

class ReportsTableViewController: UITableViewController {

    weak var delegate: ReportsTableViewControllerDelegate?

    lazy var dataSource: FUIFirestoreTableViewDataSource = {
        let query = Firestore.firestore().collection("reports").order(by: "creationDate", descending: true)
        let source = FUIFirestoreTableViewDataSource(query: query,
                                                     populateCell: { [unowned self] (tableView, indexPath, snapshot) -> UITableViewCell in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "defaultCell", for: indexPath) as? ReportsTableViewCell else {
                assertionFailure("⚠️: Wrong cell type in use.")
                return UITableViewCell()
            }

            if let report = Report.createReportWithSnapshot(snapshot) {
                cell.report = report
            }
            return cell
        })
        return source
    }()

    // View lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource.bind(to: tableView)
        if traitCollection.forceTouchCapability == .available {
            // TODO: Coordinator should take care of this
            registerForPreviewing(with: self, sourceView: view)
        }
    }
}

// MARK: UITableViewDelegate
extension ReportsTableViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cellVC = tableView.cellForRow(at: indexPath) as? ReportsTableViewCell {
            delegate?.viewController(self, didRequestDetailsForReport: cellVC.report)
        }
    }
}

// MARK: 🎑 UIViewControllerPreviewingDelegate
extension ReportsTableViewController: UIViewControllerPreviewingDelegate {
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        // TODO: Coordinator should take care of this
        let cellPosition = tableView.convert(location, from: previewingContext.sourceView)
        guard let cellIndexPath = tableView.indexPathForRow(at: cellPosition),
            let cellView = tableView.cellForRow(at: cellIndexPath) as? ReportsTableViewCell,
            let report = cellView.report else {
            return nil
        }

        let detailVC = ReportDetailViewController.instantiate()
        detailVC.report = report
        previewingContext.sourceRect = cellView.frame

        return detailVC
    }

    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        // TODO: Coordinator should take care of this
        navigationController?.pushViewController(viewControllerToCommit, animated: true)
    }
}

// MARK: 📖 StoryboardInstantiable
extension ReportsTableViewController: StoryboardInstantiable {
    static var storyboardName: String { return "list" }
    static var storyboardIdentifier: String? { return "ReportsListComponent" }

}
