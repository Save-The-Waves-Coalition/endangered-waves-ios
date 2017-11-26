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
    var name: String?
    var coordinate: CLLocationCoordinate2D?

    init(name: String?, coordinate: CLLocationCoordinate2D?) {
        if let name = name {
            self.name = name
        }
        if let coordinate = coordinate {
            self.coordinate = coordinate
        }
    }

    init(dictionary: [String: Any]) {
        if let name = dictionary["name"] as? String {
            self.name = name
        }
        if let coordinate = dictionary["coordinate"] as? GeoPoint {
            self.coordinate = CLLocationCoordinate2D(latitude: coordinate.latitude, longitude: coordinate.longitude)
        }
    }
}

extension ReportLocation {
    init(snapshot: DocumentSnapshot) {
        self.init(dictionary: snapshot.data())
    }

    func documentDataDictionary() -> [String: Any]? {
        var dictionary = [String: Any]()
        if let name = name {
            dictionary["name"] = name
        }
        if let coordinate = coordinate {
            dictionary["coordinate"] = GeoPoint(latitude: coordinate.latitude, longitude: coordinate.longitude)
        }
        return (dictionary.count > 0) ? dictionary : nil
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
    var creationDate: Date?
    var description: String?
    var imageURLs: [String]?
    var location: ReportLocation?
    var type: ReportType?
    var user: String?

    init(creationDate: Date?, description: String?, imageURLs: [String]?, location: ReportLocation?, type: ReportType?, user: String?) {
        if let creationDate = creationDate {
            self.creationDate = creationDate
        }
        if let description = description {
            self.description = description
        }
        if let imageURLs = imageURLs {
            self.imageURLs = imageURLs
        }
        if let location = location {
            self.location = location
        }
        if let type = type {
            self.type = type
        }
        if let user = user {
            self.user = user
        }
    }

    init(dictionary: [String: Any]) {
        if let creationDate = dictionary["creationDate"] as? Date {
            self.creationDate = creationDate
        }
        if let description = dictionary["description"] as? String {
            self.description = description
        }
        if let imageURLs = dictionary["imageURLs"] as? [String] {
            self.imageURLs = imageURLs
        }
        if let location = dictionary["location"] as? [String: Any] {
            self.location = ReportLocation(dictionary: location)
        }
        if let type = dictionary["type"] as? String {
            let enumType = ReportType(rawValue: type)
            self.type = enumType
        }
        if let user = dictionary["user"] as? String {
            self.user = user
        }
    }
}

extension Report {
    init(snapshot: DocumentSnapshot) {
        self.init(dictionary: snapshot.data())
    }

    func documentDataDictionary() -> [String: Any]? {
        var dictionary = [String: Any]()
        if let creationDate = creationDate {
            dictionary["creationDate"] = creationDate
        }
        if let description = description {
            dictionary["description"] = description
        }
        if let imageURLs = imageURLs {
            dictionary["imageURLs"] = imageURLs
        }
        if let location = location {
            dictionary["location"] = location.documentDataDictionary()
        }
        if let type = type {
            dictionary["type"] = type.rawValue
        }
        if let user = user {
            dictionary["user"] = user
        }
        return (dictionary.count > 0) ? dictionary : nil
    }
}

extension Report {
    func dateDisplayString() -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        let dateString = formatter.string(from: creationDate ?? Date())
        return dateString
    }
}
