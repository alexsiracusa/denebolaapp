//
//  PostView.swift
//  WordpressAPI
//
//  Created by Alex Siracusa on 4/19/21.
//

import SwiftUI
import WebKit

struct PostView: View {
    @EnvironmentObject var handler: APIHandler
    
    var id: Int
    var hasMedia: Bool
    var imageURL: String? = nil
    @State var title: String? = nil
    @State var content: String? = nil
    @State var image: Image? = nil
    @State var author: String? = nil
    
    @State var loaded = false
    @State var error: String? = nil
    
    func load() {
        if image == nil && hasMedia {
            handler.loadPostForDisplay(id, withImage: true) { post, image, error in
                self.content = post?.renderedContent
                self.title = post?.renderedTitle
                self.image = image
                self.author = post?._embedded?.author?[0].name
                loaded = true
            }
        } else {
            handler.loadPostForDisplay(id, withImage: false) { post, image, error in
                self.content = post?.renderedContent
                self.title = post?.renderedTitle
                self.author = post?._embedded?.author?[0].name
                loaded = true
            }
        }
    }
    
    /// swiftui refuses to give any useful errors if it doesn't compile so just don't make errors
    var body: some View {
        ScrollView {
            //image
            if let image = image {
                image
                    .resizable()
                    .scaledToFit()
            } else {
                if hasMedia {
                    Rectangle()
                        .frame(height: 250)
                        .foregroundColor(.gray)
                        .brightness(0.3)
                }
            }
            //title
            if let title = title {
                Text(title).font(.largeTitle).bold()
                    .frame(alignment: .leading)
                    .padding(.bottom, 5)
            }
            
            //content
            if let content = content {
                Text(content)
                    .fixedSize(horizontal: false, vertical: true)
            }
            if loaded == false {
                Text("Loading")
            } else {
                if let error = error {
                    Text(error)
                }
            }
        }
        .onAppear() {
            load()
        }
        .padding([.leading, .trailing, .top])
    }
}

struct PostView_Previews: PreviewProvider {
    static var previews: some View {
        PostView(id: 25182, hasMedia: true)
            .environmentObject(APIHandler())
    }
}


