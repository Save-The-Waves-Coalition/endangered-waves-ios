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
import FirebaseFirestoreUI

protocol ReportsMapViewControllerDelegate: class {
    func viewController(_ viewController: ReportsMapViewController, didRequestDetailsForReport report: Report)
}

class ReportsMapViewController: UIViewController {

    weak var delegate: ReportsMapViewControllerDelegate?

    @IBOutlet weak var mapView: MKMapView!

    fileprivate lazy var locationManager = LocationManager()

    fileprivate var didUpdateRegion = false

    fileprivate lazy var batchedArray: FUIBatchedArray = {
        let query = Firestore.firestore().collection("reports").order(by: "creationDate", descending: true)
        let array = FUIBatchedArray(query: query, delegate: self)
        return array
    }()

    // View lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configureMap()
        batchedArray.observeQuery()
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

    private func viewController(for annotation: ReportMapAnnotation) -> ReportDetailViewController {
        // TODO: Coordinator should take care of this
        let vc = ReportDetailViewController.instantiate()
        vc.report = annotation.report
        return vc
    }
}

// MARK: 🔥 FUIBatchedArrayDelegate
extension ReportsMapViewController: FUIBatchedArrayDelegate {

    func batchedArray(_ array: FUIBatchedArray, didUpdateWith diff: FUISnapshotArrayDiff<DocumentSnapshot>) {
        // TODO: Right now just removing all annotations and then adding everything back, we really should be taking addvantage of the array diff
        // print("ℹ️: Firestore udpated: \(diff)")

        let annotations = mapView.annotations
        mapView.removeAnnotations(annotations)

        array.items.forEach { (snapshot) in
            if let report = Report.createReportWithSnapshot(snapshot) {
                let coordinate = CLLocationCoordinate2DMake(report.coordinate.latitude, report.coordinate.longitude)
                let annotation = ReportMapAnnotation(coordinate: coordinate, report: report)
                mapView.addAnnotation(annotation)
            }
        }
    }

    func batchedArray(_ array: FUIBatchedArray, queryDidFailWithError error: Error) {
        assertionFailure("⚠️: \(error.localizedDescription)")
        // TODO: Log this error
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
        guard let annotation = annotation as? ReportMapAnnotation else { return nil }

        let identifier = "ReportMapAnnotationViewIdentifier"
        var annotationView: ReportMapAnnotationView

        if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? ReportMapAnnotationView {
            dequeuedView.annotation = annotation
            annotationView = dequeuedView
        } else {
            annotationView = ReportMapAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView.calloutViewDelegate = self
            registerForPreviewing(with: self, sourceView: annotationView)
        }

        return annotationView
    }

    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {

        guard let annotationView = view as? ReportMapAnnotationView,
            let calloutView = annotationView.customCalloutView,
            let annotation = annotationView.annotation else {
                return
        }

        // If custom callout is offscreen recenter map so it is now onscreen
        let mapViewMaxXPostion = mapView.frame.maxX
        let annotationViewXPostion = annotationView.frame.origin.x
        let calloutViewWidth = calloutView.bounds.size.width
        let deltaX = (annotationViewXPostion + calloutViewWidth) - mapViewMaxXPostion

        if deltaX > 0 {
            var newCenter = mapView.centerCoordinate
            newCenter.longitude = annotation.coordinate.longitude
            mapView.setCenter(newCenter, animated: true)
        }
    }

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
    func view(_ view: ReportMapCalloutView, didTapDetailsButton button: UIButton?, forReport report: Report) {
        delegate?.viewController(self, didRequestDetailsForReport: report)
    }
}

// MARK: 🎑 UIViewControllerPreviewingDelegate
extension ReportsMapViewController: UIViewControllerPreviewingDelegate {

    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        guard let annotationView = previewingContext.sourceView as? ReportMapAnnotationView,
            let annotation = annotationView.annotation as? ReportMapAnnotation else { return nil}

        if let popoverFrame = rectForAnnotationViewWithPopover(view: annotationView) {
            previewingContext.sourceRect = popoverFrame
        }

        let vc = viewController(for: annotation)
        return vc
    }

    /*
     If the annotation view has a popover, we need to get the rect
     of the popover *and* the annotation view for the sourceRect.
     You could also not add the annotation view height, if you
     would just like the popover to not blur.
     */
    func rectForAnnotationViewWithPopover(view: MKAnnotationView) -> CGRect? {

        var popover: UIView?

        for view in view.subviews {
            for view in view.subviews {
                for view in view.subviews {
                    popover = view
                }
            }
        }

        if let popover = popover, let frame = popover.superview?.convert(popover.frame, to: view) {
            return CGRect(
                x: frame.origin.x,
                y: frame.origin.y,
                width: frame.width,
                height: frame.height + view.frame.height
            )
        }

        return nil
    }

    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        // TODO: Coordinator should take care of this
        navigationController?.pushViewController(viewControllerToCommit, animated: true)
    }
}

// MARK: 📖 StoryboardInstantiable
extension ReportsMapViewController: StoryboardInstantiable {
    static var storyboardName: String { return "map" }
    static var storyboardIdentifier: String? { return "ReportsMapComponent" }
}
