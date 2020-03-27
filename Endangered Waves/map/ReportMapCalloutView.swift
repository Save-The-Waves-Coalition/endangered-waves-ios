//
//  ReportMapCalloutView.swift
//  Endangered Waves
//
//  Created by Matthew Morey on 11/22/17.
//  Copyright © 2017 Save The Waves. All rights reserved.
//

import UIKit
import SDWebImage

protocol ReportMapCalloutViewDelegate: class {
    func view(_ view: ReportMapCalloutView, didTapDetailsButton button: UIButton?, forReport report: Report)
}

class ReportMapCalloutView: UIView {

    var report: Report! {
          didSet {
              if let reportTypeLabel = reportTypeLabel {
                  reportTypeLabel.text = report.type.displayString().uppercased()
              }

              if let dateLabel = dateLabel {
                  dateLabel.text = report.dateDisplayString()
              }

              if let placemarkImageView = placemarkImageView {
                  placemarkImageView.image = report.type.placemarkIcon()
              }

              if let userImageView = userImageView,
                  let firstImageURLString = report.imageURLs.first,
                  let firstImageURL = URL(string: firstImageURLString) {

                  // TODO: Maybe use storage references instead of URLs for better caching ¯\(°_o)/¯
                  userImageView.sd_setImage(with: firstImageURL, completed: { (image, error, cacheType, url) in
                      if image == nil {
                          return
                      }

                      if cacheType == SDImageCacheType.none {
                          UIView.animate(withDuration: 0.25, animations: {
                              userImageView.alpha = 1.0
                          })
                      } else {
                          userImageView.alpha = 1.0
                      }
                  })

              }
          }
      }

    weak var delegate: ReportMapCalloutViewDelegate?

    @IBOutlet weak var whiteCircleImageView: UIImageView!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var placemarkImageView: UIImageView!
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

        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(userTapped))
        self.addGestureRecognizer(tapGestureRecognizer)
    }

    @objc func userTapped() {
        delegate?.view(self, didTapDetailsButton: nil, forReport: report)
    }

    // MARK: - Hit test. We need to override this to detect hits in our custom callout. Is this really needed ¯\(°_o)/¯
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {

        // Check if it hit our annotation detail view components.

        // details button
        if let result = detailButton.hitTest(convert(point, to: detailButton), with: event) {
            return result
        }

        if let result = placemarkImageView.hitTest(convert(point, to: placemarkImageView), with: event) {
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
