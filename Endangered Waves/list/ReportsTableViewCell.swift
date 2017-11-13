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
    @IBOutlet weak var descriptionLabel: UILabel!

    var report:Report! {
        didSet {
            let url = URL(string: (report.imageURLs?.first) ?? "https://via.placeholder.com/100x100")
            reportImageView.sd_setImage(with: url, completed: nil)
            descriptionLabel.text = report.description ?? "No Description!"
            locationNameLabel.text = report.location?.name ?? "No Name!"
        }
    }
}
