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

    static func createNewReport(name: String,
                                address: String,
                                coordinate: GeoPoint,
                                creationDate: Date,
                                description: String,
                                images: [UIImage],
                                type: ReportType,
                                progressHandler: @escaping (Double) -> Void,
                                completionHandler: @escaping (String?, Error?) -> Void) {

        uploadImages(images, progressHandler: { (progress) in
            progressHandler(progress)
        }) { (uploadedImageURLStrings, error) in
            guard let uploadedImageURLStrings = uploadedImageURLStrings else {
                completionHandler(nil, error!)
                return
            }

            guard let userID = UserMananger.shared.user?.uid else {
                completionHandler(nil, NSError(domain: "STW", code: 0, userInfo: nil))
                return
            }

            let report = Report(name: name, address: address, coordinate: coordinate, creationDate: Date(), description: description, imageURLs: uploadedImageURLStrings, type: type, user: userID)

            uploadReport(report, completionHandler: { (documentID, error) in
                if let error = error {
                    completionHandler(nil, error)
                } else {
                    completionHandler(documentID, nil)
                }
            }) // APIManager.uploadReport
        } // APIManager.uploadImages
    }

    static func uploadReport(_ report: Report, completionHandler: @escaping (String?, Error?) -> Void) {
        let dataDictionary = report.documentDataDictionary()
        let collection = Firestore.firestore().collection("reports")
        var ref: DocumentReference? = nil
        ref = collection.addDocument(data: dataDictionary, completion: { (error) in
            if let error = error {
                completionHandler(nil, error)
            } else {
                completionHandler(ref!.documentID, nil)
            }
        })
    }

    static func uploadImages(_ images: [UIImage], progressHandler: @escaping (Double) -> Void, completionHandler: @escaping ([String]?, Error?) -> Void) {

        let storage = Storage.storage()

        var uploadedImageURLStrings = [String]()
        var successfulUploadCount = 0
        var failureUploadCount = 0
        let imagesCount = images.count

        images.forEach { (image) in

            guard let imageData = UIImageJPEGRepresentation(image, 0.8) else {
                failureUploadCount += 1
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
                    failureUploadCount += 1
                    if (successfulUploadCount + failureUploadCount) == imagesCount {
                        completionHandler(nil, NSError(domain: "STW", code: 0, userInfo: nil))
                    }
                    return
                }

                let downloadURLString = downloadURL.absoluteString
                uploadedImageURLStrings.append(downloadURLString)

                successfulUploadCount += 1
                progressHandler(Double(successfulUploadCount)/Double(imagesCount))

                if (successfulUploadCount + failureUploadCount) == imagesCount {
                    completionHandler(uploadedImageURLStrings, nil)
                }
            })

            uploadTask.observe(.failure, handler: { (storageTaskSnapshot) in
                failureUploadCount += 1
                if (successfulUploadCount + failureUploadCount) == imagesCount {
                    completionHandler(nil, NSError(domain: "STW", code: 0, userInfo: nil))
                }
            })
        } // images.foreEach
    } // func uploadImages
} // class
