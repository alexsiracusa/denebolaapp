//
//  Webview.swift
//  DenebolaApp
//
//  Created by Connor Tam on 5/9/21.
//
//  Adapted from https://github.com/kylehickinson/SwiftUI-WebView/blob/main/Sources/WebView/WebView.swift

import Combine
import SwiftUI
import WebKit

@dynamicMemberLookup
public class WebViewStore: ObservableObject {
    @Published public var webView: WKWebView {
        didSet {
            setupObservers()
        }
    }

    public init(webView: WKWebView = WKWebView()) {
        self.webView = webView
        setupObservers()
    }

    private func setupObservers() {
        func subscriber<Value>(for keyPath: KeyPath<WKWebView, Value>) -> NSKeyValueObservation {
            return webView.observe(keyPath, options: [.prior]) { _, change in
                if change.isPrior {
                    self.objectWillChange.send()
                }
            }
        }
        // Setup observers for all KVO compliant properties
        observers = [
            subscriber(for: \.title),
            subscriber(for: \.url),
            subscriber(for: \.isLoading),
            subscriber(for: \.estimatedProgress),
            subscriber(for: \.hasOnlySecureContent),
            subscriber(for: \.serverTrust),
            subscriber(for: \.canGoBack),
            subscriber(for: \.canGoForward),
        ]
    }

    private var observers: [NSKeyValueObservation] = []

    public subscript<T>(dynamicMember keyPath: KeyPath<WKWebView, T>) -> T {
        webView[keyPath: keyPath]
    }
}

/// A container for using a WKWebView in SwiftUI
public struct WebView: View, UIViewRepresentable {
    /// The WKWebView to display
    public let webView: WKWebView
    @Binding var pageViewIdealSize: CGFloat

    public func makeUIView(context: UIViewRepresentableContext<WebView>) -> WKWebView {
        webView.navigationDelegate = context.coordinator
        webView.uiDelegate = context.coordinator

        return webView
    }

    public func updateUIView(_: WKWebView, context _: UIViewRepresentableContext<WebView>) {}

    public func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    public class Coordinator: NSObject, WKNavigationDelegate, WKUIDelegate {
        let parent: WebView
        var timer: Timer?

        init(_ webView: WebView) {
            parent = webView
        }

        private func resizeWindow(_ webView: WKWebView) {
            // View dissapears
            if webView.window == nil {
                timer?.invalidate()
            }
            // Get size of page
            webView.evaluateJavaScript("document.documentElement.scrollHeight", completionHandler: { height, _ in
                self.parent.pageViewIdealSize = height! as! CGFloat
            })
        }

        public func webView(_: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
            // Allow page to be loaded in frame
            guard navigationAction.navigationType == .linkActivated else {
                decisionHandler(.allow)
                return
            }

            // Open in external browser
            UIApplication.shared.open(navigationAction.request.url!)
            decisionHandler(.cancel)
        }

        public func webView(_ webView: WKWebView, didFinish _: WKNavigation!) {
            guard timer == nil else { return }

            // Call once before timer
            resizeWindow(webView)

            timer = Timer.scheduledTimer(withTimeInterval: 0.3, repeats: true) { _ in
                self.resizeWindow(webView)
            }
            // Reduce energy usage
            timer!.tolerance = 0.2
        }
    }
}
