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
    func viewControllerDidTapCompetition(viewController: NewReportViewController)
    func viewControllerDidTapCompetitionInfoButton(viewController: NewReportViewController)
    func viewController(_ viewController: NewReportViewController, didWriteDescription description: String)
    func viewController(_ viewController: NewReportViewController, didWriteEmailAddress email: String)
}

class NewReportViewController: UITableViewController {

    weak var delegate: NewReportViewControllerDelegate?

    var competition: Competition?
    @IBOutlet weak var competitionTrophyImageView: UIImageView!
    @IBOutlet weak var competitionTitleLabel: UILabel!
    @IBOutlet weak var competitionDateLabel: UILabel!
    @IBOutlet weak var competitionInfoButton: UIButton!

    @IBOutlet weak var imageGallaryContainerView: UIView!
    var imageSliderViewController: ImageSliderViewController?

    @IBOutlet weak var descriptionTextView: UITextView!

    @IBOutlet weak var emailTextView: UITextView!

    @IBOutlet weak var contactInfoStackView: UIStackView!

    @IBOutlet var categoryTypeCollection: [STWButton]!

    fileprivate func enableInActiveStateForButton(_ button: (STWButton)) {
        button.tintColor = Style.colorSTWGrey
        button.isSelected = false
        button.titleLabel?.font = Style.fontBrandonGrotesqueBlack(size: 12)

        if let currentAttributedTitle = button.currentAttributedTitle {
            let style = NSMutableParagraphStyle()
            style.alignment = .center
            let attributes = [NSAttributedString.Key.font: Style.fontBrandonGrotesqueBlack(size: 12),
                              NSAttributedString.Key.foregroundColor: Style.colorSTWGrey,
                              NSAttributedString.Key.paragraphStyle: style]
            let attributedString = NSAttributedString(string: currentAttributedTitle.string, attributes: attributes)
            button.setAttributedTitle(attributedString, for: .normal)
        }
    }

    @IBAction func categoryTypeButtonTapped(_ sender: STWButton) {
        categoryTypeCollection.forEach { (button) in
            if button === sender {
                button.tintColor = .black
                button.isSelected = true
                button.titleLabel?.font = Style.fontBrandonGrotesqueBlack(size: 12)

                if let currentAttributedTitle = button.currentAttributedTitle {
                    let style = NSMutableParagraphStyle()
                    style.alignment = .center
                    let attributes = [NSAttributedString.Key.font: Style.fontBrandonGrotesqueBlack(size: 12),
                                      NSAttributedString.Key.foregroundColor: UIColor.black,
                                      NSAttributedString.Key.paragraphStyle: style]
                    let attributedString = NSAttributedString(string: currentAttributedTitle.string, attributes: attributes)
                    button.setAttributedTitle(attributedString, for: .normal)
                }
            } else {
                enableInActiveStateForButton(button)
            }
        }

        // Set competition to inactive state if a normal threat category is selected
        competitionTitleLabel.textColor = Style.colorSTWGrey
        competitionDateLabel.textColor = Style.colorSTWGrey
        competitionTrophyImageView.image = UIImage(named: "grey-trophy")

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

                locationLabel.attributedText = Style.userInputAttributedStringForString("\(location.name)\n\(addressString)")

                if let mapImageView = mapImageView {
                    let coordinate = location.mapItem.placemark.coordinate
                    let mapSnapshotOptions = MKMapSnapshotter.Options()

                    // Set the region of the map that is rendered.
                    let region = MKCoordinateRegion.init(center: coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
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

    // MARK: View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // TODO: Info button should show the competition modal
        competitionInfoButton.isHidden = true

        // Set up description text view
        descriptionTextView.delegate = self
        descriptionTextView.textContainerInset = .zero
        descriptionTextView.textContainer.lineFragmentPadding = 0

        // Set up email text view
        emailTextView.delegate = self
        emailTextView.textContainerInset = .zero
        emailTextView.textContainer.lineFragmentPadding = 0
        emailTextView.textContainer.maximumNumberOfLines = 1
        emailTextView.textContainer.lineBreakMode = .byTruncatingTail
        if let emailAddress = UserDefaultsHandler.getUserEmailAddress() {
            emailTextView.attributedText = Style.userInputAttributedStringForString(emailAddress)
            delegate?.viewController(self, didWriteEmailAddress: emailAddress)
        }

        // Set up competition info if one is active
        if let competition = self.competition {
            competitionTitleLabel.text = competition.title.uppercased()
            competitionDateLabel.text = competition.dateDisplayString().uppercased()
        }

        // Attributed text set in the Storyboard is only working on the simulator, not in builds distributed via Buddybuild, this fixes that
        categoryTypeCollection.forEach { (button) in
            if let currentAttributedTitle = button.currentAttributedTitle {
                let style = NSMutableParagraphStyle()
                style.alignment = .center
                let attributes = [NSAttributedString.Key.font: Style.fontBrandonGrotesqueBlack(size: 12),
                                  NSAttributedString.Key.foregroundColor: Style.colorSTWGrey,
                                  NSAttributedString.Key.paragraphStyle: style]
                let attributedString = NSAttributedString(string: currentAttributedTitle.string, attributes: attributes)
                button.setAttributedTitle(attributedString, for: .normal)
            }
        }
    }

    // MARK: IBActions
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

    @IBAction func competitionInfoButtonWasTapped(_ sender: UIButton) {
        delegate?.viewControllerDidTapCompetitionInfoButton(viewController: self)
    }

    @IBAction func competitionAreaWasTapped(_ sender: UITapGestureRecognizer) {
        // Set competition area to active state
        competitionDateLabel.textColor = .black
        competitionTitleLabel.textColor = .black
        competitionTrophyImageView.image = UIImage(named: "golden-trophy")

        // Set other report types to inactive state
        categoryTypeCollection.forEach { (button) in
            enableInActiveStateForButton(button)
        }

        // Let the delegate know
        delegate?.viewControllerDidTapCompetition(viewController: self)
    }

    // MARK: Segues
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
        // If there is no active competition, hide the row
        if self.competition == nil && indexPath.row == 2 {
            return 0.0
        }

        return UITableView.automaticDimension
    }
}

// MARK: UITextViewDelegate
extension NewReportViewController: UITextViewDelegate {

    func textViewDidChange(_ textView: UITextView) {
        // Hack to make the auto expanding cell animation look nice
        UIView.setAnimationsEnabled(false)
        tableView.beginUpdates()
        tableView.endUpdates()
        let indexPath: IndexPath
        if textView === descriptionTextView {
            indexPath = IndexPath(row: 3, section: 0)
        } else {
            indexPath = IndexPath(row: 5, section: 0)
        }
        tableView.scrollToRow(at: indexPath, at: .bottom, animated: false)
        UIView.setAnimationsEnabled(true)
        // End hack

        if textView === descriptionTextView {
            delegate?.viewController(self, didWriteDescription: textView.text)
        } else if textView === emailTextView {
            delegate?.viewController(self,
                                     didWriteEmailAddress: textView.text.trimmingCharacters(in: .whitespacesAndNewlines))
        }
    }

    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.attributedText.string == "Write a description..." || textView.attributedText.string == "Enter email address..." {
            // Have to have at least 1 character for the attributes to take
            textView.attributedText = Style.userInputAttributedStringForString(" ")
            textView.text = ""
        }
        textView.becomeFirstResponder() // Optional
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        if textView === descriptionTextView && textView.attributedText.string == "" {
            textView.attributedText = Style.userInputPlaceholderAttributedStringForString("Write a description...")
        } else if textView === emailTextView && textView.attributedText.string == "" {
            textView.attributedText = Style.userInputPlaceholderAttributedStringForString("Enter email address...")
        }
        textView.resignFirstResponder()
    }

    // If user hits return/done on keyboard while editing their email address dismiss keyboard
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if textView === emailTextView && text == "\n" {
            textView.resignFirstResponder()
            textView.text = textView.text.trimmingCharacters(in: .whitespacesAndNewlines) // remove any extra trailing whitespace
            return false
        }
        return true
    }
}

// MARK: 📖 StoryboardInstantiable
extension NewReportViewController: StoryboardInstantiable {
    static var storyboardName: String { return "new-report" }
    static var storyboardIdentifier: String? { return "NewReportComponent" }
}
