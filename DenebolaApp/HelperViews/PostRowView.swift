//
//  PostRow.swift
//  DenebolaApp
//
//  Created by Alex Siracusa on 5/2/21.
//

import SwiftUI
import FetchImage

struct PostRowView: View {
    let postRow: PostRow
    var title: String {
        return postRow.title
    }
    var author: String {
        return postRow.author
    }
    var date: String {
        return postRow.date
    }
    var imageURL: URL? {
        return postRow.imageURL != nil ? URL(string: postRow.imageURL!) : nil
    }
    
    @StateObject private var image = FetchImage()
    
    var body: some View {
        HStack(alignment: .top) {
            //media display
            if let image = image.view {
                //loaded media
                image
                    .resizable()
                    .scaledToFill()
                    .frame(height: 100)
                    .aspectRatio(1.6, contentMode: .fit)
                    .clipped()
                    .cornerRadius(5)
            } else {
                if postRow.hasMedia {
                    //loading media
                    Rectangle()
                        .frame(height: 100)
                        .aspectRatio(1.6, contentMode: .fit)
                        .foregroundColor(.gray)
                        .brightness(0.3)
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
                                PostView(id: postRow.id, hasMedia: postRow.hasMedia, imageURL: postRow.imageURL, title: postRow.title, author: postRow.author)
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
                image.load(url)
            }
        }
        .onDisappear {
            image.reset()
        }
    }
}

struct PostRowView_Previews: PreviewProvider {
    static var previews: some View {
        PostRowView(postRow: PostRow(id: 1, title: "Title here long text multi line text very cool", author: "Alex Siracusa", date: "April 22, 2021", imageURL: nil, hasMedia: false))
            .environmentObject(APIHandler())
    }
}
