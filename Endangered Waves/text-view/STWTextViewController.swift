//
//  STWTextViewController.swift
//  Endangered Waves
//
//  Created by Matthew Morey on 11/17/17.
//  Copyright © 2017 Save The Waves. All rights reserved.
//

import UIKit

class STWTextViewController: UIViewController {
    
    open var textViewDidEndEditing: ((String) -> Void)?
    
    var text: String? {
        didSet {
            if let textView = textView, let text = text {
                textView.text = text
            }
        }
    }

    @IBOutlet weak var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startAvoidingKeyboard()
        textView.becomeFirstResponder()
        textView.delegate = self
        if let text = text {
            textView.text = text
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        stopAvoidingKeyboard()
    }
}

extension STWTextViewController: UITextViewDelegate {
    func textViewDidEndEditing(_ textView: UITextView) {
        textViewDidEndEditing?(textView.text)
    }
}

extension STWTextViewController: StoryboardInstantiable {
    static var storyboardName: String { return "STWTextView" }
    static var storyboardIdentifier: String? { return "TextViewComponent" }
}
