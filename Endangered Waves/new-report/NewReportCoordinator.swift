//
//  NewReportCoordinator.swift
//  Endangered Waves
//
//  Created by Matthew Morey on 11/14/17.
//  Copyright © 2017 Save The Waves. All rights reserved.
//

import UIKit
import LocationPickerViewController
import FirebaseStorage
import FirebaseFirestore
import SVProgressHUD
import CoreLocation

protocol NewReportCoordinatorDelegate: class {
func coordinator(_ coordinator: NewReportCoordinator, didFinishNewReport report: STWDataType?)
}

class NewReportCoordinator: Coordinator {

    weak var delegate: NewReportCoordinatorDelegate?

    var newReportNavVC: NewReportNavViewController?
    var newReportVC: NewReportViewController?

    var competition: Competition?

    var images: [UIImage]? {
        didSet {
            newReportVC?.images = images
        }
    }

    var reportDescription: String?

    var reportEmailAddress: String?

    var location: LocationItem? {
        didSet {
            newReportVC?.location = location
        }
    }

    var reportType: ReportType?

    lazy var imagePickerController: ImagePickerController = {
        var configuration = Configuration()
        configuration.allowVideoSelection = false
        configuration.recordLocation = true
        let imagePicker = ImagePickerController(configuration: configuration)
        imagePicker.delegate = self
        return imagePicker
    }()

    init(with rootViewController: UIViewController, andCompetition competition: Competition?) {
        super.init(with: rootViewController)
        self.competition = competition
    }

    override func start() {
        let viewController = imagePickerController
        viewController.modalPresentationStyle = .fullScreen
        rootViewController.present(viewController, animated: true, completion: nil)
    }

    override func stop() {
        stopWithReport(nil)
    }

    func stopWithReport(_ report: Report?) {
        delegate?.coordinator(self, didFinishNewReport: report)
    }

    func showNewReport() {
        let navVC = NewReportNavViewController.instantiate()
        if let topVC = navVC.topViewController as? NewReportViewController {
            self.newReportNavVC = navVC
            self.newReportVC = topVC
            topVC.delegate = self
            topVC.images = images
            topVC.competition = competition
            navVC.presentationController?.delegate = self
            rootViewController.present(navVC, animated: true, completion: nil)
        }
    }

    func showLocationPicker(withRootViewController viewController: UIViewController) {
        let locationPicker = LocationPicker()
        locationPicker.title = "LOCATION"
        locationPicker.addBarButtons()
        locationPicker.pinColor = UIColor.black
        locationPicker.searchResultLocationIconColor = Style.colorSTWBlue
        locationPicker.currentLocationIconColor = Style.colorSTWBlue
        locationPicker.pickCompletion = { (pickedLocationItem) in
            self.location = pickedLocationItem
        }
        let locationNavVC = NavigationViewController(rootViewController: locationPicker)
        viewController.present(locationNavVC, animated: true, completion: nil)
    }

    func showCompetitionInfoModal(withRootViewController viewController: UIViewController) {
        if let competition = self.competition, competition.introPageHTML != nil {
            let competitionCoordinator = CompetitionCoordinator(with: viewController, competition: competition)
            competitionCoordinator.delegate = self
            self.childCoordinators.append(competitionCoordinator)
            competitionCoordinator.start()
        }
    }
}

// MARK: CompetitionCoordinatorDelegate
extension NewReportCoordinator: CompetitionCoordinatorDelegate {
    func coordinatorDidFinishShowingCompetition(_ coordinator: CompetitionCoordinator, competition: Competition, andShowNewReport: Bool) {
        removeChildCoordinator(coordinator)
    }
}

// MARK: NewReportCoordinator
extension NewReportCoordinator {
    func lightboxForImages(_ images: [UIImage], withStartIndex index: Int) -> LightboxController? {
        guard images.count > 0 else { return nil }

        let lightboxImages = images.map {
            return LightboxImage(image: $0)
        }

        let lightbox = LightboxController(images: lightboxImages, startIndex: index)
        return lightbox
    }

    func lightboxWithNavigationViewControllerForImages(_ images: [UIImage], withStartIndex index: Int) -> UINavigationController? {
        if let lightbox = lightboxForImages(images, withStartIndex: index) {
            let navigationViewController = NavigationViewController(rootViewController: lightbox)
            navigationViewController.isNavigationBarHidden = true
            navigationViewController.modalPresentationStyle = .fullScreen
            lightbox.dynamicBackground = true
            return navigationViewController
        }
        return nil
    }
}

// MARK: 📸 ImagePickerDelegate
extension NewReportCoordinator: ImagePickerDelegate {
    func wrapperDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
        if let lightboxNavigationController = lightboxWithNavigationViewControllerForImages(images, withStartIndex: 0) {
            imagePicker.present(lightboxNavigationController, animated: true, completion: nil)
        }
    }

    func doneButtonDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
        self.images = images
        let presentingViewController = imagePicker.presentingViewController
        imagePicker.dismiss(animated: true) {
            if let presentingViewController = presentingViewController, !(presentingViewController is NewReportNavViewController) {
                self.showNewReport()
            }
        }
    }

    func cancelButtonDidPress(_ imagePicker: ImagePickerController) {
        imagePicker.dismiss(animated: true) {
            self.stop()
        }
    }
}

// MARK: NewReportViewControllerDelegate
extension NewReportCoordinator: NewReportViewControllerDelegate {
    func viewControllerDidTapCompetitionInfoButton(viewController: NewReportViewController) {
        showCompetitionInfoModal(withRootViewController: rootViewController)
    }

    func viewController(_ viewController: NewReportViewController, didWriteDescription description: String) {
        reportDescription = description
    }

    func viewController(_ viewController: NewReportViewController, didWriteEmailAddress email: String) {
        reportEmailAddress = email
    }

    // swiftlint:disable cyclomatic_complexity
    func viewController(_ viewController: NewReportViewController, didSelectThreatCategory category: String) {
        switch category {
        case "Oil Spill".localized():
            reportType = .oilSpill
        case "Sewage Spill".localized():
            reportType = .sewage
        case "Other Trash Threat".localized():
            reportType = .trashed
        case "Coastal Erosion".localized():
            reportType = .coastalErosion
        case "Access".localized():
            reportType = .accessLost
        case "General Alert".localized():
            reportType = .general
        case "Competition".localized():
            reportType = .competition
        case "Runoff".localized():
            reportType = .runoff
        case "Algal Bloom".localized():
            reportType = .algalBloom
        case "Other Water Quality Threat".localized():
            reportType = .waterQuality
        case "Plastic Packaging".localized():
            reportType = .plasticPackaging
        case "Micro-plastics".localized():
            reportType = .microPlastics
        case "Fishing Gear".localized():
            reportType = .fishingGear
        case "Seawall".localized():
            reportType = .seawall
        case "Hard Armoring".localized():
            reportType = .hardArmoring
        case "Beachfront Construction".localized():
            reportType = .beachfrontConstruction
        case "Jetty".localized():
            reportType = .jetty
        case "Harbor".localized():
            reportType = .harbor
        case "Other Coastal Development Threat".localized():
            reportType = .coastalDevelopment
        case "King Tides".localized():
            reportType = .kingTides
        case "Other Sea-Level & Erosion Threat".localized():
            reportType = .seaLevelRiseAndErosion
        case "Destructive Fishing".localized():
            reportType = .destructiveFishing
        case "Bleaching".localized():
            reportType = .bleaching
        case "Infrastructure".localized():
            reportType = .infrastructure
        case "Other Coral Reef Impact Threat".localized():
            reportType = .coralReefImpacts
        default:
            assertionFailure("Missing type.")
        }
    }
    // swiftlint:enable cyclomatic_complexity

    func viewControllerDidTapCompetition(viewController: NewReportViewController) {
        reportType = .competition
    }

    func viewController(_ viewController: NewReportViewController, didTapLocation sender: UITapGestureRecognizer) {
        showLocationPicker(withRootViewController: viewController)
    }

    func viewController(_ viewController: NewReportViewController, didTapImageAtIndex index: Int) {
        if let images = images, let lightboxNavigationController =
            lightboxWithNavigationViewControllerForImages(images, withStartIndex: index) {
            viewController.present(lightboxNavigationController, animated: true, completion: nil)
        }
    }

    func viewController(_ viewController: NewReportViewController, didTapCancelButton button: UIBarButtonItem) {
        viewController.dismiss(animated: true) {
            self.stop()
        }
    }

    func viewController(_ viewController: NewReportViewController, didTapPostButton button: Any?) {
        // validate picture
        guard let images = images else {
            showValidationError(title: "Missing Images", message: "Please select at least 1 image.", withViewController: viewController)
            return
        }

        // Validate type
        if reportType == nil {
            showValidationError(title: "Missing Threat Category",
                                message: "Please select a Threat Category, such as OIL SPILL.",
                                withViewController: viewController)
            return
        }

        // validate description
        if (reportDescription ?? "").isEmpty {
            showValidationError(title: "Missing Description", message: "Please enter a description.", withViewController: viewController)
            return
        }

        // validate location
        if location == nil {
            showValidationError(title: "Missing Location", message: "Please select a location.", withViewController: viewController)
            return
        }
        guard let locationCoordinate = location?.coordinate else {
            showValidationError(title: "Missing Location", message: "Please select a location.", withViewController: viewController)
            return
        }

        // validate email address
        if (reportEmailAddress ?? "").isEmpty {
            showValidationError(title: "Missing Email Address", message: "Please enter a valid email address.",
                                withViewController: viewController)
            return
        }
        if let reportEmailAddress = reportEmailAddress, !reportEmailAddress.isValidEmail() {
            showValidationError(title: "Invalid Email Address", message: "Please enter a valid email address.",
                                withViewController: viewController)
            return
        }

        guard let reportDescription = reportDescription, let location = location,
            let reportType = reportType, let reportEmailAddress = reportEmailAddress else {
            assertionFailure("⚠️: Missing Field")
            showValidationError(title: "Invalid Field", message: "Please make sure all fields have been filled out properly.",
                                withViewController: viewController)
            // TODO: Log to Crashlytics
            return
        }

        SVProgressHUD.setHapticsEnabled(true)
        let statusString = images.count > 1 ? "Uploading Images" : "Uploading Image"
        SVProgressHUD.showProgress(0, status: statusString)

        let geoPoint = GeoPoint(latitude: locationCoordinate.latitude, longitude: locationCoordinate.longitude)
        APIManager.createNewReport(name: location.name,
                                   address: location.formattedAddressString ?? "",
                                   coordinate: geoPoint, creationDate: Date(),
                                   description: reportDescription,
                                   emailAddress: reportEmailAddress,
                                   images: images,
                                   type: reportType,
            progressHandler: { (progress: Double) in
                SVProgressHUD.showProgress(Float(progress), status: statusString)
        }, completionHandler: { (documentID: String?, report: Report?, error: Error?) in
            if let error = error {
                print("Error adding document: \(error.localizedDescription)")
                SVProgressHUD.showError(withStatus: "There was an issue creating your post. Please try again.")
            } else {
                // Success
                UserDefaultsHandler.setUserEmailAddress(reportEmailAddress)
                SVProgressHUD.dismiss()
                viewController.dismiss(animated: true) {
                    self.stopWithReport(report)
                }
            }
        })
    } // func

    func viewController(_ viewController: NewReportViewController, didTapAddButton button: UIButton) {
        let imagePickerViewController = imagePickerController
        imagePickerViewController.modalPresentationStyle = .fullScreen
        viewController.present(imagePickerViewController, animated: true, completion: nil)
    }
}

// MARK: UIAdaptivePresentationControllerDelegate
extension NewReportCoordinator: UIAdaptivePresentationControllerDelegate {
    func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        stop()
    }

    func presentationControllerShouldDismiss(_ presentationController: UIPresentationController) -> Bool {
        if let descriptionString = reportDescription {
            if descriptionString.count > 15 { // MDM 20200326 - 15 was arbitrarly determined, seems right
                if let reportVC = newReportVC {
                    let discardReportAlert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
                    let postAction = UIAlertAction(title: "Post", style: .default, handler: { action in
                        if let newReportVC = self.newReportVC {
                            self.viewController(newReportVC, didTapPostButton: nil)
                        }
                    })
                    let discardAction = UIAlertAction(title: "Discard", style: .destructive, handler: { action in
                        reportVC.dismiss(animated: true) {
                            self.stop()
                        }
                    })
                    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
                    discardReportAlert.addAction(postAction)
                    discardReportAlert.addAction(discardAction)
                    discardReportAlert.addAction(cancelAction)
                    reportVC.present(discardReportAlert, animated: true, completion: nil)
                }
                return false
            }
        }
        return true
    }
}

// MARK: Error Handling
extension NewReportCoordinator {
    func showValidationError(title: String, message: String, withViewController viewController: UIViewController) {
        let alertViewController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertViewController.view.tintColor = Style.colorSTWBlue
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertViewController.addAction(okAction)
        viewController.present(alertViewController, animated: true, completion: nil)
    }
}
