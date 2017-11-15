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
}

class NewReportViewController: UITableViewController {

    weak var delegate: NewReportViewControllerDelegate?

    @IBOutlet weak var imageView: UIImageView!

    var images: [UIImage]?

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let images = images {
            imageView.image = images.first
        }
    }

    @IBAction func saveButtonWasTapped(_ sender: UIBarButtonItem) {
        // TODO: Save Report
        delegate?.viewController(self, didTapSaveButton: sender)
    }

    @IBAction func cancelButtonWasTapped(_ sender: UIBarButtonItem) {
        delegate?.viewController(self, didTapCancelButton: sender)
    }

    @IBAction func imageViewWasTapped(_ sender: UITapGestureRecognizer) {
        print("stop it")
    }
}

extension NewReportViewController: StoryboardInstantiable {
    static var storyboardName: String { return "new-report" }
    static var storyboardIdentifier: String? { return "NewReportComponent" }
}


/**


 //        let type = ReportType(rawValue: typeTextField.text ?? "other")
 //        let userID = Auth.auth().currentUser?.uid
 //        let coordinate = CLLocationCoordinate2D(latitude: CLLocationDegrees(latitudeLabel.text ?? "0")!, longitude: CLLocationDegrees(longitudeLabel.text ?? "0")!)
 //        let reportLocation = ReportLocation(name: locationName.text, coordinate: coordinate)
 //        let report = Report(creationDate: Date(), description: descriptionTextField.text, imageURLs: nil, location: reportLocation, type: type, user: userID)
 //
 //        let collection = Firestore.firestore().collection("reports")
 //
 //        let reportData = report.documentDataDictionary()
 //        print(reportData)
 //
 //        collection.addDocument(data: report.documentDataDictionary()!)
 //
 //
 //        dismiss(animated: true, completion: nil)
 @IBAction func capturePhotoButtonWasTapped(_ sender: UIButton) {

 present(imagePickerController, animated: true, completion: nil)

 return



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



 override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
 if segue.identifier == "LocationPickerSegue" {
 let locationPicker = segue.destination as! LocationPicker
 //            locationPicker.isAllowArbitraryLocation = true
 locationPicker.addBarButtons()
 locationPicker.pickCompletion = { (pickedLocationItem) in
 self.locationName2.text = pickedLocationItem.name
 }
 }
 }
 }

 // MARK: 📸 UIImagePickerControllerDelegate
 extension NewReportViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {

 func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
 picker.dismiss(animated: true, completion: nil)
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
 // Save to user's photo library
 let completionSelector = #selector(self.image(_:didFinishSavingWithError:contextInfo:))
 UIImageWriteToSavedPhotosAlbum(pickedImage, self, completionSelector, nil)
 dismiss(animated: true, completion: nil)
 } else {
 // If the image comes from the library there is a PHAsset with potential location info
 if let asset = info[UIImagePickerControllerPHAsset] as? PHAsset {

 if let location = asset.location {

 latitudeLabel.text = String(describing: location.coordinate.latitude)
 longitudeLabel.text = String(describing: location.coordinate.longitude)

 CLGeocoder().reverseGeocodeLocation(location, completionHandler: { (placemarks, error) in
 guard error == nil else {
 print("Reverse geocoder failed with error: \(String(describing: error?.localizedDescription))")
 return
 }

 if let placemarks = placemarks, placemarks.count > 0 {
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

 extension NewReportViewController: ImagePickerDelegate {
 func wrapperDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
 guard images.count > 0 else { return }

 let lightboxImages = images.map {
 return LightboxImage(image: $0)
 }

 let lightbox = LightboxController(images: lightboxImages, startIndex: 0)
 imagePicker.present(lightbox, animated: true, completion: nil)
 }

 func doneButtonDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
 imagePicker.dismiss(animated: true, completion: nil)
 }

 func cancelButtonDidPress(_ imagePicker: ImagePickerController) {
 imagePicker.dismiss(animated: true, completion: nil)
 }


 */
