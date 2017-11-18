//
//  NewReportCoordinator.swift
//  Endangered Waves
//
//  Created by Matthew Morey on 11/14/17.
//  Copyright © 2017 Save The Waves. All rights reserved.
//

import UIKit
import ImagePicker
import Lightbox
import LocationPickerViewController
import FirebaseStorage

protocol NewReportCoordinatorDelegate: class {
    func coordinatorDidFinishNewReport(_ coordinator: NewReportCoordinator)
}

class NewReportCoordinator: Coordinator {

    weak var delegate: NewReportCoordinatorDelegate?
    
    var newReportNavVC: NewReportNavViewController?
    var newReportVC: NewReportViewController?

    var images: [UIImage]? {
        didSet {
            newReportVC?.images = images
        }
    }
    
    var reportDescription: String? {
        didSet {
            newReportVC?.reportDescription = reportDescription
        }
    }

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

    override func start() {
        rootViewController.present(imagePickerController, animated: true, completion: nil)
    }

    override func stop() {
        delegate?.coordinatorDidFinishNewReport(self)
    }

    func showNewReport() {

        // TODO fix all these !
        newReportNavVC = NewReportNavViewController.instantiate()
        newReportVC = (newReportNavVC!.topViewController as! NewReportViewController)
        newReportVC!.delegate = self
        newReportVC!.images = images
        rootViewController.present(newReportNavVC!, animated: true, completion: nil)
    }

    func showLocationPicker(withRootViewController viewController: UIViewController) {
        let locationPicker = LocationPicker()
        locationPicker.pinColor = Style.colorSTWBlue
        locationPicker.searchResultLocationIconColor = Style.colorSTWBlue
        locationPicker.currentLocationIconColor = Style.colorSTWBlue
        locationPicker.pickCompletion = { (pickedLocationItem) in
            // TODO: Should this be an unowned self
            self.location = pickedLocationItem
        }
        viewController.navigationController?.pushViewController(locationPicker, animated: true)
    }
    
    func showDescriptionEditor(withRootViewController viewController: UIViewController) {
        let descriptionEditorViewController = STWTextViewController.instantiate()
        descriptionEditorViewController.text = reportDescription
        descriptionEditorViewController.textViewDidEndEditing = {
            (text) in
            // TODO: Should this be an unowned self
            self.reportDescription = text
        }
        viewController.navigationController?.pushViewController(descriptionEditorViewController, animated: true)
    }
}

extension NewReportCoordinator {
    func lightboxForImages(_ images:[UIImage], withStartIndex index:Int) -> LightboxController? {
        guard images.count > 0 else { return nil }

        let lightboxImages = images.map {
            return LightboxImage(image: $0)
        }

        let lightbox = LightboxController(images: lightboxImages, startIndex: index)
        return lightbox
    }
}

// MARK: 📸 ImagePickerDelegate
extension NewReportCoordinator: ImagePickerDelegate {
    func wrapperDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
        if let lightbox = lightboxForImages(images, withStartIndex: 0) {
            imagePicker.present(lightbox, animated: true, completion: nil)
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

    func viewController(_ viewController: NewReportViewController, didTapReportType sender: STWButton) {
        if let buttonTitleText = sender.titleLabel?.text {
            switch buttonTitleText {
            case "OIL SPILL":
                reportType = .OilSpill
            case "SEWAGE":
                reportType = .Sewage
            case "TRASHED":
                reportType = .Trashed
            case "COASTAL\nEROSION":
                reportType = .CoastalErosion
            case "ACCESS\nLOST":
                reportType = .AccessLost
            case "GENERAL\n ":
                reportType = .General
            default:
                assertionFailure("Missing type.")
            }
        }
    }

    func viewController(_ viewController: NewReportViewController, didTapDescription sender: UITapGestureRecognizer) {
        showDescriptionEditor(withRootViewController: viewController)
    }
    
    func viewController(_ viewController: NewReportViewController, didTapLocation sender: UITapGestureRecognizer) {
        showLocationPicker(withRootViewController: viewController)
    }

    func viewController(_ viewController: NewReportViewController, didTapImageAtIndex index: Int) {
        if let images = images, let lightbox = lightboxForImages(images, withStartIndex: index) {
            viewController.present(lightbox, animated: true, completion: nil)
        }
    }

    func viewController(_ viewController: NewReportViewController, didTapCancelButton button: UIBarButtonItem) {
        viewController.dismiss(animated: true) {
            self.stop()
        }
    }

    func viewController(_ viewController: NewReportViewController, didTapSaveButton button: UIBarButtonItem) {
        // validate picture
        // TODO: not needed as you currently can't deselect all pics

        // validate description
        if reportDescription == nil {
            showValidationError(title: "Missing Description", message: "Please enter a description.", withViewController: viewController)
            return
        }

        // validate location
        if location == nil {
            showValidationError(title: "Missing Location", message: "Please select a location.", withViewController: viewController)
            return
        }

        // Validate type
        if reportType == nil {
            showValidationError(title: "Missing Report Type", message: "Please select a report type, such as OIL SPILL.", withViewController: viewController)
            return
        }


        images?.forEach({ (image) in
            if let imageData = UIImageJPEGRepresentation(image, 0.8) {

                let imageName = UUID().uuidString + ".jpg"

                let storage = Storage.storage()
                let reportImagesRef = storage.reference().child("report-images")
                let imageRef = reportImagesRef.child(imageName)

                let metadata = StorageMetadata()
                metadata.contentType = "image/jpeg"

                let uploadTask = imageRef.putData(imageData, metadata: metadata)

                uploadTask.observe(.progress, handler: { (snapshot) in
                    let percentComplete = 100.0 * Double(snapshot.progress!.completedUnitCount)
                        / Double(snapshot.progress!.totalUnitCount)
                    print("Upload progress: \(percentComplete)")
                })

                uploadTask.observe(.failure, handler: { (snapshot) in
                    print("Upload failed: \(snapshot.debugDescription)")

                    if let error = snapshot.error as NSError? {
                        print("Error: \(error.localizedDescription)")
                        switch (StorageErrorCode(rawValue: error.code)!) {
                        case .objectNotFound:
                            // File doesn't exist
                            break
                        case .unauthorized:
                            // User doesn't have permission to access file
                            break
                        case .cancelled:
                            // User canceled the upload
                            break

                            /* ... */

                        case .unknown:
                            // Unknown error occurred, inspect the server response
                            break
                        default:
                            // A separate error occurred. This is a good place to retry the upload.
                            break
                        }
                    }
                })

                uploadTask.observe(.success, handler: { (snapshot) in
                    print("Upload completed:\(snapshot.debugDescription)")
                    let metaData = snapshot.metadata
                    let downloadURL = metaData?.downloadURL()
                    let downloadURLString = downloadURL?.absoluteString
                    if let string = downloadURLString {
                        print("Download string: \(string)")
                    }
                })
            }

        })
        
//        let reportLocation = ReportLocation(name: location?.name, coordinate: location?.mapItem.placemark.coordinate)
//
//
//        let report = Report(creationDate: Date(), description: reportDescription, imageURLs: <#T##[String]?#>, location: <#T##ReportLocation?#>, type: <#T##ReportType?#>, user: <#T##String?#>)

        viewController.dismiss(animated: true) {
            self.stop()
        }
    }

    func viewController(_ viewController: NewReportViewController, didTapAddButton button: UIButton) {
        viewController.present(imagePickerController, animated: true, completion: nil)
    }
}

extension NewReportCoordinator {
    func showValidationError(title: String, message: String, withViewController viewController: UIViewController) {
        let alertViewController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertViewController.addAction(okAction)
        viewController.present(alertViewController, animated: true, completion: nil)
    }
}
