//
//  WebViewController.swift
//  FakeNFT
//
//  Created by Вадим on 20.10.2024.
//

import UIKit
import WebKit

final class WebViewController: UIViewController {

    // MARK: - Private Properties

    private let urlString: String

    // MARK: - Initializers

    init(urlString: String) {
        self.urlString = urlString
        super.init(nibName: nil, bundle: nil)
        view.backgroundColor = .background
        setupWebView()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Private Methods

    private func setupWebView() {
        let webView = WKWebView()
        view.addSubview(webView)
        webView.translatesAutoresizingMaskIntoConstraints = false
        view.setupConstraints(webView)
        if let url = URL(string: urlString) {
            let request = URLRequest(url: url)
            webView.load(request)
        }
    }
}

// MARK: - Setup

extension UIView {
    func setupConstraints(_ webView: WKWebView) {
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            webView.leadingAnchor.constraint(equalTo: leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: trailingAnchor),
            webView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
