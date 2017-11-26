//
//  ReportsTableViewCell.swift
//  Endangered Waves
//
//  Created by Matthew Morey on 11/6/17.
//  Copyright © 2017 Save The Waves. All rights reserved.
//

import UIKit
//import FirebaseStorage
import SDWebImage

class ReportsTableViewCell: UITableViewCell {

    @IBOutlet weak var reportImageView: UIImageView!
    @IBOutlet weak var locationNameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var typeImageView: UIImageView!
    @IBOutlet weak var typeLabel: UILabel!

    var report:Report! {
        didSet {
            if let reportImageView = reportImageView, let imageURLStrings = report.imageURLs, let firstURLString = imageURLStrings.first, let url = URL(string: firstURLString) {
                reportImageView.sd_setImage(with: url, completed: nil)
            }

            if let typeImageView = typeImageView, let typeLabel = typeLabel, let type = report.type {
                typeImageView.image = type.icon()
                typeLabel.text = type.displayString().uppercased()
            }

            if let locationNameLabel = locationNameLabel, let locationName = report.location?.name {
                locationNameLabel.text = locationName.uppercased()
            }

            if let dateLabel = dateLabel {
                dateLabel.text = report.dateDisplayString()
            }
        }
    }
}
