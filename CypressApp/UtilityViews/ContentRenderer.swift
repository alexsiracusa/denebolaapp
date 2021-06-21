//
//  ContentRenderer.swift
//  CypressApp
//
//  Created by Connor Tam on 6/17/21.
//

import SwiftUI

struct ContentRenderer: View {
    @StateObject private var webviewStore = WebViewStore()
    @State private var webviewHeight: CGFloat = 500

    var htmlContent: String? = nil
    var baseURL: URL? = nil
    var url: URL? = nil

    var body: some View {
        WebView(webView: webviewStore.webView, pageViewIdealSize: $webviewHeight)
            // Resize to fit page or start at 500
            .frame(height: webviewHeight)
            // Poll HTML through javascript for page height
            .onAppear {
                // Setup webview
                webviewStore.webView.scrollView.isScrollEnabled = false
                webviewStore.webView.scrollView.bounces = false

                if let htmlContent = htmlContent {
                    webviewStore.webView.loadHTMLString(htmlContent, baseURL: baseURL)
                } else if let url = url {
                    webviewStore.webView.load(URLRequest(url: url))
                }
            }
    }
}

struct ContentRenderer_Previews: PreviewProvider {
    static var previews: some View {
        ContentRenderer(url: try! "https://www.google.com".asURL())
    }
}
