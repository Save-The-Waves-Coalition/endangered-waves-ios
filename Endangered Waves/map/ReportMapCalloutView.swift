//
//  ReportMapCalloutView.swift
//  Endangered Waves
//
//  Created by Matthew Morey on 11/22/17.
//  Copyright © 2017 Save The Waves. All rights reserved.
//

import UIKit

protocol ReportMapCalloutViewDelegate: class {
    func view(_ view:ReportMapCalloutView, didTapDetailsButton button:UIButton, forReport report:Report)
}

class ReportMapCalloutView: UIView {

    var report: Report!

    weak var delegate: ReportMapCalloutViewDelegate?

    @IBOutlet weak var whiteCircleImageView: UIImageView!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var placemarkView: UIImageView!
    @IBOutlet weak var detailButton: UIButton!
    @IBOutlet weak var reportTypeLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var userImageView: UIImageView!

    @IBAction func userDidTapDetailsButton(_ sender: UIButton) {
        delegate?.view(self, didTapDetailsButton: sender, forReport: report)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        userImageView.layer.cornerRadius = userImageView.bounds.size.width / 2
        userImageView.layer.masksToBounds = true
    }

    // MARK: - Hit test. We need to override this to detect hits in our custom callout.
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {

        // Check if it hit our annotation detail view components.

        // details button
        if let result = detailButton.hitTest(convert(point, to: detailButton), with: event) {
            return result
        }

        if let result = placemarkView.hitTest(convert(point, to: placemarkView), with: event) {
            return result
        }

        if let result = mainView.hitTest(convert(point, to: mainView), with: event) {
            return result
        }

        if let result = stackView.hitTest(convert(point, to: stackView), with: event) {
            return result
        }

        if let result = reportTypeLabel.hitTest(convert(point, to: reportTypeLabel), with: event) {
            return result
        }

        if let result = dateLabel.hitTest(convert(point, to: dateLabel), with: event) {
            return result
        }

        if let result = whiteCircleImageView.hitTest(convert(point, to: whiteCircleImageView), with: event) {
            return result
        }

        if let result = userImageView.hitTest(convert(point, to: userImageView), with: event) {
            return result
        }

        return nil
    }
}
