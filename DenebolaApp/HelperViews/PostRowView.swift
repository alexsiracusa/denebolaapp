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
        return postRow.imageURL?.asURL
    }
    
    var image: ImageView? {
        imageURL.flatMap {ImageView(url: $0)}
    }
    
    var body: some View {
        HStack(alignment: .top) {
            if postRow.hasMedia {
                image?
                    .scaledToFill()
                    .frame(width: 160, height: 100)
                    .aspectRatio(1.6, contentMode: .fit)
                    .clipped()
                    .cornerRadius(5)
            } else {
                Image("DenebolaLogo")
                    .resizable()
                    .frame(width: 100, height: 100)
                    .cornerRadius(5)
            }
            
            //title + author + date
            NavigationLink( destination:
                PostView(id: postRow.id, title: postRow.title, image: image, author: postRow.author)
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
    }
}

struct PostRowView_Previews: PreviewProvider {
    static var previews: some View {
        PostRowView(postRow: PostRow(id: 1, title: "Title here long text multi line text very cool", author: "Alex Siracusa", date: "April 22, 2021", imageURL: "http://nshsdenebola.com/wp-content/uploads/2021/02/https___cdn.cnn_.com_cnnnext_dam_assets_210121163502-joe-biden.jpg", hasMedia: true))
            .environmentObject(APIHandler())
    }
}
