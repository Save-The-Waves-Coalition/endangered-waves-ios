//
//  ReportsTableViewCell.swift
//  Endangered Waves
//
//  Created by Matthew Morey on 11/6/17.
//  Copyright © 2017 Save The Waves. All rights reserved.
//

import UIKit
import SDWebImage

protocol ReportsTableViewCellProtocol: class {
    func didTapImage(cell: UITableViewCell)
}

class ReportsTableViewCell: UITableViewCell {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var locationNameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var typeImageView: UIImageView!
    @IBOutlet weak var typeLabel: UILabel!

    weak var delegate: ReportsTableViewCellProtocol?
    let imageSliderViewController = ImageSliderViewController.instantiate()

    lazy var imageDownloadManager = ImageDownloadManager()

    override func prepareForReuse() {
        // need to 'hide' this so the images reset during recycling
        imageSliderViewController.view.alpha = 0.0
    }

    override func awakeFromNib() {
        super.awakeFromNib()

        imageSliderViewController.imageSliderViewControllerDelegate = self
        containerView.addSubview(imageSliderViewController.view)
        imageSliderViewController.view.pinEdgeAnchorsToView(containerView)
    }

    var report: Report! {
        didSet {

            if let typeImageView = typeImageView, let typeLabel = typeLabel {
                typeImageView.image = report.type.placemarkIcon()
                typeLabel.text = report.type.displayString().uppercased()
            }

            if let locationNameLabel = locationNameLabel {
                locationNameLabel.text = report.name.uppercased()
            }

            if let dateLabel = dateLabel {
                dateLabel.text = report.dateDisplayString()
            }
        }
    }
}

extension ReportsTableViewCell: ImageSliderViewControllerDelegate {

    func viewController(_ viewController: ImageSliderViewController, didTapImage image: UIImage, atIndex index: Int) {
        delegate?.didTapImage(cell: self)
    }

}
