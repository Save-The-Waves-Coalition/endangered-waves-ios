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

// Inspired by https://github.com/DigitalLeaves/YourPersonalWishlist/blob/master/CustomPinsMap/PersonWishListAnnotationView.swift

class ReportMapAnnotationView: MKAnnotationView {

    weak var customCalloutView: ReportMapCalloutView?
    weak var calloutViewDelegate: ReportMapCalloutViewDelegate?

    override var annotation: MKAnnotation? {
        willSet {
            guard (newValue as?  ReportMapAnnotation) != nil else {return}
            customCalloutView?.removeFromSuperview()
        }
    }

    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        self.canShowCallout = false // Showing custom callout thus turn off default one

        if let reportMapAnnotation = annotation as? ReportMapAnnotation, let type = reportMapAnnotation.report.type {
            switch type {
            case .OilSpill:
                image = Style.iconOilPlacemark
            case .Sewage:
                image = Style.iconSewagePlacemark
            case .Trashed:
                image = Style.iconTrashPlacemark
            case .CoastalErosion:
                image = Style.iconCoastalErosionPlacemark
            case .AccessLost:
                image = Style.iconAccessPlacemark
            case .General:
                image = Style.iconGeneralPlacemark
            }
        }
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.canShowCallout = false // Showing custom callout thus turn off default one
        self.image = Style.iconGeneralPlacemark
    }

    //

    func createCustomCalloutView() -> ReportMapCalloutView? {
        if let views = Bundle.main.loadNibNamed("ReportMapCalloutView", owner: self, options: nil) as? [ReportMapCalloutView], views.count > 0 {
            let view = views.first!
            let reportAnnotation = annotation as! ReportMapAnnotation
            view.report = reportAnnotation.report
            var newFrame = view.frame
            newFrame.size.width = 48
            newFrame.size.height = 48
            view.frame = newFrame
            view.clipsToBounds = true
            view.delegate = self.calloutViewDelegate
            return view
        }
        return nil
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        if selected {
            self.customCalloutView?.removeFromSuperview() // remove old custom callout (if any)

            if let newCustomCalloutView = createCustomCalloutView() {

                self.addSubview(newCustomCalloutView)
                self.customCalloutView = newCustomCalloutView

                newCustomCalloutView.translatesAutoresizingMaskIntoConstraints = false

                let horizontalConstraint = NSLayoutConstraint(item: newCustomCalloutView, attribute: NSLayoutAttribute.left, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.left, multiplier: 1, constant: 5)
                let verticalConstraint = NSLayoutConstraint(item: newCustomCalloutView, attribute: NSLayoutAttribute.centerY, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.centerY, multiplier: 1, constant: 0)
                let widthConstraint = NSLayoutConstraint(item: newCustomCalloutView, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 200)
                let heightConstraint = NSLayoutConstraint(item: newCustomCalloutView, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 48)
                self.addConstraints([horizontalConstraint, verticalConstraint, widthConstraint, heightConstraint])

                if animated {
                    self.customCalloutView!.alpha = 0.0
                    UIView.animate(withDuration: 0.25, animations: {
                        self.customCalloutView!.alpha = 1.0
                        self.layoutIfNeeded()
                    })
                }
            }
        } else {
            if customCalloutView != nil {
                if animated { // fade out animation, then remove it.
                    UIView.animate(withDuration: 0.25, animations: {
                        self.customCalloutView!.alpha = 0.0
                    }, completion: { (success) in
                        self.customCalloutView!.removeFromSuperview()
                    })
                } else {
                    // Or just remove it.
                    self.customCalloutView!.removeFromSuperview()
                }
            }
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        self.customCalloutView?.removeFromSuperview()
    }

    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        // if super passed hit test, return the result
        if let parentHitView = super.hitTest(point, with: event) { return parentHitView }
        else { // test in our custom callout.
            if customCalloutView != nil {
                return customCalloutView!.hitTest(convert(point, to: customCalloutView!), with: event)
            } else {
                return nil
            }
        }
    }
}
