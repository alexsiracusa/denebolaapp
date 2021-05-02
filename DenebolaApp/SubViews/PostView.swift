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
    
    let id: Int
    @State var loaded = false
    @State var post: Post? = nil
    @State var media: Media? = nil
    @State var image: Image? = nil
    @State var error: String? = nil
    
    @State var content: String? = nil
    
    /// swiftui refuses to give any useful errors if it doesn't compile so just don't make errors
    var body: some View {
        ScrollView {
            if let image = image {
                image
                    .resizable()
                    .scaledToFit()
            }
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
            handler.loadFullPost(id) { post, media, image, error in
                self.loaded = true
                self.post = post
                self.media = media
                self.image = image
                self.error = error
                guard let post = post else {return}
                self.content = post.renderedContent
            }
        }
        .padding([.leading, .trailing])
    }
}

struct PostView_Previews: PreviewProvider {
    static var previews: some View {
        PostView(id: 25094)
            .environmentObject(APIHandler())
    }
}


