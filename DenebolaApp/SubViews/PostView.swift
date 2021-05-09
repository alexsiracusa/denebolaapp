//
//  PostView.swift
//  WordpressAPI
//
//  Created by Alex Siracusa on 4/19/21.
//

import SwiftUI
import LoaderUI

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
            self.content = post?.renderedContent
            self.title = post?.renderedTitle
            self.image = imageUrl.map {ImageView(url: $0)}
            self.author = post?._embedded?.author?[0].name
            self.error = error
            loaded = true
        }
    }
    
    /// swiftui refuses to give any useful errors if it doesn't compile so just don't make errors
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                //image
                image
                    .scaledToFit()
                    .padding(.top)
                //title
                if let title = title {
                    Text(title).font(.largeTitle)
                        .bold()
                        .frame(alignment: .leading)
                        .padding(.bottom, 5)
                        .fixedSize(horizontal: false, vertical: true)
                }
                
                //content
                if let content = content {
                    Text(content)
                        .fixedSize(horizontal: false, vertical: true)
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


