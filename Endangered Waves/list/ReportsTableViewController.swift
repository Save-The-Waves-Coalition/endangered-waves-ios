//
//  ReportsTableViewController.swift
//  Endangered Waves
//
//  Created by Matthew Morey on 11/4/17.
//  Copyright © 2017 Save The Waves. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuthUI
import FirebaseStorageUI
import FirebaseFirestoreUI

protocol ReportsTableViewControllerDelegate: AnyObject {
    func viewController(_ viewController: ReportsTableViewController, didRequestDetailsForReport report: STWDataType)
}

class ReportsTableViewController: UITableViewController {

    weak var delegate: ReportsTableViewControllerDelegate?

    lazy var dataSource: FUIFirestoreTableViewDataSource = {
        let query = Firestore.firestore().collection("reports").order(by: "creationDate", descending: true)
        let source = FUIFirestoreTableViewDataSource(query: query,
                                                     populateCell: { [unowned self] (tableView, indexPath, snapshot) -> UITableViewCell in
                                                        guard let cell = tableView.dequeueReusableCell(withIdentifier: "defaultCell",
                                                                                           for: indexPath) as? ReportsTableViewCell else {
                                                            assertionFailure("⚠️: Wrong cell type in use.")
                                                            return UITableViewCell()
                                                        }
                                                        cell.delegate = self
                                                        cell.tag = indexPath.row

                                                        if let report = Report.createReportWithSnapshot(snapshot) {
                                                            cell.report = report

                                                            let urls: [URL] = report.imageURLs.compactMap({ (urlString) -> URL? in
                                                                return URL(string: urlString)
                                                            })
                                                            cell.imageDownloadManager.loadImagesWithURLs(urls, completion: { (images) in
                                                                // when this finishes, we need to make sure we are still the same cell
                                                                if cell.tag == indexPath.row {
                                                                    cell.imageSliderViewController.images = images
                                                                    cell.imageSliderViewController.view.alpha = 1.0
                                                                }
                                                            })
            }
            return cell
        })
        return source
    }()

    // View lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource.bind(to: tableView)
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

extension ReportsTableViewController: ReportsTableViewCellProtocol {

    func didTapImage(cell: UITableViewCell) {
        guard let indexPath = tableView.indexPath(for: cell) else {
            return
        }

        tableView(tableView, didSelectRowAt: indexPath)
    }

}

// MARK: 📖 StoryboardInstantiable
extension ReportsTableViewController: StoryboardInstantiable {
    static var storyboardName: String { return "list" }
    static var storyboardIdentifier: String? { return "ReportsListComponent" }

}
