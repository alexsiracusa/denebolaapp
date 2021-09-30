//
//  SiteSection.swift
//  CypressApp
//
//  Created by Alex Siracusa on 7/30/21.
//

import SwiftUI

struct SiteSection: View {
    let site: Wordpress
    @EnvironmentObject var viewModel: ViewModelData
    @ObservedObject var loader: IncrementalLoader<WordpressPageLoader>

    func loadPosts() {
        if loader.pagesLoadedCount() == 0 {
            loader.loadNextPage().catch(viewModel.handleError())
        }
    }

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
                        StaticSiteView(site: site, loader: loader)
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
                if loader.count() > 0 {
                    HStack(alignment: .top, spacing: 10) {
                        ForEach(loader.prefix(8)) { post in
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
        .onChange(of: loader.items) { _ in loadPosts() }
        .onAppear(perform: loadPosts)
    }
}

struct SiteSection_Previews: PreviewProvider {
    static var previews: some View {
        SiteSection(site: Wordpress.default, loader: IncrementalLoader(WordpressPageLoader(Wordpress.default)))
            .environmentObject(ViewModelData.default)
    }
}
