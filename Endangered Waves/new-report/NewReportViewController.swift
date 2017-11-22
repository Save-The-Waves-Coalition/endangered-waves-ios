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

protocol NewReportViewControllerDelegate: class {
    func viewController(_ viewController: NewReportViewController, didTapCancelButton button: UIBarButtonItem)
    func viewController(_ viewController: NewReportViewController, didTapSaveButton button: UIBarButtonItem)
    func viewController(_ viewController: NewReportViewController, didTapImageAtIndex index:Int)
    func viewController(_ viewController: NewReportViewController, didTapAddButton button:UIButton)
    func viewController(_ viewController: NewReportViewController, didTapLocation sender: UITapGestureRecognizer)
    func viewController(_ viewController: NewReportViewController, didTapReportType sender: STWButton)
    func viewController(_ viewController: NewReportViewController, didWriteDescription description: String)
}

class NewReportViewController: UITableViewController {

    weak var delegate: NewReportViewControllerDelegate?

    @IBOutlet weak var imageGallaryContainerView: UIView!
    var imageSliderViewController: ImageSliderViewController?

    @IBOutlet weak var descriptionTextView: UITextView!

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
            }
        }
        delegate?.viewController(self, didTapReportType: sender)
    }

    @IBOutlet weak var locationLabel: UILabel!

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
    
    var location: LocationItem? {
        didSet {
            if let location = location, let addressString = location.formattedAddressString {
                locationLabel.text = "\(location.name)\n\(addressString)"
                locationLabel.textColor = .black
                locationLabel.font = Style.fontGeorgia(size: 15)
            }
        }
    }

    @IBAction func saveButtonWasTapped(_ sender: UIBarButtonItem) {
        // TODO: Save Report
        delegate?.viewController(self, didTapSaveButton: sender)
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

    override func viewDidLoad() {
        super.viewDidLoad()

        descriptionTextView.delegate = self
        descriptionTextView.textContainerInset = .zero
        descriptionTextView.textContainer.lineFragmentPadding = 0

        // Attributed text set in the Storyboard is only working on the simulator, not in builds distributed via Buddybuild
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
    func viewController(_ viewController: ImageSliderViewController, didTapImageAtIndex index: Int) {
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
        let indexPath = IndexPath(row: 1, section: 0)
        tableView.scrollToRow(at: indexPath, at: .bottom, animated: false)
        UIView.setAnimationsEnabled(true)
        // End hack

        delegate?.viewController(self, didWriteDescription: textView.text)
    }

    func textViewDidBeginEditing(_ textView: UITextView) {
        if (textView.text == "Write a description...") {
            textView.text = ""
            textView.textColor = .black
            textView.font = Style.fontGeorgia(size: 15)
        }
        textView.becomeFirstResponder() //Optional
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        if (textView.text == "") {
            textView.text = "Write a description..."
            textView.textColor = Style.colorSTWGrey
            textView.font = Style.fontGeorgiaItalic(size: 15)
        }
        textView.resignFirstResponder()
    }
}

// MARK: StoryboardInstantiable
extension NewReportViewController: StoryboardInstantiable {
    static var storyboardName: String { return "new-report" }
    static var storyboardIdentifier: String? { return "NewReportComponent" }
}
