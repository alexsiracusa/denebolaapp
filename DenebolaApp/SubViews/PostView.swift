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
    
    var id: Int
    @State var title: String? = nil
    @State var content: String? = nil
    @State var image: ImageView? = nil
    @State var author: String? = nil
    
    @State var loaded = false
    @State var error: String? = nil
    
    func load() {
        handler.loadPostForDisplay(id) { post, imageUrl, error in
            self.content = post?.htmlContent
            self.title = post?.renderedTitle
            self.image = imageUrl.map { ImageView(url: $0) }
            self.author = post?._embedded?.author?[0].name
            self.error = error

            loaded = true
        }
    }
    
    /// swiftui refuses to give any useful errors if it doesn't compile so just don't make errors
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading) {
                // image
                image
                    .padding(.top)
                    .scaledToFill()
                // title
                if let title = title {
                    Text(title).font(.largeTitle)
                        .bold()
                        .frame(alignment: .leading)
                        .padding(.bottom, 5)
                        .fixedSize(horizontal: false, vertical: true)
                }
                
                if let content = content {
                    ContentRenderer(htmlContent: content)
                        .padding(-5)
                }
                
                if !loaded {
                    BallPulse()
                } else if let error = error {
                    Text(error)
                }
            }
        }
        .onAppear {
            if !loaded { load() }
        }
        .padding([.leading, .trailing])
        .navigationTitle("\(title ?? "Loading")")
        .navigationBarItems(trailing: ToolbarLogo())
    }
}

struct PostView_Previews: PreviewProvider {
    static var previews: some View {
        PostView(id: 25182)
            .environmentObject(APIHandler())
    }
}

private struct ContentRenderer: View {
    @StateObject private var webviewStore = WebViewStore()
    @State private var webviewHeight: CGFloat = 500
    
    var htmlContent: String
    
    var body: some View {
        WebView(webView: webviewStore.webView, pageViewIdealSize: $webviewHeight)
            // Resize to fit page or start at 500
            .frame(height: webviewHeight, alignment: /*@START_MENU_TOKEN@*/ .center/*@END_MENU_TOKEN@*/)
            // Poll HTML through javascript for page height
            .onAppear {
                // Setup webview
                webviewStore.webView.scrollView.isScrollEnabled = false
                webviewStore.webView.scrollView.bounces = false
                webviewStore.webView.loadHTMLString(htmlContent, baseURL: URL(string: "https://www.nshsdenebola.com"))
            }
    }
}
