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

    init(title: String, description: String, startDate: Date, endDate: Date) {
        self.title = title
        self.description = description
        self.startDate = startDate
        self.endDate = endDate
    }

    static func createCompetitionWithDictionary(_ dictionary: [String: Any]) -> Competition? {
        guard let title = dictionary["title"] as? String,
            let description = dictionary["description"] as? String,
            let startDate = dictionary["startDate"] as? Date,
            let endDate = dictionary["endDate"] as? Date
            else {
                return nil
        }
        return Competition(title: title, description: description, startDate: startDate, endDate: endDate)
    }
}

extension Competition {
    static func createCompetitionWithSnapshot(_ snapshot: DocumentSnapshot) -> Competition? {
        // TODO: Fix this "!"
        return self.createCompetitionWithDictionary(snapshot.data()!)
    }

    func documentDataDictionary() -> [String: Any] {
        return [
            "title": title,
            "description": description,
            "startDate": startDate,
            "endDate": endDate]
    }
}