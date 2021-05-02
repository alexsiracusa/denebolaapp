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
    let imageURL: String
    @State var image: Image? = nil
    var post: Post
    
    var body: some View {
        HStack(alignment: .top) {
            if let image = image {
                image
                    .resizable()
                    //.aspectRatio(contentMode: .fit)
                    .frame(height: 100)
                    .aspectRatio(1.6, contentMode: .fit)
                    .frame(height: 100)
            } else {
                Rectangle()
                    .frame(height: 100)
                    .aspectRatio(1.6, contentMode: .fit)
                    .foregroundColor(.gray)
            }
            NavigationLink( destination:
                PostView(post: post)
                    .navigationBarTitle(Text(""), displayMode: .inline)
            ) {
                VStack(alignment: .leading, spacing: 3) {
                    Text(title)
                        .lineLimit(nil)
                        .font(.title2)
                        .lineLimit(nil)
                        //.frame(maxHeight: 75)
                    
                    HStack {
                        Image(systemName: "person.fill")
                        Text(author).font(.subheadline)
                            .lineLimit(1)
                    }
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
            handler.loadImage(imageURL) { image, error  in
                self.image = image
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
