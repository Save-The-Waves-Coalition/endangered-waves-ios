//
//  CompetitionViewController.swift
//  Endangered Waves
//
//  Created by Matthew Morey on 9/6/18.
//  Copyright © 2018 Save The Waves. All rights reserved.
//

import UIKit
import WebKit
import SafariServices

protocol CompetitionViewControllerDelegate: class {
    func finishedViewingCompetitionViewController(_ controller: CompetitionViewController, andShowNewReport: Bool)
}

class CompetitionViewController: UIViewController {
    weak var competitionDelegate: CompetitionViewControllerDelegate?
    var competition: Competition!

    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var offModalView: UIView!

    private var contentLoaded = false

    override func viewDidLoad() {
        super.viewDidLoad()
        assert(competition != nil, "Forgot to set competition dependency")

        offModalView.alpha = 0
        webView.alpha = 0

        webView.navigationDelegate = self

        if let introPageHTML = competition.introPageHTML {
            let bundleURL = URL(fileURLWithPath: Bundle.main.bundlePath)
            webView.loadHTMLString(introPageHTML, baseURL: bundleURL)
        }
    }

    @IBAction func didTap(_ sender: UITapGestureRecognizer) {
        competitionDelegate?.finishedViewingCompetitionViewController(self, andShowNewReport: false)
    }
}

// MARK: WKNavigationDelegate
extension CompetitionViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        if !contentLoaded {
            UIView.animate(withDuration: 0.25, animations: {
                self.offModalView.alpha = 0.35
                self.webView.alpha = 1.0
            }, completion: { (finished) in
                self.contentLoaded = true
            })
        }
    }

    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction,
                 decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        guard let url = navigationAction.request.url else {
            decisionHandler(.cancel)
            return
        }

        // Is it a local file? This implies that it's the comp intro page modal so show it
        if url.isFileURL {
            decisionHandler(.allow)
            return
        }

        // Is it the actual comp URL then show it and return early, this should not be needed anymore but is fine to leave
        if url == competition.introPageURL {
            decisionHandler(.allow)
            return
        }

        // Is it the special New Report link then cancel web navication and show the new report workflow
        if url.lastPathComponent == "new_report" {
            decisionHandler(.cancel)
            competitionDelegate?.finishedViewingCompetitionViewController(self, andShowNewReport: true)
            return
        }

        // If it's anyting else don't show it in the web view
        decisionHandler(.cancel)

        // Instead let SFSafariViewController handle it
        let safariViewController = SFSafariViewController(url: url)
        safariViewController.preferredControlTintColor = Style.colorSTWBlue
        present(safariViewController, animated: true, completion: nil)
    }
}

// MARK: 📖 StoryboardInstantiable
extension CompetitionViewController: StoryboardInstantiable {
    static var storyboardName: String { return "competition" }
    static var storyboardIdentifier: String? { return "CompetitionPageComponent" }
}
