//
//  ReportDetailViewController.swift
//  Endangered Waves
//
//  Created by Matthew Morey on 11/11/17.
//  Copyright © 2017 Save The Waves. All rights reserved.
//

import UIKit
import SDWebImage

class ReportDetailViewController: UIViewController {

    var report: Report! {
        didSet {
            if isViewLoaded {
                updateView()
            }
        }
    }

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var locationNameLabel: UILabel!
    @IBOutlet weak var latitudeLabel: UILabel!
    @IBOutlet weak var longitudeLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var creationDateLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var userLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        assert(report != nil, "Forgot to set Report dependency")
        updateView()
    }

    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: animated)
        super.viewWillAppear(animated)
    }

    func updateView() {
        title = report.location?.name ?? ""
        let url = URL(string: report.imageURLs?.first ?? "https://via.placeholder.com/150x150")
        imageView.sd_setImage(with: url, completed: nil)
        locationNameLabel.text = report.location?.name ?? "No Name!"
        latitudeLabel.text = String(describing: report.location?.coordinate?.latitude)
        longitudeLabel.text = String(describing: report.location?.coordinate?.longitude)
        descriptionLabel.text = report.description
        creationDateLabel.text = report.creationDate?.description // TODO
        typeLabel.text = report.type?.rawValue ?? "No Type!"
        userLabel.text = report.user ?? "No User!"
    }

}

// MARK: 📖 StoryboardInstantiable
extension ReportDetailViewController: StoryboardInstantiable {
    static var storyboardName: String { return "report" }
    static var storyboardIdentifier: String? { return "ReportDetailComponent" }
}
