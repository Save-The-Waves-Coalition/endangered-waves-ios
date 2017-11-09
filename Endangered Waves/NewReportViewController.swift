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

class NewReportViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    let imagePicker = UIImagePickerController()
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var latitudeLabel: UILabel!
    @IBOutlet weak var longitudeLabel: UILabel!
    @IBOutlet weak var locationName: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
    }
    
    @IBAction func closeButtonWasTapped(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func capturePhotoButtonWasTapped(_ sender: UIButton) {
        let imageSourceIsAvailable = (UIImagePickerController.isSourceTypeAvailable(.camera) || UIImagePickerController.isSourceTypeAvailable(.photoLibrary))
        let photoLibraryIsAuthorized = PHPhotoLibrary.authorizationStatus() == .authorized

        if imageSourceIsAvailable {
            if photoLibraryIsAuthorized {
                showPickerChooserActionController()
            } else {
                PHPhotoLibrary.requestAuthorization({ (status) in
                    if status == .authorized {
                        DispatchQueue.main.async {
                            self.showPickerChooserActionController()
                        }

                    } else {
                        // TODO: show alert
                    }
                })
            }
        } else {
            // TODO: Show alert
        }
    }

    func showPickerChooserActionController() {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)

        var actions: [UIAlertAction] = []

        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let cameraAction = UIAlertAction(title: "Camera", style: .default) { (action) in
                self.showCameraImagePicker()
            }
            actions.append(cameraAction)
        }

        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let libraryAction = UIAlertAction(title: "Photo Library", style: .default) { (action) in
                self.showLibraryImagePicker()
            }
            actions.append(libraryAction)
        }

        if !actions.isEmpty {
            let cancelAction = UIAlertAction(title: "Cancel", style: .default) { (action) in

            }
            actions.append(cancelAction)
            actions.forEach { (action) in
                alertController.addAction(action)
            }
            present(alertController, animated: true, completion: nil)
        }

        // TODO: What do we do if the actions array is empty
    }

    func showLibraryImagePicker() {
        guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else {
            // TODO: Show alert to the user.
            return
        }
        imagePicker.mediaTypes = [kUTTypeImage as String]
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = false
        present(imagePicker, animated: true, completion: nil)
    }

    func showCameraImagePicker() {
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
            // TODO: Show alert to the user.
            return
        }
        imagePicker.mediaTypes = [kUTTypeImage as String]
        imagePicker.sourceType = .camera
        imagePicker.allowsEditing = false
        present(imagePicker, animated: true, completion: nil)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }

    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if error != nil {
            // error feedback goes here
        }
        else{
            // save db reference here

            let fetchOptions = PHFetchOptions()
            fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
            if let asset = PHAsset.fetchAssets(with: PHAssetMediaType.image, options: fetchOptions).firstObject {
                print("Found the asset: \(asset.location)")
            }
        }
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {

        guard let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage else {
            //TODO
            return
        }

        imageView.contentMode = .scaleAspectFit
        imageView.image = pickedImage

        // If the image comes from the camera there is no PHAsset
        if picker.sourceType == .camera {

            let completionSelector = #selector(self.image(_:didFinishSavingWithError:contextInfo:))

            UIImageWriteToSavedPhotosAlbum(pickedImage, self, completionSelector, nil)
//            if let url = info[UIImagePickerControllerImageURL] as? URL {
//                print("URL: \(url)")
//
//                PHPhotoLibrary.shared().performChanges({
//                    _ = PHAssetChangeRequest.creationRequestForAssetFromImage(atFileURL: url)
//                }, completionHandler: { (success, error) in
//                    if success {
//                        print("💃💃💃💃💃💃")
//
//
//                    }
//                })
//            }
            dismiss(animated: true, completion: nil)
        } else {
            // If the image comes from the library there is a PHAsset with potential location info


            if let asset = info[UIImagePickerControllerPHAsset] as? PHAsset {
                print("Photo location: \(asset.location)")
                if let location = asset.location {
                    latitudeLabel.text = String(describing: location.coordinate.latitude)
                    longitudeLabel.text = String(describing: location.coordinate.longitude)

                    CLGeocoder().reverseGeocodeLocation(location, completionHandler: { (placemarks, error) in
                        guard error == nil else {
                            print("Reverse geocoder failed with error: \(String(describing: error?.localizedDescription))")
                            return
                        }

                        if let placemarks = placemarks, placemarks.count > 0 {
                            placemarks.forEach({ (placemark) in
                                print("Placemark: \(placemark.name)")
                            })
                            DispatchQueue.main.async {
                                self.locationName.text = placemarks.first?.name
                            }
                        } else {
                            print("Problem with the data received from geocoder")
                            DispatchQueue.main.async {
                                self.locationName.text = "No Matching Location Found"
                            }
                        }
                    })
                }


            }

            dismiss(animated: true, completion: nil)
        }
    }
}

//extension NewReportViewController: UIImagePickerControllerDelegate {
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
//        defer {
//            dismiss(animated: true, completion: nil)
//        }
//        print(info)
//    }
//}

