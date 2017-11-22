//
//  APIManager.swift
//  Endangered Waves
//
//  Created by Matthew Morey on 11/19/17.
//  Copyright © 2017 Save The Waves. All rights reserved.
//

import Foundation
import Firebase
import LocationPickerViewController

class APIManager {

    static func createNewReport(creationDate: Date, description: String, images: [UIImage], location: LocationItem, type: ReportType, user: String, progressHandler: @escaping (Double) -> (), completionHandler: @escaping (String?, Error?) -> ()) {

        uploadImages(images, progressHandler: { (progress) in
            progressHandler(progress)
        }) { (uploadedImageURLStrings, error) in
            guard let uploadedImageURLStrings = uploadedImageURLStrings else {
                completionHandler(nil, error!)
                return
            }

            // TODO: Use actual user here
            let reportLocation = ReportLocation(name: location.name, coordinate: location.mapItem.placemark.coordinate)
            let report = Report(creationDate: Date(), description: description, imageURLs: uploadedImageURLStrings, location: reportLocation, type: type, user: "matt_is_testing")

            uploadReport(report, completionHandler: { (documentID, error) in
                if let error = error {
                    completionHandler(nil, error)
                } else {
                    completionHandler(documentID, nil)
                }
            }) // APIManager.uploadReport
        } // APIManager.uploadImages
    }

    static func uploadReport(_ report: Report, completionHandler: @escaping (String?, Error?) -> ()) {
        if let dataDictionary = report.documentDataDictionary() {
            let collection = Firestore.firestore().collection("reports")
            var ref: DocumentReference? = nil
            ref = collection.addDocument(data: dataDictionary, completion: { (error) in
                if let error = error {
                    completionHandler(nil, error)
                } else {
                    completionHandler(ref!.documentID, nil)
                }
            })
        } else {
            completionHandler(nil, NSError(domain: "STW", code: 1, userInfo: nil))
        }
    }

    static func uploadImages(_ images : [UIImage], progressHandler: @escaping (Double) -> (), completionHandler: @escaping ([String]?, Error?) -> ()){

        let storage = Storage.storage()

        var uploadedImageURLStrings = [String]()
        var successfulUploadCount = 0
        var failureUploadCount = 0
        let imagesCount = images.count

        images.forEach { (image) in

            guard let imageData = UIImageJPEGRepresentation(image, 0.8) else {
                failureUploadCount = failureUploadCount + 1
                return
            }

            // Image path and name
            let imageName = NSUUID().uuidString + ".jpg"
            let reportImagesRef = storage.reference().child("report-images")
            let imageRef = reportImagesRef.child(imageName)

            // Metadata
            let metadata = StorageMetadata()
            metadata.contentType = "image/jpeg"

            let uploadTask = imageRef.putData(imageData, metadata: metadata)

            uploadTask.observe(.success, handler: { (storageTaskSnapshot) in

                guard let metaData = storageTaskSnapshot.metadata, let downloadURL = metaData.downloadURL() else {
                    failureUploadCount = failureUploadCount + 1
                    if (successfulUploadCount + failureUploadCount) == imagesCount {
                        completionHandler(nil, NSError(domain: "STW", code: 0, userInfo: nil))
                    }
                    return
                }

                let downloadURLString = downloadURL.absoluteString
                uploadedImageURLStrings.append(downloadURLString)

                successfulUploadCount = successfulUploadCount + 1
                progressHandler(Double(successfulUploadCount)/Double(imagesCount))

                if (successfulUploadCount + failureUploadCount) == imagesCount {
                    completionHandler(uploadedImageURLStrings, nil)
                }
            })

            uploadTask.observe(.failure, handler: { (storageTaskSnapshot) in
                failureUploadCount = failureUploadCount + 1
                if (successfulUploadCount + failureUploadCount) == imagesCount {
                    completionHandler(nil, NSError(domain: "STW", code: 0, userInfo: nil))
                }
            })
        } // images.foreEach
    } // func uploadImages
} // class
