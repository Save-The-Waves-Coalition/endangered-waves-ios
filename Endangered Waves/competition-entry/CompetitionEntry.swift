//
//  CompetitionEntry.swift
//  Endangered Waves
//
//  Created by Matthew Morey on 9/15/18.
//  Copyright © 2018 Save The Waves. All rights reserved.
//

import Foundation
import UIKit
import FirebaseFirestore

struct CompetitionEntry {
    var reportReference: DocumentReference
    var emailAddress: String

    init(reportReference: DocumentReference, emailAddress: String) {
        self.reportReference = reportReference
        self.emailAddress = emailAddress
    }

    static func createUserSTWWithDictionary(_ dictionary: [String: Any]) -> CompetitionEntry? {
        guard let reportReference = dictionary["reportReference"] as? DocumentReference, let emailAddress = dictionary["emailAddress"] as? String else {
            return nil
        }
        return CompetitionEntry(reportReference: reportReference, emailAddress: emailAddress)
    }
}

extension CompetitionEntry {
    static func createUserSTWWithSnapshot(_ snapshot: DocumentSnapshot) -> CompetitionEntry? {
        return self.createUserSTWWithDictionary(snapshot.data()!)
    }

    func documentDataDictionary() -> [String: Any] {
        return ["reportReference": reportReference, "emailAddress": emailAddress]
    }
}
