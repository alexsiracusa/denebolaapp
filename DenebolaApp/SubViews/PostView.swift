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
    
    var id: Int {
        return post.id
    }
    @State var loaded = false
    @State var post: Post
    @State var media: Media? = nil
    @State var image: Image? = nil
    @State var error: String? = nil
    
    @State var content: String? = nil
    
    /// swiftui refuses to give any useful errors if it doesn't compile so just don't make errors
    var body: some View {
        ScrollView {
            //image
            if let image = image {
                image
                    .resizable()
                    .scaledToFit()
            } else {
                if post.hasMedia {
                    Rectangle()
                        .frame(height: 250)
                        .foregroundColor(.gray)
                }
            }
            //title
            Text(post.title.rendered).font(.largeTitle).bold()
                .frame(alignment: .leading)
                .padding(.bottom, 5)
            
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
            self.content = self.post.renderedContent
            handler.loadFullPost(id, embed: true) { post, media, image, error in
                self.loaded = true
                self.media = media
                self.image = image
                self.error = error
                guard let post = post else {return}
                self.content = post.renderedContent
            }
        }
        .padding([.leading, .trailing, .top])
    }
}

struct PostView_Previews: PreviewProvider {
    static var previews: some View {
        PostView(post: Post.default)
            .environmentObject(APIHandler())
    }
}


