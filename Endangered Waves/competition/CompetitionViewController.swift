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

    override func viewDidLoad() {
        super.viewDidLoad()
        assert(competition != nil, "Forgot to set competition dependency")

        // TODO: Remove this!!! After testing
        // TODO: Remove this!!! After testing
        // TODO: Remove this!!! After testing
        clearWebViewCache()
        // TODO: Remove this!!! After testing
        // TODO: Remove this!!! After testing
        // TODO: Remove this!!! After testing

        webView.navigationDelegate = self

        _ = URLSession.shared.downloadTask(with: competition.introPageURL) { (localURL, urlResponse, error) in
            if let localURL = localURL {
                if let htmlString = try? String(contentsOf: localURL) {
                    let bundleURL = URL(fileURLWithPath: Bundle.main.bundlePath)
                    DispatchQueue.main.async {
                        self.webView.loadHTMLString(htmlString, baseURL: bundleURL)
                    }
                }
            }
        }.resume()
    }

    func clearWebViewCache() {
        let websiteDataTypes: Set = [WKWebsiteDataTypeDiskCache, WKWebsiteDataTypeMemoryCache]
        let date = Date(timeIntervalSince1970: 0)
        WKWebsiteDataStore.default().removeData(ofTypes: websiteDataTypes, modifiedSince: date, completionHandler: {})
    }
}

// MARK: WKNavigationDelegate
extension CompetitionViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }

    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction,
                 decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        guard let url = navigationAction.request.url else {
            decisionHandler(.allow)
            return
        }

        // Is it the actual comp URL?
        if url == competition.introPageURL {
            decisionHandler(.allow)
            return
        }

        // Is it the special New Report anchor link?
        if let fragment = url.fragment, fragment == "new_report" {
            decisionHandler(.allow)
            competitionDelegate?.finishedViewingCompetitionViewController(self, andShowNewReport: true)
            return
        }

        // Is it a local file?
        if url.isFileURL {
            decisionHandler(.allow)
            return
        }

        decisionHandler(.cancel)

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
