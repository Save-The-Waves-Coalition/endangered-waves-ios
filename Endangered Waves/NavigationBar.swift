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
    override func layoutSubviews() {
        super.layoutSubviews()

        if self.frame.origin.y == CGFloat(0) {
            self.frame.origin.y = CGFloat(20)
        }

        for subView in self.subviews {
            if subView.className == "_UIBarBackground" {
                subView.frame.size.height = 64
                subView.frame.origin.y = -20
            }
        }
    }
}
