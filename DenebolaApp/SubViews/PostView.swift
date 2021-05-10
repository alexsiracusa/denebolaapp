//
//  PostView.swift
//  WordpressAPI
//
//  Created by Alex Siracusa on 4/19/21.
//

import SwiftUI
import LoaderUI
import WebView

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
            self.image = imageUrl.map {ImageView(url: $0)}
            self.author = post?._embedded?.author?[0].name
            self.error = error

            loaded = true
        }
    }
    
    /// swiftui refuses to give any useful errors if it doesn't compile so just don't make errors
    var body: some View {
        
        
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading) {
                //image
                image
                    .padding(.top)
                    .scaledToFill()
                //title
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
                
                if loaded == false {
                    BallPulse()
                } else {
                    if let error = error {
                        Text(error)
                    }
                }
            }
        }
        .onAppear() {
            load()
        }
        .padding([.leading, .trailing])
        .navigationTitle("\(title ?? "Loading")")
        
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
    @State private var webviewHeight: CGFloat? = nil
    
    var htmlContent: String
    private let timer = Timer.publish(every: 0.5, on: .main, in: .common).autoconnect()
    
    var body: some View {
        WebView(webView: webviewStore.webView)
            // Resize to fit page or start at 500
            .frame(height: webviewHeight ?? 500, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
            // Poll HTML through javascript for page height
            .onReceive(timer, perform: { _ in
                webviewStore.webView.evaluateJavaScript("document.body.offsetHeight", completionHandler: {a, b in
                    webviewHeight = CGFloat(a! as! Int) + 50
                })
            })
            // Load HTML
            .onAppear {
                webviewStore.webView.loadHTMLString(htmlContent, baseURL: URL(string: "https://www.nshsdenebola.com"))
            }
    }
}
