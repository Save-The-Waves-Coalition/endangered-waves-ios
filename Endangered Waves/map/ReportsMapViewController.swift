//
//  ReportsMapViewController.swift
//  Endangered Waves
//
//  Created by Matthew Morey on 11/10/17.
//  Copyright © 2017 Save The Waves. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import FirebaseFirestore
import FirebaseUI
import Kml_swift

protocol ReportsMapViewControllerDelegate: class {
    func viewController(_ viewController: ReportsMapViewController, didRequestDetailsForReport report: STWDataType)
}

class ReportsMapViewController: UIViewController {

    weak var delegate: ReportsMapViewControllerDelegate?

    @IBOutlet weak var mapView: MKMapView!

    fileprivate lazy var locationManager = LocationManager()

    fileprivate var didUpdateRegion = false

    fileprivate lazy var batchedArrayForReports: FUIBatchedArray = {
        let query = Firestore.firestore().collection("reports").order(by: "creationDate", descending: true)
        let array = FUIBatchedArray(query: query, delegate: self)
        return array
    }()

    fileprivate lazy var batchedArrayForWSR: FUIBatchedArray = {
        let query = Firestore.firestore().collection("wsr")
        let array = FUIBatchedArray(query: query, delegate: self)
        return array
    }()

    // MARK: View lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configureMap()
        batchedArrayForReports.observeQuery()
        batchedArrayForWSR.observeQuery()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        checkLocationAuthorizationStatus()
    }

    // IBActions

    @IBAction func userLocationButtonWasTapped(_ sender: UIButton) {
        centerMapOnUser()
    }

    // Helpers

    private func checkLocationAuthorizationStatus() {
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            mapView.showsUserLocation = true
        }
    }

    private func configureMap() {
        mapView.delegate = self
        mapView.mapType = .standard
        mapView.showsCompass = false
    }

    private func centerMapOnUser() {
        locationManager.getCurrentLocation { (location: CLLocation) in
            let span = MKCoordinateSpan(latitudeDelta: 0.25, longitudeDelta: 0.25)
            let region = MKCoordinateRegion(center: location.coordinate, span: span)
            self.mapView.setRegion(region, animated: true)
        }
    }
}

// MARK: 🔥 FUIBatchedArrayDelegate
extension ReportsMapViewController: FUIBatchedArrayDelegate {

    func batchedArray(_ array: FUIBatchedArray, willUpdateWith diff: FUISnapshotArrayDiff<DocumentSnapshot>) {
        // Not used but required by the compilier
    }

    func batchedArray(_ array: FUIBatchedArray, didUpdateWith diff: FUISnapshotArrayDiff<DocumentSnapshot>) {
        // Right now just removing all annotations and then adding everything back,
        //  we really should be taking addvantage of the array diff, but so far
        //  not seeing a performance hit

        if array == batchedArrayForWSR {
            // Only remove WSRs before re-adding them
            let currentWSRAnnotations = mapView.annotations.filter { annotation in
                guard let annotation = annotation as? ReportMapAnnotation else {
                    return false
                }

                return annotation.report.type == .wsr
            }
            mapView.removeAnnotations(currentWSRAnnotations)

            // Only remove WSR overlays before re-adding them
            let currentWSROverlays = mapView.overlays.filter { overlay in
                return overlay is KMLOverlayPolygon
            }
            mapView.removeOverlays(currentWSROverlays)

            array.items.forEach { (snapshot) in
                if let wsr = WorldSurfingReserve.createWsrWithSnapshot(snapshot) {
                    let coordinate = CLLocationCoordinate2DMake(wsr.coordinate.latitude, wsr.coordinate.longitude)
                    let annotation = ReportMapAnnotation(coordinate: coordinate, report: wsr)
                    mapView.addAnnotation(annotation)

                    if let kmlURL = wsr.kmlURL,
                       let url = URL(string: kmlURL) {

                        KMLDocument.parse(url: url, callback: { [unowned self] (kml) in
                            self.mapView.addOverlays(kml.overlays)
                        })
                    }
                }
            }
        } else if array == batchedArrayForReports {
            // Only remove reports before re-adding them
            let currentReportAnnotations = mapView.annotations.filter { annotation in
                guard let annotation = annotation as? ReportMapAnnotation else {
                    return false
                }

                return annotation.report.type != .wsr
            }
            mapView.removeAnnotations(currentReportAnnotations)

            array.items.forEach { (snapshot) in
                if let report = Report.createReportWithSnapshot(snapshot) {
                    let coordinate = CLLocationCoordinate2DMake(report.coordinate.latitude, report.coordinate.longitude)
                    let annotation = ReportMapAnnotation(coordinate: coordinate, report: report)
                    mapView.addAnnotation(annotation)
                }
            }
        }
    }

    func batchedArray(_ array: FUIBatchedArray, queryDidFailWithError error: Error) {
        assertionFailure("⚠️: \(error.localizedDescription)")
        // TODO: Log this error to Crashlytics
    }
}

// MARK: 🗺 MKMapViewDelegate
extension ReportsMapViewController: MKMapViewDelegate {

    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        guard !didUpdateRegion else { return }

        let span = MKCoordinateSpan(latitudeDelta: 0.25, longitudeDelta: 0.25)
        let region = MKCoordinateRegion(center: userLocation.coordinate, span: span)

        mapView.setRegion(region, animated: true)

        didUpdateRegion = true
    }

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if let annotation = annotation as? ReportMapAnnotation {
            let identifier = "ReportMapAnnotationViewIdentifier"
            var annotationView: ReportMapAnnotationView
            if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? ReportMapAnnotationView {
                dequeuedView.annotation = annotation
                annotationView = dequeuedView
            } else {
                annotationView = ReportMapAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                annotationView.calloutViewDelegate = self
            }
            return annotationView
        } else {
            return nil
        }
    }

    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {

        if let annotationView = view as? ReportMapAnnotationView {
            let calloutView = annotationView.customCalloutView
            // If custom callout is offscreen recenter map so it is now onscreen
            let mapViewMaxXPostion = mapView.frame.maxX
            let annotationViewXPostion = annotationView.frame.origin.x
            let calloutViewWidth = calloutView!.bounds.size.width
            let deltaX = (annotationViewXPostion + calloutViewWidth) - mapViewMaxXPostion

            if deltaX > 0 {
                var newCenter = mapView.centerCoordinate
                let longitudePerPoint = mapView.region.span.longitudeDelta / Double(mapView.frame.maxX)
                let extraPaddingOnRightSide = 8 * longitudePerPoint
                newCenter.longitude += longitudePerPoint * Double(deltaX) + extraPaddingOnRightSide
                mapView.setCenter(newCenter, animated: true)
            }
        } else {
                return
        }

    }

// Would be cool to animate the pin drops but couldn't quite get this working
// // Animation for the pin drops
//
//    func mapView(_ mapView: MKMapView, didAdd views: [MKAnnotationView]) {
//        var i = -1;
//        for view in views {
//            i += 1;
//
//            // Check if annotation isn't user's location, else go to next one
//            if view.annotation is MKUserLocation {
//                continue;
//            }
//
//            // Check if current annotation is inside visible map rect, else go to next one
//            let point:MKMapPoint = MKMapPointForCoordinate(view.annotation!.coordinate);
//            if (!MKMapRectContainsPoint(self.mapView.visibleMapRect, point)) {
//                continue;
//            }
//
//            let endFrame:CGRect = view.frame;
//
//            // Move annotation out of view
//            view.frame = CGRect(origin: CGPoint(x: view.frame.origin.x,
//    y :view.frame.origin.y-self.view.frame.size.height),
//    size: CGSize(width: view.frame.size.width,
//    height: view.frame.size.height))
//
//            // Animate drop
//            let delay = 0.03 * Double(i)
//            UIView.animate(withDuration: 0.5, delay: delay, options: UIViewAnimationOptions.curveEaseIn, animations:{() in
//                view.frame = endFrame
//                // Animate squash
//            }, completion:{(Bool) in
//                UIView.animate(withDuration: 0.05, delay: 0.0, options: UIViewAnimationOptions.curveEaseInOut, animations:{() in
//                    view.transform = CGAffineTransform(scaleX: 1.0, y: 0.6)
//
//                }, completion: {(Bool) in
//                    UIView.animate(withDuration: 0.3, delay: 0.0, options: UIViewAnimationOptions.curveEaseInOut, animations:{() in
//                        view.transform = CGAffineTransform.identity
//                    }, completion: nil)
//                })
//
//            })
//        }
//    }
}

// MARK: ReportMapCalloutViewDelegate
extension ReportsMapViewController: ReportMapCalloutViewDelegate {
    func view(_ view: ReportMapCalloutView, didTapDetailsButton button: UIButton?, forReport report: STWDataType) {
        delegate?.viewController(self, didRequestDetailsForReport: report)
    }
}

// MARK: 📖 StoryboardInstantiable
extension ReportsMapViewController: StoryboardInstantiable {
    static var storyboardName: String { return "map" }
    static var storyboardIdentifier: String? { return "ReportsMapComponent" }
}

// MARK: WSR polygon styling
extension ReportsMapViewController {
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
