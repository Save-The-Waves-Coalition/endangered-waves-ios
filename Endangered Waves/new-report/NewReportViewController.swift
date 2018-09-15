//
//  NewReportViewController.swift
//  Endangered Waves
//
//  Created by Matthew Morey on 11/6/17.
//  Copyright © 2017 Save The Waves. All rights reserved.
//

import UIKit
import MobileCoreServices
import Photos
import CoreLocation
import LocationPickerViewController
import Firebase
import ImagePicker
import Lightbox
import MapKit

protocol NewReportViewControllerDelegate: class {
    func viewController(_ viewController: NewReportViewController, didTapCancelButton button: UIBarButtonItem)
    func viewController(_ viewController: NewReportViewController, didTapPostButton button: Any)
    func viewController(_ viewController: NewReportViewController, didTapImageAtIndex index: Int)
    func viewController(_ viewController: NewReportViewController, didTapAddButton button: UIButton)
    func viewController(_ viewController: NewReportViewController, didTapLocation sender: UITapGestureRecognizer)
    func viewController(_ viewController: NewReportViewController, didTapReportType sender: STWButton)
    func viewController(_ viewController: NewReportViewController, didWriteDescription description: String)
    func viewController(_ viewController: NewReportViewController, didWriteEmailAddress email: String)
}

class NewReportViewController: UITableViewController {

    weak var delegate: NewReportViewControllerDelegate?

    @IBOutlet weak var imageGallaryContainerView: UIView!
    var imageSliderViewController: ImageSliderViewController?

    @IBOutlet weak var descriptionTextView: UITextView!

    @IBOutlet weak var emailTextView: UITextView!

    @IBOutlet weak var competitionStackView: UIStackView!
    @IBOutlet weak var competitionTitleLabel: UILabel!
    @IBOutlet weak var competitionDateLabel: UILabel!
    @IBOutlet weak var competitionButton: STWButton!

    @IBOutlet var categoryTypeCollection: [STWButton]!

    @IBAction func categoryTypeButtonTapped(_ sender: STWButton) {
        categoryTypeCollection.forEach { (button) in
            if button === sender {
                button.tintColor = .black
                button.isSelected = true
                button.titleLabel?.font = Style.fontBrandonGrotesqueBlack(size: 12)

                if let currentAttributedTitle = button.currentAttributedTitle {
                    let style = NSMutableParagraphStyle()
                    style.alignment = .center
                    let attributes = [NSAttributedStringKey.font: Style.fontBrandonGrotesqueBlack(size: 12),
                                      NSAttributedStringKey.foregroundColor: UIColor.black,
                                      NSAttributedStringKey.paragraphStyle: style]
                    let attributedString = NSAttributedString(string: currentAttributedTitle.string, attributes: attributes)
                    button.setAttributedTitle(attributedString, for: .normal)
                }

                // Competition button
                if button === self.competitionButton {
                    self.competitionTitleLabel.textColor = .black
                    self.competitionDateLabel.textColor = .black
                }

            } else {
                button.tintColor = Style.colorSTWGrey
                button.isSelected = false
                button.titleLabel?.font = Style.fontBrandonGrotesqueBlack(size: 12)

                if let currentAttributedTitle = button.currentAttributedTitle {
                    let style = NSMutableParagraphStyle()
                    style.alignment = .center
                    let attributes = [NSAttributedStringKey.font: Style.fontBrandonGrotesqueBlack(size: 12),
                                      NSAttributedStringKey.foregroundColor: Style.colorSTWGrey,
                                      NSAttributedStringKey.paragraphStyle: style]
                    let attributedString = NSAttributedString(string: currentAttributedTitle.string, attributes: attributes)
                    button.setAttributedTitle(attributedString, for: .normal)
                }

                // Competition button
                if button === self.competitionButton {
                    self.competitionTitleLabel.textColor = Style.colorSTWGrey
                    self.competitionDateLabel.textColor = Style.colorSTWGrey
                }
            }
        }
        delegate?.viewController(self, didTapReportType: sender)
    }

    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var mapImageView: UIImageView!
    @IBOutlet weak var mapPinImageView: UIImageView!

    var images: [UIImage]? {
        didSet {
            imageSliderViewController?.images = images
        }
    }

    var reportDescription: String? {
        didSet {
            if let reportDescription = reportDescription, let descriptionTextView = descriptionTextView {
                descriptionTextView.text = reportDescription
            }
        }
    }

    var emailAddress: String? {
        didSet {
            if let emailAddress = emailAddress, let emailTextView = emailTextView {
                emailTextView.text = emailAddress
            }
        }
    }

    var location: LocationItem? {
        didSet {
            if let location = location, let addressString = location.formattedAddressString {

                let paragraphStyle = NSMutableParagraphStyle()
                paragraphStyle.lineSpacing = 15
                let attributes = [NSAttributedStringKey.foregroundColor: UIColor.black,
                                  NSAttributedStringKey.font: Style.fontGeorgia(size: 15),
                                  NSAttributedStringKey.paragraphStyle: paragraphStyle]
                let newString = NSMutableAttributedString(string: "\(location.name)\n\(addressString)", attributes: attributes)
                locationLabel.attributedText = newString

                if let mapImageView = mapImageView {
                    let coordinate = location.mapItem.placemark.coordinate
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
                        mapImageView.alpha = 0
                        mapImageView.image = snapshot?.image
                        UIView.animate(withDuration: 0.25, animations: {
                            mapImageView.alpha = 1.0
                            self.mapPinImageView.alpha = 1.0
                        })
                    })
                }
            }
        }
    }

    @IBAction func didTapPostButton(_ sender: Any) {
        delegate?.viewController(self, didTapPostButton: sender)
    }

    @IBAction func cancelButtonWasTapped(_ sender: UIBarButtonItem) {
        delegate?.viewController(self, didTapCancelButton: sender)
    }

    @IBAction func addButtonWasTapped(_ sender: UIButton) {
        delegate?.viewController(self, didTapAddButton: sender)
    }

    @IBAction func locationWasTapped(_ sender: UITapGestureRecognizer) {
        delegate?.viewController(self, didTapLocation: sender)
    }

    @IBAction func competitionTextWasTapped(_ sender: UITapGestureRecognizer) {
        categoryTypeButtonTapped(competitionButton)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        descriptionTextView.delegate = self
        descriptionTextView.textContainerInset = .zero
        descriptionTextView.textContainer.lineFragmentPadding = 0

        emailTextView.delegate = self
        emailTextView.textContainerInset = .zero
        emailTextView.textContainer.lineFragmentPadding = 0

        // Attributed text set in the Storyboard is only working on the simulator, not in builds distributed via Buddybuild, this fixes that
        categoryTypeCollection.forEach { (button) in
            if let currentAttributedTitle = button.currentAttributedTitle {
                let style = NSMutableParagraphStyle()
                style.alignment = .center
                let attributes = [NSAttributedStringKey.font: Style.fontBrandonGrotesqueBlack(size: 12),
                                  NSAttributedStringKey.foregroundColor: Style.colorSTWGrey,
                                  NSAttributedStringKey.paragraphStyle: style]
                let attributedString = NSAttributedString(string: currentAttributedTitle.string, attributes: attributes)
                button.setAttributedTitle(attributedString, for: .normal)
            }
        }

        // Show or hide competition UI
        APIManager.getActiveCompetition { (competition, error) in
            if let error = error {
                print("Error: \(error)")
                DispatchQueue.main.async {
                    self.competitionStackView.isHidden = true
                    self.tableView.reloadData()
                }
            } else {
                DispatchQueue.main.async {
                    self.competitionStackView.isHidden = false
                    self.competitionTitleLabel.text = competition!.title.uppercased()
                    self.competitionDateLabel.text = competition!.dateDisplayString()
                    self.categoryTypeButtonTapped(self.competitionButton)
                    self.tableView.reloadData()
                    return
                }
            }
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let imageSliderViewController = segue.destination as? ImageSliderViewController {
            imageSliderViewController.images = self.images
            imageSliderViewController.imageSliderViewControllerDelegate = self
            self.imageSliderViewController = imageSliderViewController
        }
    }
}

// MARK: ImageSliderViewControllerDelegate
extension NewReportViewController: ImageSliderViewControllerDelegate {
    func viewController(_ viewController: ImageSliderViewController, didTapImage image: UIImage, atIndex index: Int) {
        delegate?.viewController(self, didTapImageAtIndex: index)
    }
}

// MARK: UITableViewDelegate
extension NewReportViewController {
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
}

// MARK: UITextViewDelegate
extension NewReportViewController: UITextViewDelegate {

    func textViewDidChange(_ textView: UITextView) {
        // Hack to make the auto expanding cell animation look nice
        UIView.setAnimationsEnabled(false)
        tableView.beginUpdates()
        tableView.endUpdates()
        let indexPath = IndexPath(row: 2, section: 0)
        tableView.scrollToRow(at: indexPath, at: .bottom, animated: false)
        UIView.setAnimationsEnabled(true)
        // End hack

        if textView === descriptionTextView {
            delegate?.viewController(self, didWriteDescription: textView.text)
        }

        if textView === emailTextView {
            delegate?.viewController(self, didWriteEmailAddress: textView.text)
        }
    }

    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.attributedText.string == "Write a description..." {
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = 15
            let attributes = [NSAttributedStringKey.foregroundColor: UIColor.black,
                              NSAttributedStringKey.font: Style.fontGeorgia(size: 15),
                              NSAttributedStringKey.paragraphStyle: paragraphStyle]
            // Have to have at least 1 character for the attributes to take
            let newString = NSMutableAttributedString(string: " ", attributes: attributes)
            textView.attributedText = newString
            textView.text = ""
        }

        if textView.attributedText.string == "Email address..." {
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = 15
            let attributes = [NSAttributedStringKey.foregroundColor: UIColor.black,
                              NSAttributedStringKey.font: Style.fontGeorgia(size: 15),
                              NSAttributedStringKey.paragraphStyle: paragraphStyle]
            // Have to have at least 1 character for the attributes to take
            let newString = NSMutableAttributedString(string: " ", attributes: attributes)
            textView.attributedText = newString
            textView.text = ""
        }

        textView.becomeFirstResponder() //Optional
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        if textView === descriptionTextView && textView.attributedText.string == "" {
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = 15
            let attributes = [NSAttributedStringKey.foregroundColor: Style.colorSTWGrey,
                              NSAttributedStringKey.font: Style.fontGeorgiaItalic(size: 15),
                              NSAttributedStringKey.paragraphStyle: paragraphStyle]
            let newString = NSMutableAttributedString(string: "Write a description...", attributes: attributes)
            textView.attributedText = newString
        }

        if textView === emailTextView && textView.attributedText.string == "" {
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = 15
            let attributes = [NSAttributedStringKey.foregroundColor: Style.colorSTWGrey,
                              NSAttributedStringKey.font: Style.fontGeorgiaItalic(size: 15),
                              NSAttributedStringKey.paragraphStyle: paragraphStyle]
            let newString = NSMutableAttributedString(string: "Email address...", attributes: attributes)
            textView.attributedText = newString
        }
        textView.resignFirstResponder()
    }
}

// MARK: 📖 StoryboardInstantiable
extension NewReportViewController: StoryboardInstantiable {
    static var storyboardName: String { return "new-report" }
    static var storyboardIdentifier: String? { return "NewReportComponent" }
}
