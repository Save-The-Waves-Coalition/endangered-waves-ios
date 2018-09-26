//
//  ReportEntry.swift
//  Endangered Waves
//
//  Created by Matthew Morey on 9/15/18.
//  Copyright © 2018 Save The Waves. All rights reserved.
//

import Foundation
import UIKit
import FirebaseFirestore

struct ReportEntry {
    var reportReference: DocumentReference
    var emailAddress: String

    init(reportReference: DocumentReference, emailAddress: String) {
        self.reportReference = reportReference
        self.emailAddress = emailAddress
    }

    static func createUserSTWWithDictionary(_ dictionary: [String: Any]) -> ReportEntry? {
        guard let reportReference = dictionary["reportReference"] as? DocumentReference, let emailAddress = dictionary["emailAddress"] as? String else {
            return nil
        }
        return ReportEntry(reportReference: reportReference, emailAddress: emailAddress)
    }
}

extension ReportEntry {
    static func createUserSTWWithSnapshot(_ snapshot: DocumentSnapshot) -> ReportEntry? {
        return self.createUserSTWWithDictionary(snapshot.data()!)
    }

    func documentDataDictionary() -> [String: Any] {
        return ["reportReference": reportReference, "emailAddress": emailAddress]
    }
}
