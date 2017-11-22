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

// INspired by https://github.com/DigitalLeaves/YourPersonalWishlist/blob/master/CustomPinsMap/PersonWishListAnnotationView.swift

class ReportMapAnnotationView: MKAnnotationView {
    override var annotation: MKAnnotation? {
        willSet {
            guard let reportMapAnnotation = newValue as?  ReportMapAnnotation else {return}

            customCalloutView?.removeFromSuperview()

            if let type = reportMapAnnotation.report.type {
                switch type {
                case .OilSpill:
                    image = Style.iconOil
                case .Sewage:
                    image = Style.iconSewage
                case .Trashed:
                    image = Style.iconTrash
                case .CoastalErosion:
                    image = Style.iconCoastalErosion
                case .AccessLost:
                    image = Style.iconAccess
                case .General:
                    image = Style.iconGeneral
                }
            }

            canShowCallout = false // touched

            rightCalloutAccessoryView = UIButton(type: .detailDisclosure)

            let detailLabel = UILabel()
            detailLabel.numberOfLines = 0
            detailLabel.font = detailLabel.font.withSize(12)
            detailLabel.text = reportMapAnnotation.subtitle
            detailCalloutAccessoryView = detailLabel
        }
    }


//    override func draw(_ rect: CGRect) {
//        print("dawing")
//
//        let bezierPath = UIBezierPath(ovalIn: rect)
//        UIColor.white.set()
//        bezierPath.fill()
//
//
//    }

    weak var customCalloutView: UIView?

    func createCustomCalloutView() -> UIView? {

        if let views = Bundle.main.loadNibNamed("ReportMapCalloutView", owner: self, options: nil) as? [UIView], views.count > 0 {
            let view = views.first! as! ReportMapCalloutView
            var newFrame = view.frame
            newFrame.size.width = 50
            view.frame = newFrame
            view.clipsToBounds = true
//            view.translatesAutoresizingMaskIntoConstraints = true
//            view.center = CGPoint(x: view.bounds.midX, y: view.bounds.midY)
//            view.autoresizingMask = [UIViewAutoresizing.flexibleRightMargin, UIViewAutoresizing.flexibleTopMargin, UIViewAutoresizing.flexibleBottomMargin]

            return view
        }

        return nil

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        if selected {
            self.customCalloutView?.removeFromSuperview() // remove old custom callout (if any)

            if let newCustomCalloutView = createCustomCalloutView() {
                // fix location from top-left to its right place.
//                newCustomCalloutView.frame.origin.x -= newCustomCalloutView.frame.width / 2.0 - (self.frame.width / 2.0)
//                newCustomCalloutView.frame.origin.y -= newCustomCalloutView.frame.height



                // set custom callout view
                self.addSubview(newCustomCalloutView)
                self.customCalloutView = newCustomCalloutView



                newCustomCalloutView.translatesAutoresizingMaskIntoConstraints = false
                let horizontalConstraint = NSLayoutConstraint(item: newCustomCalloutView, attribute: NSLayoutAttribute.left, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.left, multiplier: 1, constant: 0)
                let verticalConstraint = NSLayoutConstraint(item: newCustomCalloutView, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.top, multiplier: 1, constant: 0)
                let widthConstraint = NSLayoutConstraint(item: newCustomCalloutView, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 50)
                let heightConstraint = NSLayoutConstraint(item: newCustomCalloutView, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 50)
                self.addConstraints([horizontalConstraint, verticalConstraint, widthConstraint, heightConstraint])





                // animate presentation
                if animated {
//                    self.customCalloutView!.alpha = 0.0

                    widthConstraint.constant = 200
//                    verticalConstraint.constant = 300
                    UIView.animate(withDuration: 1, animations: {
//                        self.customCalloutView!.alpha = 1.0
                        self.layoutIfNeeded()

                    })
                }
            }
        } else {
            if customCalloutView != nil {
                if animated { // fade out animation, then remove it.
                    UIView.animate(withDuration: 1, animations: {
                        self.customCalloutView!.alpha = 0.0
                    }, completion: { (success) in
                        self.customCalloutView!.removeFromSuperview()
                    })
                } else { self.customCalloutView!.removeFromSuperview() } // just remove it.
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
            } else { return nil }
        }
    }

    

}
