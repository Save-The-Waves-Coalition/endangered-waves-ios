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
import FirebaseAuth

struct AuthDataUserModel: Codable {
    let userId: String
    let email: String?
    let photoUrl: String?

    init(user: User) {
        self.userId = user.uid
        self.email = user.email
        self.photoUrl = user.photoURL?.absoluteString
    }
}

struct UserModel: Codable {
    let firstName: String?
    let lastName: String?
    let deviceUdId: String?
    let email: String?
    let userId: String
    let isSubscribe: Bool

    init(firstName: String, lastName: String, deviceId: String, email: String, userId: String, isSubscribe: Bool) {
        self.firstName = firstName
        self.lastName = lastName
        self.deviceUdId = deviceId
        self.email = email
        self.userId = userId
        self.isSubscribe = isSubscribe
    }

    func documentDataDictionary() -> [String: Any] {
        return ["firstName": firstName ?? "", "lastName": lastName ?? "", "UDID": deviceUdId ?? "", "email": email ?? "", "isSubscribe": isSubscribe]
    }
}

class APIManager {
    static func clearWebViewCache() {
        let websiteDataTypes: Set = [WKWebsiteDataTypeDiskCache, WKWebsiteDataTypeMemoryCache]
        let date = Date(timeIntervalSince1970: 0)
        WKWebsiteDataStore.default().removeData(ofTypes: websiteDataTypes, modifiedSince: date, completionHandler: {})
    }

    static func getActiveCompetition(completionHandler: @escaping (Competition?, Error?) -> Void) {
        //        APIManager.clearWebViewCache() // Used during html development
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
                var activeCompetition: Competition?
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

    static func createNewReport(name: String, address: String, coordinate: GeoPoint, creationDate: Date,
                                description: String,
                                emailAddress: String,
                                images: [UIImage],
                                type: ReportType, status: ReportStauts,
                                progressHandler: @escaping (Double) -> Void,
                                completionHandler: @escaping (String?, Report?, Error?) -> Void) {

        uploadImages(images, progressHandler: { (progress) in
            progressHandler(progress)
        }, completionHandler: { (uploadedImageURLStrings, error) in
            guard let uploadedImageURLStrings = uploadedImageURLStrings else {
                completionHandler(nil, nil, error!)
                return
            }
            let userInfo = Global.getModelFromUserDefault(model: AuthDataUserModel.self, key: .currentUser)
            let report = Report(name: name,
                                address: address,
                                coordinate: coordinate,
                                creationDate: Date(),
                                description: description,
                                imageURLs: uploadedImageURLStrings, thumbImagesURLs: [""],
                                type: type, status: status,
                                user: userInfo?.userId ?? "")

            uploadReport(report, completionHandler: { (reportReference, error) in
                if let error = error {
                    completionHandler(nil, nil, error)
                } else {
                    let reportEntry = ReportEntry(reportReference: reportReference!, emailAddress: emailAddress)
                    uploadReportEntry(reportEntry, completionHandler: { (documentID, error) in
                        if let error = error {
                            completionHandler(nil, nil, error)
                        } else {
                            completionHandler(documentID!, report, nil)
                        }
                    }) // APIManager.uploadCompetitionEntry
                }
            }) // APIManager.uploadReport
        }) // APIManager.uploadImages
    }
    static func uploadReport(_ report: Report, completionHandler: @escaping (DocumentReference?, Error?) -> Void) {
        let dataDictionary = report.documentDataDictionary()
        let collection = Firestore.firestore().collection("reports")
        var ref: DocumentReference?
        ref = collection.addDocument(data: dataDictionary, completion: { (error) in
            if let error = error {
                completionHandler(nil, error)
            } else {
                completionHandler(ref!, nil)
            }
        })
    }
    static func uploadReportEntry(_ reportEntry: ReportEntry, completionHandler: @escaping (String?, Error?) -> Void) {
        let dataDictionary = reportEntry.documentDataDictionary()
        let collection = Firestore.firestore().collection("reportEntries")
        var ref: DocumentReference?
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
            guard let imageData = image.compressedImageData(maxSizeKB: 500) else {
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

            let uploadTask = imageRef.putData(imageData, metadata: metadata) { (storageMetadata, error) in
                guard storageMetadata != nil else {
                    // An Error occured!
                    failureUploadCount += 1
                    if (successfulUploadCount + failureUploadCount) == imagesCount {
                        completionHandler(nil, NSError(domain: "STW", code: 0, userInfo: nil))
                    }
                    return
                }
                // Download URL becomes available after upload
                imageRef.downloadURL { (url, error) in

                    guard let downloadURL = url else {
                        // An Error occured!
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
                }
            }

            uploadTask.observe(.failure, handler: { (storageTaskSnapshot) in
                failureUploadCount += 1
                if (successfulUploadCount + failureUploadCount) == imagesCount {
                    completionHandler(nil, NSError(domain: "STW", code: 0, userInfo: nil))
                }
            })
        } // images.foreEach
    } // func uploadImages

    static func createNewUserData(userData: UserModel, completionHandler: @escaping (Bool?, Error?) -> Void) {
        let dataDictionary = userData.documentDataDictionary()
        let collection = Firestore.firestore().collection("userdata")
        collection.document(userData.userId).setData(dataDictionary) { (error) in
            if let error = error {
                completionHandler(false, error)
            } else {
                completionHandler(true, nil)
            }
        }
    }

    static func fetchCurrentUserData(completion: @escaping ([String: Any]?, String?) -> Void) {
        let userInfo = Global.getModelFromUserDefault(model: AuthDataUserModel.self, key: .currentUser)
        guard let userID = userInfo?.userId else {
            completion(nil, "User not logged in.")
            return
        }

        let database = Firestore.firestore()
        let userRef = database.collection("userdata").document(userID)

        userRef.getDocument { (document, error) in
            if let error = error {
                completion(nil, error.localizedDescription)
            } else if let document = document, document.exists {
                let userData = document.data()
                completion(userData, nil)
            } else {
                completion(nil, "No user data found.")
            }
        }
    }

    static func updateUserInReports(for loginEmail: String, newUserID: String) {
        let database = Firestore.firestore()
        // Step 1: Fetch all reportEntity where emailAddress matches loginEmail
        database.collection("reportEntries").whereField("emailAddress", isEqualTo: loginEmail).getDocuments { (snapshot, error) in

            if let error = error {
                print("Error fetching reportEntity: \(error.localizedDescription)")
                return
            }
            guard let documents = snapshot?.documents, !documents.isEmpty else {
                print("No matching reportEntity found.")
                return
            }
            // Step 2: Extract Firestore document references from reportReference
            let reportReferences = documents.compactMap { document -> String? in
                if let reportRef = document.data()["reportReference"] as? DocumentReference {
                    return reportRef.path  // ✅ Extract Firestore path
                } else {
                    print("Error: Missing or invalid reportReference in \(document.documentID)")
                    return nil
                }
            }

            // Step 3: Fetch each report and check `user` before updating
            for reportPath in reportReferences {
                let reportRef = database.document(reportPath) // ✅ Get Firestore reference

                reportRef.getDocument { (document, error) in
                    if let error = error {
                        print("Error fetching report \(reportPath): \(error.localizedDescription)")
                        return
                    }

                    if let document = document, document.exists {
                        let data = document.data()
                        let existingUser = data?["user"] as? String ?? ""

                        // ✅ Only update if the current user is different
                        if existingUser != newUserID {
                            reportRef.updateData(["user": newUserID]) { error in
                                if let error = error {
                                    print("Failed to update user in report \(reportPath): \(error.localizedDescription)")
                                } else {
                                    print("Successfully updated user in report \(reportPath)")
                                }
                            }
                        } else {
                            print("Skipping update for report \(reportPath) (user is already \(newUserID))")
                        }
                    }
                }
            }
        }
    }

    static func logoutUser() {
        do {
            try Auth.auth().signOut()  // ✅ Firebase Logout
            let user: AuthDataUserModel? = nil
            Global.storeModelInUserDefault(obj: user, key: .currentUser)
        } catch let error {
            print("Error logging out: \(error.localizedDescription)")
        }
    }
} // class

extension UIImage {
    func compressedImageData(maxSizeKB: Int = 500, minCompression: CGFloat = 0.5) -> Data? {
        let maxSizeBytes = maxSizeKB * 1024
        var compression: CGFloat = 0.9 // Start with high quality
        var imageData = self.jpegData(compressionQuality: compression)

        while let data = imageData, data.count > maxSizeBytes, compression > minCompression {
            compression -= 0.1
            imageData = self.jpegData(compressionQuality: compression)
        }

        return imageData
    }
}
