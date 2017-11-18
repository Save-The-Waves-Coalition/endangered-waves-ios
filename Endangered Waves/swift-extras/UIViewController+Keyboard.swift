//
//  UIViewController+Keyboard.swift
//  Endangered Waves
//
//  Created by Matthew Morey on 11/17/17.
//  Copyright © 2017 Save The Waves. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func startAvoidingKeyboard() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(_onKeyboardFrameWillChangeNotificationReceived(_:)),
                                               name: NSNotification.Name.UIKeyboardWillChangeFrame,
                                               object: nil)
    }
    
    func stopAvoidingKeyboard() {
        NotificationCenter.default.removeObserver(self,
                                                  name: NSNotification.Name.UIKeyboardWillChangeFrame,
                                                  object: nil)
    }
    
    @objc private func _onKeyboardFrameWillChangeNotificationReceived(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
            let keyboardFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
                return
        }
        
        let keyboardFrameInView = view.convert(keyboardFrame, from: nil)
        let safeAreaFrame = view.safeAreaLayoutGuide.layoutFrame.insetBy(dx: 0, dy: -additionalSafeAreaInsets.bottom)
        let intersection = safeAreaFrame.intersection(keyboardFrameInView)
        
        let animationDuration: TimeInterval = (notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
        let animationCurveRawNSN = notification.userInfo?[UIKeyboardAnimationCurveUserInfoKey] as? NSNumber
        let animationCurveRaw = animationCurveRawNSN?.uintValue ?? UIViewAnimationOptions.curveEaseInOut.rawValue
        let animationCurve = UIViewAnimationOptions(rawValue: animationCurveRaw)
        
        UIView.animate(withDuration: animationDuration, delay: 0, options: animationCurve, animations: {
            self.additionalSafeAreaInsets.bottom = intersection.height
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
}
