//
//  ReportMapAnnotationView.swift
//  Endangered Waves
//
//  Created by Matthew Morey on 11/25/17.
//  Copyright © 2017 Save The Waves. All rights reserved.
//

import UIKit
import MapKit

// Inspired by https://github.com/DigitalLeaves/YourPersonalWishlist/blob/master/CustomPinsMap/PersonWishListAnnotationView.swift

class ReportMapAnnotationView: MKAnnotationView {

    weak var customCalloutView: ReportMapCalloutView?
    weak var calloutViewDelegate: ReportMapCalloutViewDelegate?

    override var annotation: MKAnnotation? {
        willSet {
            guard (newValue as?  ReportMapAnnotation) != nil else {
                return
            }
            customCalloutView?.removeFromSuperview()
        }
        didSet {
            if let reportMapAnnotation = annotation as? ReportMapAnnotation {
                image = reportMapAnnotation.report.type.placemarkIcon()
                if reportMapAnnotation.report.type == .wsr {
                    image = reportMapAnnotation.report.type.wsrPlacemarkIcon(key: reportMapAnnotation.report.name)
                }
            }
        }
    }

    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        self.canShowCallout = false // Showing custom callout thus turn off default one

        if let reportMapAnnotation = annotation as? ReportMapAnnotation {
            image = reportMapAnnotation.report.type.placemarkIcon()
        }
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.canShowCallout = false // Showing custom callout thus turn off default one
        self.image = Style.iconGeneralPlacemark
    }

    func createCustomCalloutView() -> ReportMapCalloutView? {
        if let views = Bundle.main.loadNibNamed("ReportMapCalloutView", owner: self, options: nil) as? [ReportMapCalloutView],
            let reportAnnotation = annotation as? ReportMapAnnotation,
            views.count > 0 {

            let view = views.first!
            view.report = reportAnnotation.report
            var newFrame = view.frame
            newFrame.size.width = 48
            newFrame.size.height = 48
            view.frame = newFrame
            view.clipsToBounds = true
            view.autoresizesSubviews = false
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

                let horizontalConstraint = NSLayoutConstraint(item: newCustomCalloutView,
                                                              attribute: NSLayoutConstraint.Attribute.left,
                                                              relatedBy: NSLayoutConstraint.Relation.equal,
                                                              toItem: self,
                                                              attribute: NSLayoutConstraint.Attribute.left,
                                                              multiplier: 1,
                                                              constant: 0)
                let verticalConstraint = NSLayoutConstraint(item: newCustomCalloutView,
                                                            attribute: NSLayoutConstraint.Attribute.centerY,
                                                            relatedBy: NSLayoutConstraint.Relation.equal,
                                                            toItem: self,
                                                            attribute: NSLayoutConstraint.Attribute.centerY,
                                                            multiplier: 1,
                                                            constant: 0)
                let widthConstraint = NSLayoutConstraint(item: newCustomCalloutView,
                                                         attribute: NSLayoutConstraint.Attribute.width,
                                                         relatedBy: NSLayoutConstraint.Relation.equal,
                                                         toItem: nil,
                                                         attribute: NSLayoutConstraint.Attribute.notAnAttribute,
                                                         multiplier: 1,
                                                         constant: 210)
                let heightConstraint = NSLayoutConstraint(item: newCustomCalloutView,
                                                          attribute: NSLayoutConstraint.Attribute.height,
                                                          relatedBy: NSLayoutConstraint.Relation.equal,
                                                          toItem: nil,
                                                          attribute: NSLayoutConstraint.Attribute.notAnAttribute,
                                                          multiplier: 1,
                                                          constant: 48)
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
        if let parentHitView = super.hitTest(point, with: event) { return parentHitView } else { // test in our custom callout.
            if customCalloutView != nil {
                return customCalloutView!.hitTest(convert(point, to: customCalloutView!), with: event)
            } else {
                return nil
            }
        }
    }
}
