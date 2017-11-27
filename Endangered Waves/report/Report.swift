//
//  Report.swift
//  Endangered Waves
//
//  Created by Matthew Morey on 11/11/17.
//  Copyright © 2017 Save The Waves. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import FirebaseFirestore

struct ReportLocation {
    var name: String
    var address: String
    var coordinate: CLLocationCoordinate2D

    init(name: String, address: String, coordinate: CLLocationCoordinate2D) {
        self.name = name
        self.address = address
        self.coordinate = coordinate
    }

    static func createReportLocationWithDictionary(_ dictionary: [String: Any]) -> ReportLocation? {
        guard let name = dictionary["name"] as? String, let address = dictionary["address"] as? String, let coordinate = dictionary["coordinate"] as? GeoPoint else {
            return nil
        }
        return ReportLocation(name: name, address: address, coordinate: CLLocationCoordinate2D(latitude: coordinate.latitude, longitude: coordinate.longitude))
    }
}

extension ReportLocation {
    static func createReportLocationWithSnapshot(_ snapshot: DocumentSnapshot) -> ReportLocation? {
        return self.createReportLocationWithDictionary(snapshot.data())
    }

    func documentDataDictionary() -> [String: Any] {
        return ["name": name,
                "address": address,
                "coordinate": GeoPoint(latitude: coordinate.latitude, longitude: coordinate.longitude)]
    }
}

enum ReportType: String {
    case OilSpill
    case Sewage
    case Trashed
    case CoastalErosion
    case AccessLost
    case General
    init() {
        self = .General
    }
}

extension ReportType {
    func displayString() -> String {
        switch self {
        case .OilSpill:
            return "Oil Spill"
        case .Sewage:
            return "Sewage "
        case .Trashed:
            return "Trashed"
        case .CoastalErosion:
            return "Coastal Erosion"
        case .AccessLost:
            return "Access Lost"
        case .General:
            return "General"
        }
    }

    func placemarkIcon() -> UIImage {
        switch self {
        case .OilSpill:
            return Style.iconOilPlacemark
        case .Sewage:
            return Style.iconSewagePlacemark
        case .Trashed:
            return Style.iconTrashPlacemark
        case .CoastalErosion:
            return Style.iconCoastalErosionPlacemark
        case .AccessLost:
            return Style.iconAccessPlacemark
        case .General:
            return Style.iconGeneralPlacemark
        }
    }

    func icon() -> UIImage {
        switch self {
        case .OilSpill:
            return Style.iconOil
        case .Sewage:
            return Style.iconSewage
        case .Trashed:
            return Style.iconTrash
        case .CoastalErosion:
            return Style.iconCoastalErosion
        case .AccessLost:
            return Style.iconAccess
        case .General:
            return Style.iconGeneral
        }
    }
}

struct Report {
    var creationDate: Date
    var description: String
    var imageURLs: [String]
    var location: ReportLocation
    var type: ReportType
    var user: String

    init(creationDate: Date, description: String, imageURLs: [String], location: ReportLocation, type: ReportType, user: String) {
        self.creationDate = creationDate
        self.description = description
        self.imageURLs = imageURLs
        self.location = location
        self.type = type
        self.user = user
    }

    static func createReportWithDictionary(_ dictionary: [String: Any]) -> Report? {
        guard let creationDate = dictionary["creationDate"] as? Date,
            let description = dictionary["description"] as? String,
            let imageURLs = dictionary["imageURLs"] as? [String],
            let locationDictionary = dictionary["location"] as? [String: Any],
            let location = ReportLocation.createReportLocationWithDictionary(locationDictionary),
            let typeString = dictionary["type"] as? String,
            let type = ReportType(rawValue: typeString),
            let user = dictionary["user"] as? String
        else {
                return nil
        }

        return Report(creationDate: creationDate, description: description, imageURLs: imageURLs, location: location, type: type, user: user)
    }
}

extension Report {
    static func createReportWithSnapshot(_ snapshot: DocumentSnapshot) -> Report? {
        return self.createReportWithDictionary(snapshot.data())
    }

    func documentDataDictionary() -> [String: Any] {
        return ["creationDate": creationDate,
                          "description": description,
                          "imageURLs": imageURLs,
                          "location": location.documentDataDictionary(),
                          "type": type.rawValue,
                          "user": user]
    }
}

extension Report {
    func dateDisplayString() -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        let dateString = formatter.string(from: creationDate)
        return dateString
    }
}
