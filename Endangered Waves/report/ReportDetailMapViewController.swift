//
//  ReportDetailMapViewController.swift
//  Endangered Waves
//
//  Created by Jeffrey Sherin on 2/26/18.
//  Copyright © 2018 Save The Waves. All rights reserved.
//

import UIKit
import MapKit
import Kml_swift

class ReportDetailMapViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    var report: STWDataType!

    override func viewDidLoad() {
        super.viewDidLoad()

        assert(report != nil, "Forgot to set Report dependency")
        updateView()
    }

    func updateView() {
        if let wsrReport = report as? WorldSurfingReserve,
           let kmlURL = wsrReport.kmlURL,
           let url = URL(string: kmlURL) {

            KMLDocument.parse(url: url, callback: { [unowned self] (kml) in
                mapView.addOverlays(kml.overlays)
            })
        }

        self.navigationController?.navigationBar.tintColor = Style.colorSTWBlue

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

        let annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
        let pinImage = UIImage(named: "pin-filled")?.mask(with: .black).scaledToSize(newSize: CGSize(width: 19.0, height: 30.0))
        annotationView.image = pinImage

        return annotationView
    }
}

// MARK: 📖 StoryboardInstantiable
extension ReportDetailMapViewController: StoryboardInstantiable {
    static var storyboardName: String { return "report" }
    static var storyboardIdentifier: String? { return "ReportDetailMapViewController" }
}

// MARK: WSR polygon styling
extension ReportDetailMapViewController {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if let wsrOverlay = overlay as? MKPolygon {
            let renderer = MKPolygonRenderer(overlay: wsrOverlay)
            renderer.alpha = 0.6
            renderer.fillColor = Style.colorSTWBlue

            return renderer
        }

        return MKOverlayRenderer()
    }
}
