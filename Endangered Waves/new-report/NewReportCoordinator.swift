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

    var location: LocationItem? {
        didSet {
            newReportVC?.location = location
        }
    }

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
        locationPicker.addBarButtons()
        locationPicker.pinColor = Style.colorSTWBlue
        locationPicker.searchResultLocationIconColor = Style.colorSTWBlue
        locationPicker.currentLocationIconColor = Style.colorSTWBlue
        locationPicker.pickCompletion = { (pickedLocationItem) in
            self.location = pickedLocationItem
        }

        let navigationController = UINavigationController(rootViewController: locationPicker)
        viewController.present(navigationController, animated: true, completion: nil)
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

// MARK: ImagePickerDelegate
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
        viewController.dismiss(animated: true) {
            self.stop()
        }
    }

    func viewController(_ viewController: NewReportViewController, didTapAddButton button: UIButton) {
        viewController.present(imagePickerController, animated: true, completion: nil)
    }
}
