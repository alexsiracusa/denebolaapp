//
//  SiteSection.swift
//  CypressApp
//
//  Created by Alex Siracusa on 7/30/21.
//

import SwiftUI

struct SiteSection: View {
    @EnvironmentObject private var viewModel: ViewModelData

    let site: Wordpress
    @State var posts: [Post]? = nil

    var body: some View {
        VStack(spacing: 0) {
            VStack(alignment: .leading, spacing: 0) {
                HStack(alignment: .bottom) {
                    Text(site.name)
                        .font(.system(size: 23, weight: .bold, design: .default))
                        .bold()
                        .lineLimit(1)

                    Spacer()

                    NavigationLink(destination:
                        StaticSiteView(site: site)
                    ) {
                        Text(" ")
                            .font(.system(size: 23))
                            + Text("Show More")
                    }
                }
                .padding(.trailing, 15)
                .padding(.vertical, 10)
            }
            .padding(.leading, 15)

            ScrollView(.horizontal, showsIndicators: false) {
                if let posts = posts {
                    HStack(alignment: .top, spacing: 10) {
                        ForEach(posts) { post in
                            PostCard(post: post, defaultImageURL: site.defaultImageURL)
                                .frame(height: 180)
                        }
                    }
                    .padding(.horizontal, 15)
                } else {
                    HStack(alignment: .top, spacing: 10) {
                        ForEach(0 ..< 8) { _ in
                            LoadingPostCard()
                                .frame(height: 180)
                        }
                    }
                    .padding(.horizontal, 15)
                }
            }
            .frame(height: 180)

            Divider()
                .padding(.top, 35)
                .padding(.leading, 15)
        }
        .onAppear {
            site.getPostPage(page: 1, per_page: 8, embed: true).done { posts in
                self.posts = posts
            }.catch { _ in
            }
        }
    }
}

struct SiteSection_Previews: PreviewProvider {
    static var previews: some View {
        SiteSection(site: Wordpress.default)
            .environmentObject(ViewModelData.default)
    }
}
