//
//  PostView.swift
//  WordpressAPI
//
//  Created by Alex Siracusa on 4/19/21.
//

import LoaderUI
import SwiftUI

struct PostView: View {
    @EnvironmentObject var handler: APIHandler
    let post: Post

    /// swiftui refuses to give any useful errors if it doesn't compile so just don't make errors
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading) {
                // image
                if let imageUrl = post.getFeaturedImageUrl() {
                    ImageView(url: imageUrl)
                        .padding(.top)
                        .scaledToFill()
                }
                // title
                Text(post.getTitle()).font(.largeTitle)
                    .bold()
                    .frame(alignment: .leading)
                    .padding(.bottom, 5)
                    .fixedSize(horizontal: false, vertical: true)

                ContentRenderer(htmlContent: post.getHtmlContent())
                    .padding(-5)
            }
        }
        .padding([.leading, .trailing])
        .navigationTitle(post.getTitle())
        .navigationBarItems(trailing: LogoButton())
    }
}

struct PostView_Previews: PreviewProvider {
    static var previews: some View {
        PostView(post: Post.default)
            .environmentObject(APIHandler())
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
