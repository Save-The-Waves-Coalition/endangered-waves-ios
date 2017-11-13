//
//  ReportMapAnnotation.swift
//  Endangered Waves
//
//  Created by Matthew Morey on 11/12/17.
//  Copyright © 2017 Save The Waves. All rights reserved.
//

import Foundation
import MapKit

class ReportMapAnnotation: NSObject, MKAnnotation {
    var title: String? {
        return report.location?.name
    }
    var subtitle: String? {
        return report.description
    }
    let coordinate: CLLocationCoordinate2D
    let report: Report

    init(coordinate: CLLocationCoordinate2D, report: Report) {
        self.coordinate = coordinate
        self.report = report
        super.init()
    }
}

class ReportMapAnnotationView: MKAnnotationView {
    override var annotation: MKAnnotation? {
        willSet {
            guard let reportMapAnnotation = newValue as?  ReportMapAnnotation else {return}

            if let type = reportMapAnnotation.report.type {
                switch type {
                case .sewage:
                    image = UIImage(named: "sewage")
                case .garbage:
                    image = UIImage(named: "garbage")
                default:
                    image = UIImage(named: "oil")
                }
            }

            canShowCallout = true

            rightCalloutAccessoryView = UIButton(type: .detailDisclosure)

            let detailLabel = UILabel()
            detailLabel.numberOfLines = 0
            detailLabel.font = detailLabel.font.withSize(12)
            detailLabel.text = reportMapAnnotation.subtitle
            detailCalloutAccessoryView = detailLabel
        }
    }
}
