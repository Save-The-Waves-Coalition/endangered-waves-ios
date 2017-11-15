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

protocol NewReportCoordinatorDelegate: class {
    func coordinatorDidFinishNewReport(_ coordinator: NewReportCoordinator)
}

class NewReportCoordinator: Coordinator {

    weak var delegate: NewReportCoordinatorDelegate?

    var images: [UIImage]?

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
        let newReportNavVC = NewReportNavViewController.instantiate()
        let newReportVC = newReportNavVC.topViewController as! NewReportViewController
        newReportVC.delegate = self
        newReportVC.images = images
        rootViewController.present(newReportNavVC, animated: true, completion: nil)
    }
}

// MARK: ImagePickerDelegate
extension NewReportCoordinator: ImagePickerDelegate {
    func wrapperDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
        guard images.count > 0 else { return }

        let lightboxImages = images.map {
            return LightboxImage(image: $0)
        }

        let lightbox = LightboxController(images: lightboxImages, startIndex: 0)
        imagePicker.present(lightbox, animated: true, completion: nil)
    }

    func doneButtonDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
        self.images = images
        imagePicker.dismiss(animated: true) {
            self.showNewReport()
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
}
