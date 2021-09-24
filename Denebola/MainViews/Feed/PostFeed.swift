//
//  PostFeed.swift
//  DenebolaApp
//
//  Created by Alex Siracusa on 5/2/21.
//

import SwiftUI

struct PostFeed<Loader: PageLoader & Equatable>: View where Loader.Item == Post {
    @EnvironmentObject var viewModel: ViewModelData
    let site: Wordpress
    @ObservedObject var loader: IncrementalLoader<Loader>

    var body: some View {
        if loader.count() > 0 {
            LazyVStack(spacing: 0) {
                ForEach(loader.items) { post in
                    PostRowView(post: post)
                        .onAppear {
                            loader.loadMoreIfNeeded(currentItem: post).catch(viewModel.handleError())
                        }
                }
            }
        } else {
            if let error = loader.lastError {
                VStack(spacing: 10) {
                    Button {
                        loader.loadNextPage().catch(viewModel.handleError())
                    } label: {
                        Text("Reload")
                    }
                    Text(error.localizedDescription)
                }
            }
            VStack(spacing: 0) {
                ForEach(0 ..< 8) { _ in
                    LoadingPostRowView()
                }
            }
            .onAppear {
                if loader.count() == 0 {
                    loader.loadNextPage().catch(viewModel.handleError())
                }
            }
        }
    }
}

struct PostFeed_Previews: PreviewProvider {
    static var previews: some View {
        PostFeed(site: Wordpress.default, loader: IncrementalLoader(WordpressPageLoader(Wordpress.default)))
            .environmentObject(ViewModelData.default)
    }
}
