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

// Never edit the strings here because they are stored in Firebase and you could break existing records
enum ReportType: String {
    case oilSpill = "OilSpill"
    case sewage = "Sewage"
    case trashed = "Trashed"
    case coastalErosion = "CoastalErosion"
    case accessLost = "AccessLost"
    case general = "General"
    case competition = "Competition"
    case runoff = "Runoff"
    case algalBloom = "AlgalBloom"
    case waterQuality = "WaterQuality"
    case plasticPackaging = "PlasticPackaging"
    case microPlastics = "MicroPlastics"
    case fishingGear = "FishingGear"
    case seawall = "Seawall"
    case hardArmoring = "HardArmoring"
    case beachfrontConstruction = "BeachfrontConstruction"
    case jetty = "Jetty"
    case harbor = "Harbor"
    case coastalDevelopment = "CoastalDevelopment"
    case kingTides = "KingTides"
    case seaLevelRiseOrFlooding = "SeaLevelRiseOrFlooding"
    case destructiveFishing = "DestructiveFishing"
    case bleaching = "Bleaching"
    case infrastructure = "Infrastructure"
    case coralReefImpacts = "CoralReefImpacts"
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
            return "Sewage Spill"
        case .trashed:
            return "Trash"
        case .coastalErosion:
            return "Coastal Erosion"
        case .accessLost:
            return "Beach Access"
        case .general:
            return "General Alert"
        case .competition:
            return "Competition"
        case .runoff:
            return "Runoff"
        case .algalBloom:
            return "Algal Bloom"
        case .waterQuality:
            return "Water Quality"
        case .plasticPackaging:
            return "Plastic Packaging"
        case .microPlastics:
            return "Micro-plastics"
        case .fishingGear:
            return "Fishing Gear"
        case .seawall:
            return "Seawall"
        case .hardArmoring:
            return "Hard Armoring"
        case .beachfrontConstruction:
            return "Beachfront Construction"
        case .jetty:
            return "Jetty"
        case .harbor:
            return "Harbor"
        case .coastalDevelopment:
            return "Coastal Development"
        case .kingTides:
            return "King Tides"
        case .seaLevelRiseOrFlooding:
            return "Sea Level Rise or Flooding"
        case .destructiveFishing:
            return "Destructive Fishing"
        case .bleaching:
            return "Bleaching"
        case .infrastructure:
            return "Infrastructure"
        case .coralReefImpacts:
            return "Coral Reef Impacts"
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
        case .runoff:
            return "#runoff"
        case .algalBloom:
            return "#algalbloom"
        case .waterQuality:
            return "#waterquality"
        case .plasticPackaging:
            return "#plasticpackaging"
        case .microPlastics:
            return "#microplastics"
        case .fishingGear:
            return "#fishinggear"
        case .seawall:
            return "#seawall"
        case .hardArmoring:
            return "#hardarmoring"
        case .beachfrontConstruction:
            return "#beachfrontconstruction"
        case .jetty:
            return "#jetty"
        case .harbor:
            return "#harbor"
        case .coastalDevelopment:
            return "#coastaldevelopment"
        case .kingTides:
            return "#kingtides"
        case .seaLevelRiseOrFlooding:
            return "#sealevelriseorflooding"
        case .destructiveFishing:
            return "#destructivefishing"
        case .bleaching:
            return "#bleaching"
        case .infrastructure:
            return "#infrastructure"
        case .coralReefImpacts:
            return "#coralreefimpacts"
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
        case .runoff:
            return Style.iconGeneralPlacemark
        case .algalBloom:
            return Style.iconGeneralPlacemark
        case .waterQuality:
            return Style.iconGeneralPlacemark
        case .plasticPackaging:
            return Style.iconGeneralPlacemark
        case .microPlastics:
            return Style.iconGeneralPlacemark
        case .fishingGear:
            return Style.iconGeneralPlacemark
        case .seawall:
            return Style.iconGeneralPlacemark
        case .hardArmoring:
            return Style.iconGeneralPlacemark
        case .beachfrontConstruction:
            return Style.iconGeneralPlacemark
        case .jetty:
            return Style.iconGeneralPlacemark
        case .harbor:
            return Style.iconGeneralPlacemark
        case .coastalDevelopment:
            return Style.iconGeneralPlacemark
        case .kingTides:
            return Style.iconGeneralPlacemark
        case .seaLevelRiseOrFlooding:
            return Style.iconGeneralPlacemark
        case .destructiveFishing:
            return Style.iconGeneralPlacemark
        case .bleaching:
            return Style.iconGeneralPlacemark
        case .infrastructure:
            return Style.iconGeneralPlacemark
        case .coralReefImpacts:
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
        case .competition:
            return Style.iconCompetition
        case .runoff:
            return Style.iconGeneral
        case .algalBloom:
            return Style.iconAlgalBloom
        case .waterQuality:
            return Style.iconWaterQuality
        case .plasticPackaging:
            return Style.iconGeneral
        case .microPlastics:
            return Style.iconGeneral
        case .fishingGear:
            return Style.iconGeneral
        case .seawall:
            return Style.iconGeneral
        case .hardArmoring:
            return Style.iconGeneral
        case .beachfrontConstruction:
            return Style.iconGeneral
        case .jetty:
            return Style.iconGeneral
        case .harbor:
            return Style.iconGeneral
        case .coastalDevelopment:
            return Style.iconCoastalDevelopment
        case .kingTides:
            return Style.iconGeneral
        case .seaLevelRiseOrFlooding:
            return Style.iconSeaLevelRiseOrFlooding
        case .destructiveFishing:
            return Style.iconGeneral
        case .bleaching:
            return Style.iconGeneral
        case .infrastructure:
            return Style.iconGeneral
        case .coralReefImpacts:
            return Style.iconCoralReefImpacts
        }
    }
}

struct Report {
    var name: String
    var address: String
    var coordinate: GeoPoint
    var creationDate: Date
    var description: String
    var imageURLs: [String]
    var type: ReportType
    var user: String

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

extension Report {
    func dateDisplayString() -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        let dateString = formatter.string(from: creationDate)
        return dateString
    }
}
