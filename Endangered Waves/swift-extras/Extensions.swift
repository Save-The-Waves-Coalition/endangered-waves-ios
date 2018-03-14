//
//  Extensions.swift
//  Endangered Waves
//
//  Created by Jeffrey Sherin on 3/1/18.
//  Copyright © 2018 Save The Waves. All rights reserved.
//

import UIKit

public extension UIView {

    func pinEdgeAnchorsToView(_ view: UIView, edgeInsets: UIEdgeInsets = UIEdgeInsets.zero) {
        translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: edgeInsets.left),
            trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: edgeInsets.right),
            topAnchor.constraint(equalTo: view.topAnchor, constant: edgeInsets.top),
            bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: edgeInsets.bottom)
            ])
    }
}
