//
//  ReportDetailViewController.swift
//  Endangered Waves
//
//  Created by Matthew Morey on 11/11/17.
//  Copyright © 2017 Save The Waves. All rights reserved.
//

import UIKit
import SDWebImage
import MapKit

protocol ReportDetailViewControllerDelegate: class {
    func finishedViewingDetailsViewController(_ viewController: ReportDetailViewController)
    func viewController(_ viewController: ReportDetailViewController, didTapImages images: [UIImage], atIndex index:Int)
}

class ReportDetailViewController: UITableViewController {

    weak var delegate: ReportDetailViewControllerDelegate?

    fileprivate lazy var imageDownloadManager = ImageDownloadManager()

    var report: Report! {
        didSet {
            if isViewLoaded {
                updateView()
            }
        }
    }

    var images: [UIImage]? {
        didSet {
            imageSliderViewController?.images = images
        }
    }

    @IBOutlet weak var imageLoadingLabel: UILabel!
    @IBOutlet weak var imageSliderContainerView: UIView!
    var imageSliderViewController: ImageSliderViewController!
    @IBOutlet weak var typeImageView: UIImageView!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var mapImageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        assert(report != nil, "Forgot to set Report dependency")
        updateView()
    }

    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: animated)
        super.viewWillAppear(animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if self.isMovingFromParentViewController {
            delegate?.finishedViewingDetailsViewController(self)
        }
    }

    func updateView() {

        title = report.type.displayString().uppercased()

        if let typeImageView = typeImageView {
            typeImageView.image = report.type.icon()
        }


        let urls:[URL] = report.imageURLs.flatMap({ (urlString) -> URL? in
            return URL(string: urlString)
        })

        imageDownloadManager.loadImagesWithURLs(urls, completion: { (images) in
            self.images = images
            self.imageSliderViewController.images = images
        })


        if let locationLabel = locationLabel {
            locationLabel.text = report.location.name
        }

        if let mapImageView = mapImageView {
            let coordinate = report.location.coordinate
            let mapSnapshotOptions = MKMapSnapshotOptions()

            // Set the region of the map that is rendered.
            let region = MKCoordinateRegionMakeWithDistance(coordinate, 1000, 1000)
            mapSnapshotOptions.region = region

            // Set the size of the image output.
            mapSnapshotOptions.size = CGSize(width: 90, height: 90)

            let snapShotter = MKMapSnapshotter(options: mapSnapshotOptions)
            snapShotter.start(completionHandler: { (snapshot, error) in
                mapImageView.alpha = 0
                mapImageView.image = snapshot?.image
                UIView.animate(withDuration: 0.25, animations: {
                    mapImageView.alpha = 1.0
                })
            })
        }

        if let descriptionLabel = descriptionLabel {
            descriptionLabel.text = report.description
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let imageSliderViewController = segue.destination as? ImageSliderViewController {
            imageSliderViewController.imageSliderViewControllerDelegate = self
            self.imageSliderViewController = imageSliderViewController
        }
    }
}

// MARK: ImageSliderViewControllerDelegate
extension ReportDetailViewController: ImageSliderViewControllerDelegate {
    func viewController(_ viewController: ImageSliderViewController, didTapImage image: UIImage, atIndex index: Int) {
        if let images = self.images {
            delegate?.viewController(self, didTapImages: images, atIndex: index)
        }
    }
}

// MARK: UITableViewDelegate
extension ReportDetailViewController {
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension // Required for description text to auto size
    }
}

// MARK: 📖 StoryboardInstantiable
extension ReportDetailViewController: StoryboardInstantiable {
    static var storyboardName: String { return "report" }
    static var storyboardIdentifier: String? { return "ReportDetailComponent" }
}
