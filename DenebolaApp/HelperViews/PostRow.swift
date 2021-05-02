//
//  PostRow.swift
//  DenebolaApp
//
//  Created by Alex Siracusa on 5/2/21.
//

import SwiftUI

struct PostRow: View {
    @EnvironmentObject var handler: APIHandler
    let title: String
    let author: String
    let date: String
    let imageURL: String?
    @State var image: Image? = nil
    var post: Post
    
    var body: some View {
        HStack(alignment: .top) {
            //media display
            if let image = image {
                //loaded media
                image
                    .resizable()
                    .scaledToFill()
                    .frame(height: 100)
                    .aspectRatio(1.6, contentMode: .fit)
                    .clipped()
                    .cornerRadius(5)
            } else {
                if post.hasMedia {
                    //loading media
                    Rectangle()
                        .frame(height: 100)
                        .aspectRatio(1.6, contentMode: .fit)
                        .foregroundColor(.gray)
                        .cornerRadius(5)
                } else {
                    //has no media
                    Image("DenebolaLogo")
                        .resizable()
                        .frame(width: 100, height: 100)
                        .cornerRadius(5)
                }
            }
            
            //title + author + date
            NavigationLink( destination:
                PostView(post: post, image: image)
                    .navigationBarTitle(Text(""), displayMode: .inline)
            ) {
                VStack(alignment: .leading, spacing: 3) {
                    //title
                    Text(title)
                        .lineLimit(nil)
                        .font(.title2)
                        .lineLimit(nil)
                    //author
                    HStack {
                        Image(systemName: "person.fill")
                        Text(author).font(.subheadline)
                            .lineLimit(1)
                    }
                    //date
                    HStack {
                        Image(systemName: "calendar")
                        Text(date).font(.subheadline)
                            .lineLimit(1)
                    }
                }
                .foregroundColor(.black)
                Spacer()
            }
        }
        .frame(height:100)
        .padding([.leading, .trailing], 10)
        .onAppear {
            if let url = imageURL {
                handler.loadImage(url) { image, error  in
                    self.image = image
                }
            }
        }
    }
}

struct PostRow_Previews: PreviewProvider {
    static var previews: some View {
        PostRow(title: "Title Here Sample text to make long", author: "Alex Siracusa", date: "April 22, 2021", imageURL: "aa", post: Post.default)
            .environmentObject(APIHandler())
    }
}
