//
//  Competition.swift
//  Endangered Waves
//
//  Created by Matthew Morey on 9/6/18.
//  Copyright © 2018 Save The Waves. All rights reserved.
//

import Foundation
import UIKit
import FirebaseFirestore

struct Competition {
    var startDate: Date
    var endDate: Date
    var title: String
    var description: String
    var introPageURL: URL
    var introPageHTML: String?

    init(title: String, description: String, introPageURL: URL, startDate: Date, endDate: Date) {
        self.title = title
        self.description = description
        self.introPageURL = introPageURL
        self.startDate = startDate
        self.endDate = endDate
    }

    static func createCompetitionWithDictionary(_ dictionary: [String: Any]) -> Competition? {
        guard let startDateTimestamp = dictionary["startDate"] as? Timestamp,
            let endDateTimestamp = dictionary["endDate"] as? Timestamp
            else {
                assertionFailure("⚠️: Missing value for competition")
                return nil
        }

        let langCode = Bundle.main.preferredLocalizations[0].prefix(2)

        /*
         let introPageURLString = dictionary["introPageURL"] as? String,
             let introPageURL = URL(string: introPageURLString),
         */

        let introPageURLString: String
        let firebaseIntroPageURLStringKey = "introPageURL_\(langCode)"
        if let localizedIntroPageURLString = dictionary[firebaseIntroPageURLStringKey] as? String {
            introPageURLString = localizedIntroPageURLString
        } else if let defaultIntroPageURLString = dictionary["introPageURL"] as? String {
            introPageURLString = defaultIntroPageURLString
        } else {
            assertionFailure("⚠️: introPageURL for competition not found")
            return nil
        }

        guard let introPageURL = URL(string: introPageURLString) else {
            assertionFailure("⚠️: Missing URL for competition")
            return nil
        }

        let title: String
        let firebaseTitleKey = "title_\(langCode)"
        if let localizedTitle = dictionary[firebaseTitleKey] as? String {
            title = localizedTitle
        } else if let defaultTitle = dictionary["title"] as? String {
            title = defaultTitle
        } else {
            assertionFailure("⚠️: Title for competition not found")
            return nil
        }

        let description: String
        let firebaseDescriptionKey = "description_\(langCode)"
        if let localizedDescription = dictionary[firebaseDescriptionKey] as? String {
            description = localizedDescription
        } else if let defaultDescription = dictionary["description"] as? String {
            description = defaultDescription
        } else {
            assertionFailure("⚠️: Description for competition not found")
            return nil
        }

        let startDate = startDateTimestamp.dateValue()
        let endDate = endDateTimestamp.dateValue()

        return Competition(title: title, description: description, introPageURL: introPageURL, startDate: startDate, endDate: endDate)
    }
}

extension Competition {
    static func createCompetitionWithSnapshot(_ snapshot: DocumentSnapshot) -> Competition? {
        guard let data = snapshot.data() else {
            return nil
        }
        return self.createCompetitionWithDictionary(data)
    }

    func documentDataDictionary() -> [String: Any] {
        return [
            "title": title,
            "description": description,
            "introPageURL": introPageURL.absoluteString,
            "startDate": startDate,
            "endDate": endDate]
    }
}

extension Competition {
    func dateDisplayString() -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        let dateString = "\(formatter.string(from: startDate)) - \(formatter.string(from: endDate))"
        return dateString
    }
}
