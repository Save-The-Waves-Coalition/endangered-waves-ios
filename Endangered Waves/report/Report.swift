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
    case oilSpill = "OilSpill"
    case sewage = "Sewage"
    case trashed = "Trashed"
    case coastalErosion = "CoastalErosion"
    case accessLost = "AccessLost"
    case general = "General"
    init() {
        self = .general
    }
}

extension ReportType {
    func displayString() -> String {
        switch self {
        case .oilSpill:
            return "Oil Spill"
        case .sewage:
            return "Sewage "
        case .trashed:
            return "Trashed"
        case .coastalErosion:
            return "Coastal Erosion"
        case .accessLost:
            return "Access Lost"
        case .general:
            return "General"
        }
    }

    func placemarkIcon() -> UIImage {
        switch self {
        case .oilSpill:
            return Style.iconOilPlacemark
        case .sewage:
            return Style.iconSewagePlacemark
        case .trashed:
            return Style.iconTrashPlacemark
        case .coastalErosion:
            return Style.iconCoastalErosionPlacemark
        case .accessLost:
            return Style.iconAccessPlacemark
        case .general:
            return Style.iconGeneralPlacemark
        }
    }

    func icon() -> UIImage {
        switch self {
        case .oilSpill:
            return Style.iconOil
        case .sewage:
            return Style.iconSewage
        case .trashed:
            return Style.iconTrash
        case .coastalErosion:
            return Style.iconCoastalErosion
        case .accessLost:
            return Style.iconAccess
        case .general:
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
