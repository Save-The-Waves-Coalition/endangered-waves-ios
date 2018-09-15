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
import WebKit

class APIManager {

    func clearWebViewCache() {
        let websiteDataTypes: Set = [WKWebsiteDataTypeDiskCache, WKWebsiteDataTypeMemoryCache]
        let date = Date(timeIntervalSince1970: 0)
        WKWebsiteDataStore.default().removeData(ofTypes: websiteDataTypes, modifiedSince: date, completionHandler: {})
    }

    static func getActiveCompetition(completionHandler: @escaping (Competition?, Error?) -> Void) {

//        clearWebViewCache() // Used during html development
        // Check Firebase for all competitions
        let rightNow = Date()
        let query = Firestore.firestore().collection("competitions")
            .whereField("endDate", isGreaterThanOrEqualTo: rightNow)
            .order(by: "endDate", descending: false)
        query.getDocuments { (querySnapshot, err) in
            if let err = err {
                // Firebase Error
                completionHandler(nil, err)
                return
            } else {
                guard let querySnapshot = querySnapshot else {
                    // Firebase error, should never happen
                    let userInfoDictionary = ["description": "Firebase Firestore issue."]
                    completionHandler(nil, NSError(domain: "STW", code: 0, userInfo: userInfoDictionary))
                    return
                }

                var activeCompetition: Competition? = nil
                for document in querySnapshot.documents where activeCompetition == nil {
                    guard let competition = Competition.createCompetitionWithSnapshot(document) else {
                        // Issue with the record on Firebase, go to the next document
                        continue
                    }

                    if rightNow.isBetween(competition.startDate, and: competition.endDate) {
                        // Set activeCompetition
                        activeCompetition = competition
                        break
                    } // if rightNow.isBetween
                } // for document in querySnapshot.documents {

                if var activeCompetition = activeCompetition {
                    // Comp is active, download the HTML
                    let task = URLSession.shared.downloadTask(with: activeCompetition.introPageURL) { (localURL, urlResponse, error) in
                        if let error = error {
                            // URL Session Error
                            completionHandler(nil, error)
                            return
                        } else {
                            guard let localURL = localURL else {
                                // Issue saving the HTML locally
                                let userInfoDictionary = ["description": "HTML was not saved locally."]
                                completionHandler(nil, NSError(domain: "STW", code: 1, userInfo: userInfoDictionary))
                                return
                            }

                            do {
                                let htmlString = try String(contentsOf: localURL)
                                activeCompetition.introPageHTML = htmlString
                                completionHandler(activeCompetition, nil)
                                return
                            } catch {
                                // Issue making an HTML string
                                let userInfoDictionary = ["description": "HTML could not be turned into a string."]
                                completionHandler(nil, NSError(domain: "STW", code: 2, userInfo: userInfoDictionary))
                                return
                            }
                        }
                    }
                    task.resume()
                } else {
                    // No active competitions
                    let userInfoDictionary = ["description": "No active competitions."]
                    completionHandler(nil, NSError(domain: "STW", code: 3, userInfo: userInfoDictionary))
                    return
                }
            } // else
        } // query.getDocuments { (querySnapshot, err) in
    } // getActiveCompetition

    static func createNewReport(name: String,
                                address: String,
                                coordinate: GeoPoint,
                                creationDate: Date,
                                description: String,
                                emailAddress: String,
                                images: [UIImage],
                                type: ReportType,
                                progressHandler: @escaping (Double) -> Void,
                                completionHandler: @escaping (String?, Report?, Error?) -> Void) {

        uploadImages(images, progressHandler: { (progress) in
            progressHandler(progress)
        }, completionHandler: { (uploadedImageURLStrings, error) in
            guard let uploadedImageURLStrings = uploadedImageURLStrings else {
                completionHandler(nil, nil, error!)
                return
            }

            guard let userID = UserMananger.shared.user?.uid else {
                completionHandler(nil, nil, NSError(domain: "STW", code: 0, userInfo: nil))
                return
            }

            let report = Report(name: name,
                                address: address,
                                coordinate: coordinate,
                                creationDate: Date(),
                                description: description,
                                imageURLs: uploadedImageURLStrings,
                                type: type,
                                user: userID)

            uploadReport(report, completionHandler: { (reportReference, error) in
                if let error = error {
                    completionHandler(nil, nil, error)
                } else {
                    if report.type == .competition {
                        let competitionEntry = CompetitionEntry(reportReference: reportReference!, emailAddress: emailAddress)
                        uploadCompetitionEntry(competitionEntry, completionHandler: { (documentID, error) in
                            if let error = error {
                                completionHandler(nil, nil, error)
                            } else {
                                completionHandler(documentID!, report, nil)
                            }
                        }) // APIManager.uploadCompetitionEntry
                    } else {
                        completionHandler(reportReference!.documentID, report, nil)
                    }
                }
            }) // APIManager.uploadReport
        }) // APIManager.uploadImages
    }

    static func uploadReport(_ report: Report, completionHandler: @escaping (DocumentReference?, Error?) -> Void) {
        let dataDictionary = report.documentDataDictionary()
        let collection = Firestore.firestore().collection("reports")
        var ref: DocumentReference? = nil
        ref = collection.addDocument(data: dataDictionary, completion: { (error) in
            if let error = error {
                completionHandler(nil, error)
            } else {
                completionHandler(ref!, nil)
            }
        })
    }

    static func uploadCompetitionEntry(_ competitionEntry: CompetitionEntry, completionHandler: @escaping (String?, Error?) -> Void) {
        let dataDictionary = competitionEntry.documentDataDictionary()
        let collection = Firestore.firestore().collection("competitionEntries")
        var ref: DocumentReference? = nil
        ref = collection.addDocument(data: dataDictionary, completion: { (error) in
            if let error = error {
                completionHandler(nil, error)
            } else {
                completionHandler(ref!.documentID, nil)
            }
        })
    }

    static func uploadImages(_ images: [UIImage],
                             progressHandler: @escaping (Double) -> Void,
                             completionHandler: @escaping ([String]?, Error?) -> Void) {

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
