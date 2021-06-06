//
//  PostView.swift
//  WordpressAPI
//
//  Created by Alex Siracusa on 4/19/21.
//

import LoaderUI
import SwiftUI

struct PostView: View {
    @EnvironmentObject var handler: WordpressAPIHandler
    @EnvironmentObject var siteImages: SiteImages
    let post: Post

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading) {
                // image
                if let imageUrl = post.getFeaturedImageUrl() {
                    ImageView(url: imageUrl)
                        .scaledToFill()
                }

                Group {
                    // title
                    Text(post.getTitle())
                        .font(.largeTitle)
                        .bold()
                        .frame(alignment: .leading)
                        .fixedSize(horizontal: false, vertical: true)

                    Text(post.getDate())
                        .fontWeight(.light)
                        .padding(.bottom, 5)

                    ContentRenderer(htmlContent: post.getHtmlContent())
                        .padding(-6)
                }
                .padding(.horizontal)
            }
        }

        .navigationTitle(post.getTitle())
        .navigationBarItems(trailing: LogoButton(url: siteImages.logoURL))
    }
}

struct PostView_Previews: PreviewProvider {
    static var previews: some View {
        PostView(post: Post.default)
            .environmentObject(WordpressAPIHandler())
            .environmentObject(SiteImages())
    }
}

struct ContentRenderer: View {
    @StateObject private var webviewStore = WebViewStore()
    @State private var webviewHeight: CGFloat = 500

    var htmlContent: String?
    var url: URL?

    var body: some View {
        WebView(webView: webviewStore.webView, pageViewIdealSize: $webviewHeight)
            // Resize to fit page or start at 500
            .frame(height: webviewHeight, alignment: .top)
            // Poll HTML through javascript for page height
            .onAppear {
                // Setup webview
                webviewStore.webView.scrollView.isScrollEnabled = false
                webviewStore.webView.scrollView.bounces = false

                if let htmlContent = htmlContent {
                    webviewStore.webView.loadHTMLString(htmlContent, baseURL: URL(string: "https://www.nshsdenebola.com"))
                } else if let url = url {
                    webviewStore.webView.load(URLRequest(url: url))
                }
            }
    }
}
