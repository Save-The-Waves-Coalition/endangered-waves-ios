//
//  NavigationBar.swift
//  Endangered Waves
//
//  Created by Matthew Morey on 11/20/17.
//  Copyright © 2017 Save The Waves. All rights reserved.
//

import UIKit

class NavigationBar: UINavigationBar {

    // Hack to stop the nav bar title from jumping up when hiding the status bar
    // https://stackoverflow.com/a/46352195

    // MDM 2023-01-13 - No longer needed, need to redo all of the status bars do us the island with iOS 14
//    override func layoutSubviews() {
//        super.layoutSubviews()
//
//        if self.frame.origin.y == CGFloat(0) {
//            self.frame.origin.y = CGFloat(20)
//        }
//
//        for subView in self.subviews where subView.className == "_UIBarBackground" {
//            subView.frame.size.height = 64
//            subView.frame.origin.y = -20
//        }
//    }
}
