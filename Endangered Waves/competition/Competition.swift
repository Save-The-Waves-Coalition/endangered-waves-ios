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
        guard let title = dictionary["title"] as? String,
            let description = dictionary["description"] as? String,
            let introPageURLString = dictionary["introPageURL"] as? String,
            let introPageURL = URL(string: introPageURLString),
            let startDateTimestamp = dictionary["startDate"] as? Timestamp,
            let endDateTimestamp = dictionary["endDate"] as? Timestamp
            else {
                return nil
        }

        let startDate = startDateTimestamp.dateValue()
        let endDate = endDateTimestamp.dateValue()

        return Competition(title: title, description: description, introPageURL: introPageURL, startDate: startDate, endDate: endDate)
    }
}

extension Competition {
    static func createCompetitionWithSnapshot(_ snapshot: DocumentSnapshot) -> Competition? {
        // TODO: Fix this "!"
        return self.createCompetitionWithDictionary(snapshot.data()!)
    }

    static func createCompetitionWithSnapshot(_ snapshot: DocumentSnapshot, introPageHTML: String) -> Competition? {
        // TODO: Fix this "!"
        var competition = self.createCompetitionWithDictionary(snapshot.data()!)
        competition?.introPageHTML = introPageHTML
        return competition
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
        let dateString = "\(formatter.string(from: startDate)) to \(formatter.string(from: endDate))"
        return dateString
    }
}
