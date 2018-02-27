//
//  ReportDetailMapViewController.swift
//  Endangered Waves
//
//  Created by Jeffrey Sherin on 2/26/18.
//  Copyright © 2018 Save The Waves. All rights reserved.
//

import UIKit
import MapKit

class ReportDetailMapViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    var report: Report!

    override func viewDidLoad() {
        super.viewDidLoad()

        assert(report != nil, "Forgot to set Report dependency")
        updateView()
    }

    func updateView() {
        title = report.name

        let coordinate = CLLocationCoordinate2DMake(report.coordinate.latitude, report.coordinate.longitude)

        let span = MKCoordinateSpan(latitudeDelta: 0.25, longitudeDelta: 0.25)
        let region = MKCoordinateRegion(center: coordinate, span: span)

        mapView.setRegion(region, animated: true)
        mapView.delegate = self

        let annotation = ReportMapAnnotation(coordinate: coordinate, report: report)
        mapView.addAnnotation(annotation)
    }

}

// MARK: 🗺 MKMapViewDelegate
extension ReportDetailMapViewController: MKMapViewDelegate {

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let annotation = annotation as? ReportMapAnnotation else { return nil }

        let identifier = "ReportMapAnnotationViewIdentifier"
        let annotationView = ReportMapAnnotationView(annotation: annotation, reuseIdentifier: identifier)

        return annotationView
    }

}

// MARK: 📖 StoryboardInstantiable
extension ReportDetailMapViewController: StoryboardInstantiable {
    static var storyboardName: String { return "report" }
    static var storyboardIdentifier: String? { return "ReportDetailMapViewController" }
}
