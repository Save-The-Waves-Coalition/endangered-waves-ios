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
import SafariServices

protocol ReportDetailViewControllerDelegate: class {
    func finishedViewingDetailsViewController(_ viewController: ReportDetailViewController)
    func viewController(_ viewController: ReportDetailViewController, didTapImages images: [UIImage], atIndex index: Int)
    func showMapDetail()
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

    @IBOutlet weak var shareBarButtonItem: UIBarButtonItem!
    @IBOutlet weak var imageLoadingLabel: UILabel!
    @IBOutlet weak var imageSliderContainerView: UIView!
    var imageSliderViewController: ImageSliderViewController!
    @IBOutlet weak var typeImageView: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var mapPinImageView: UIImageView!
    @IBOutlet weak var mapButton: UIButton!

    // View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        assert(report != nil, "Forgot to set Report dependency")
        updateView()
    }

    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: animated) // TODO: Do we  need this anymore?
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
            typeImageView.image = report.type.placemarkIcon()
        }

        let urls: [URL] = report.imageURLs.flatMap({ (urlString) -> URL? in
            return URL(string: urlString)
        })

        self.navigationItem.rightBarButtonItem?.isEnabled = false // Disable sharing until the image is loaded
        imageDownloadManager.loadImagesWithURLs(urls, completion: { (images) in
            self.images = images
            self.imageSliderViewController.images = images
            self.navigationItem.rightBarButtonItem?.isEnabled = true
        })

        if let dateLabel = dateLabel {
            dateLabel.text = "– \(report.dateDisplayString()) –"
        }

        if let locationLabel = locationLabel {
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = 15
            let attributes = [NSAttributedStringKey.foregroundColor: UIColor.black,
                              NSAttributedStringKey.font: Style.fontGeorgia(size: 15),
                              NSAttributedStringKey.paragraphStyle: paragraphStyle]
            let newString = NSMutableAttributedString(string: "\(report.name)\n\(report.address)", attributes: attributes)
            locationLabel.attributedText = newString
        }

        let coordinate = CLLocationCoordinate2DMake(report.coordinate.latitude, report.coordinate.longitude)
        let mapSnapshotOptions = MKMapSnapshotOptions()

        // Set the region of the map that is rendered.
        let region = MKCoordinateRegionMakeWithDistance(coordinate, 1000, 1000)
        mapSnapshotOptions.region = region

        mapSnapshotOptions.showsBuildings = false
        mapSnapshotOptions.showsPointsOfInterest = false

        // Set the size of the image output.
        mapSnapshotOptions.size = CGSize(width: 90, height: 90)

        let snapShotter = MKMapSnapshotter(options: mapSnapshotOptions)
        snapShotter.start(completionHandler: { (snapshot, error) in
            self.mapPinImageView.alpha = 0
            self.mapButton.alpha = 0
            self.mapButton.setBackgroundImage(snapshot?.image, for: .normal)
            UIView.animate(withDuration: 0.25, animations: {
                self.mapButton.alpha = 1.0
                self.mapPinImageView.alpha = 1.0
            })
        })

        if let descriptionLabel = descriptionLabel {
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = 15
            let attributes = [NSAttributedStringKey.foregroundColor: UIColor.black,
                              NSAttributedStringKey.font: Style.fontGeorgia(size: 15),
                              NSAttributedStringKey.paragraphStyle: paragraphStyle]
            let newString = NSMutableAttributedString(string: report.description, attributes: attributes)
            descriptionLabel.attributedText = newString
        }
    }

    // Actions

    @IBAction func userTappedActionButton(_ sender: UIBarButtonItem) {
        if let images = images, let firstImage = images.first {
            let imageActivity = ImageActivity(image: firstImage)
            let shareText = "\(report.description) \(report.type.hashTagString()) #endangeredwaves"
            let messageActivity = TextActivity(message: shareText)

            let activityItems: [Any] = [imageActivity, messageActivity]

            let activityViewController = UIActivityViewController(activityItems: activityItems, applicationActivities: [])
            present(activityViewController, animated: true, completion: nil) // TODO: coordinator should do this
        }
    }
    @IBAction func userTappedMapButton(_ sender: UIButton) {
        delegate?.showMapDetail()
    }

    @IBAction func userTappedTakeActionButton(_ sender: UIButton) {
        // TODO: Duplicate code, should keep this dry
        let url = URL(string: "http://www.savethewaves.org/endangered-waves/take-action/")!
        let safariViewController = SFSafariViewController(url: url)
        safariViewController.preferredControlTintColor = Style.colorSTWBlue
        present(safariViewController, animated: true, completion: nil) // TODO: coordinator should do this
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
