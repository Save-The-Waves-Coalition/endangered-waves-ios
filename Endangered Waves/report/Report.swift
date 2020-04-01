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

enum ReportType: String {
    case oilSpill = "OilSpill"
    case sewage = "Sewage"
    case trashed = "Trashed"
    case coastalErosion = "CoastalErosion"
    case accessLost = "AccessLost"
    case general = "General"
    case competition = "Competition"
    case wsr = "World Surfing Reserve"
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
            return "Sewage"
        case .trashed:
            return "Trashed"
        case .coastalErosion:
            return "Coastal Erosion"
        case .accessLost:
            return "Access Lost"
        case .general:
            return "General"
        case .competition:
            return "Competition"
        case .wsr:
            return "World Surfing Reserve"
        }

    }

    func hashTagString() -> String {
        switch self {
        case .oilSpill:
            return "#oilspill"
        case .sewage:
            return "#sewagespill"
        case .trashed:
            return "#trashed"
        case .coastalErosion:
            return "#coastalerosion"
        case .accessLost:
            return "#accesslost"
        case .general:
            return "#general"
        case .competition:
            return "#competition"
        case .wsr:
            return "#worldsurfingreserve"
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
        case .competition:
            return Style.iconCompetitionPlacemark
        case .wsr:
            return Style.iconWsrPlacemark
        }
    }
    
    func wsrPlacemarkIcon(key: String) -> UIImage{
        print(key)
        if let placemarker = Style.wsrPlacemarkers[key]{
            return placemarker
        }else{
        return Style.iconWsrPlacemark
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
        case .competition:
            return Style.iconCompetition
        case .wsr:
            return Style.iconWsr
        }
    }
}


protocol STWDataType {
    var name: String {get set}
    var coordinate: GeoPoint {get set}
    var description: String {get set}
    var imageURLs: [String] {get set}
    var type: ReportType {get set}
    var address: String? {get set}
    var creationDate: Date? {get set}
    var user: String? {get set}
    var dedicated: Date? {get set}
    var url: String? {get set}

}

struct Report: STWDataType {
    var name: String
    var coordinate: GeoPoint
    var description: String
    var imageURLs: [String]
    var type: ReportType
    var address: String?
    var creationDate: Date?
    var user: String?
    var dedicated: Date?
    var url: String?

    init(name: String,
         address: String,
         coordinate: GeoPoint,
         creationDate: Date,
         description: String,
         imageURLs: [String],
         type: ReportType,
         user: String) {
        self.name = name
        self.address = address
        self.coordinate = coordinate
        self.creationDate = creationDate
        self.description = description
        self.imageURLs = imageURLs
        self.type = type
        self.user = user
    }

    static func createReportWithDictionary(_ dictionary: [String: Any]) -> Report? {

        guard let name = dictionary["name"] as? String else {
            assertionFailure("⚠️: Name for Report not found")
            return nil
        }

        guard let address = dictionary["address"] as? String else {
            assertionFailure("⚠️: Address for Report not found")
            return nil
        }

        guard let coordinate = dictionary["coordinate"] as? GeoPoint else {
            assertionFailure("⚠️: Coordinate for Report not found")
            return nil
        }

        // TODO: Should we be using Firebase Timestamp type instead of Swift Date?
        guard let creationDate = dictionary["creationDate"] as? Timestamp else {
            assertionFailure("⚠️: CreationDate for Report not found")
            return nil
        }

        guard let description = dictionary["description"] as? String else {
            assertionFailure("⚠️: Description for Report not found")
            return nil
        }

        guard let imageURLs = dictionary["imageURLs"] as? [String?] else {
            assertionFailure("⚠️: ImageURLs for Report not found")
            return nil
        }

        guard let typeString = dictionary["type"] as? String else {
            assertionFailure("⚠️: TypeString for Report not found")
            return nil
        }

        // TODO: 2020-03-14 MDM We need to define what the various types are, it matters for iOS currently,
        //                      we could just make it fall back to general and be done with it ¯\(°_o)/¯
        let type = ReportType(rawValue: typeString) ?? ReportType.general
//        guard let type = ReportType(rawValue: typeString) else {
//            assertionFailure("⚠️: Type for Report not found")
//            return nil
//        }

        guard let user = dictionary["user"] as? String else {
            assertionFailure("⚠️: User for Report not found")
            return nil
        }

        return Report(name: name,
                      address: address,
                      coordinate: coordinate,
                      creationDate: creationDate.dateValue(),
                      description: description,
                      imageURLs: imageURLs.compactMap { $0 }, // new array with all values unwrapped and all nil's filtered away
                      type: type,
                      user: user)
    }
}

struct WorldSurfingReserve: STWDataType {
    var name: String
    var coordinate: GeoPoint
    var description: String
    var imageURLs: [String]
    var type: ReportType
    var creationDate: Date?
    var address: String?
    var user: String?
    var dedicated: Date?
    var url: String?

    init(name: String,
         coordinate: GeoPoint,
         dedicated: Date,
         description: String,
         imageURLs: [String],
         type: ReportType,
         url: String) {
        self.name = name
        self.coordinate = coordinate
        self.dedicated = dedicated
        self.description = description
        self.imageURLs = imageURLs
        self.type = type
        self.url = url
    }
    static func createWsrWithDictionary(_ dictionary: [String: Any]) -> WorldSurfingReserve? {
        
        guard let name = dictionary["name"] as? String else {
            assertionFailure("⚠️: Name of World Surfing Reserve not found")
            return nil
        }
        
        guard let coordinate = dictionary["coordinate"] as? GeoPoint else {
            assertionFailure("⚠️: Coordinate for World Surfing Reserve  not found")
            return nil
        }
        
        // TODO: Should we be using Firebase Timestamp type instead of Swift Date?
        guard let dedicated = dictionary["dedicated"] as? Timestamp else {
            assertionFailure("⚠️: Dedication Date for World Surfing Reserve  not found")
            return nil
        }
        
        guard let description = dictionary["description"] as? String else {
            assertionFailure("⚠️: Description for World Surfing Reserve  not found")
            return nil
        }
        
        guard let imageURLs = dictionary["imageURLs"] as? [String?] else {
            assertionFailure("⚠️: ImageURLs for World Surfing Reserve  not found")
            return nil
        }

        guard let typeString = dictionary["type"] as? String else {
            assertionFailure("⚠️: TypeString for World Surfing Reserve not found")
            return nil
        }


        let type = ReportType(rawValue: typeString) ?? ReportType.general

        
        guard let url = dictionary["url"] as? String else {
            assertionFailure("⚠️: URL for World Surfing Reserve  not found")
            return nil
        }
        return WorldSurfingReserve(name: name,
                      coordinate: coordinate,
                      dedicated: dedicated.dateValue(),
                      description: description,
                      imageURLs: imageURLs.compactMap { $0 }, // new array with all values unwrapped and all nil's filtered away
                      type: type,
                      url: url)
    }
}

extension Report {
    static func createReportWithSnapshot(_ snapshot: DocumentSnapshot) -> Report? {
        // TODO: Fix this "!"
        return self.createReportWithDictionary(snapshot.data()!)
    }

    func documentDataDictionary() -> [String: Any] {
        let dataDictionary: [String: Any] = [
            "name": name,
            "address": address,
            "coordinate": coordinate,
            "creationDate": creationDate,
            "description": description,
            "imageURLs": imageURLs,
            "type": type.rawValue,
            "user": user]
        return dataDictionary
    }
}

extension STWDataType {
    func dateDisplayString() -> String {
        if let creationDate = creationDate{
            let formatter = DateFormatter()
            formatter.dateStyle = .long
            let dateString = formatter.string(from: creationDate)
            return dateString
        }else{
            return ""
        }
    }
}

extension WorldSurfingReserve {
    static func createWsrWithSnapshot(_ snapshot: DocumentSnapshot) -> WorldSurfingReserve? {
        // TODO: Fix this "!"
        return self.createWsrWithDictionary(snapshot.data()!)
    }

    func documentDataDictionary() -> [String: Any] {
        let dataDictionary: [String: Any] = [
            "name": name,
            "coordinate": coordinate,
            "dedicated": dedicated,
            "description": description,
            "imageURLs": imageURLs,
            "type": type.rawValue,
            "url": url]
        return dataDictionary
    }
}

extension WorldSurfingReserve {
    func dateDisplayString() -> String {
        if let dedicated = dedicated{
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        let dateString = formatter.string(from: dedicated)
        return dateString
        }else{
            print("Dedication Date for World Surfing Reserve not found")
            return ""
        }
    }
}

