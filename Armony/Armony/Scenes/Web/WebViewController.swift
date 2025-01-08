//
//  WebViewController.swift
//  Armony
//
//  Created by Koray Yildiz on 30.03.23.
//

import UIKit
import WebKit

final class WebViewController: UIViewController, ViewController, ActivityIndicatorShowing {

    static var storyboardName: UIStoryboard.Name = .web

    @IBOutlet private weak var webView: WKWebView! {
        didSet {
            webView.navigationDelegate = self
        }
    }

    var viewModel: WebViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        webView.backgroundColor = .armonyBlack
        view.backgroundColor = .armonyBlack

        if let url = viewModel.url {
            let request = URLRequest(url: url)
            webView.load(request)
        }
        title = viewModel.title
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        trackScreenView()
    }
}

// MARK: - WKNavigationDelegate
extension WebViewController: WKNavigationDelegate {
    public func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
      view.startActivityIndicatorView()
    }

    public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
      view.stopActivityIndicatorView()
    }
}

final class WebViewModel {

    private(set) var url: URL?
    private(set) var title: String?

    init(urlString: String, title: String) {
        self.url = URL(string: urlString)
        self.title = title
    }
}
