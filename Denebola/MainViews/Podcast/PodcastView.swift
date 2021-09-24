//
//  PodcastView.swift
//  DenebolaApp
//
//  Created by Alex Siracusa on 5/2/21.
//

import MediaPlayer
import PromiseKit
import SwiftUI

struct PodcastView: View {
    @EnvironmentObject var viewModel: ViewModelData

    func onRefresh(_ refreshDone: @escaping () -> Void) {
        when(resolved: viewModel.podcasts.map { viewModel.loadPodcast($0).refreshTimeout() })
            .get { _ in }
            .catch(viewModel.handleError(context: "Refresh failed."))
            .finally(refreshDone)
    }

    var body: some View {
        ScrollView(showsIndicators: false) {
            if viewModel.podcasts.count > 1 {
                // podcasts rows
                VStack(spacing: 0) {
                    ForEach(viewModel.podcasts) { podcast in
                        if let loaded = viewModel.loadedPodcasts[podcast.id] {
                            PodcastRow(podcast: loaded)
                        } else {
                            LoadingPodcastRow()
                                .onAppear {
                                    viewModel.loadPodcast(podcast).done {}.catch { _ in }
                                }
                        }
                    }
                }
                .lineSpacing(5)
                .padding(.vertical, 10)
            } else if viewModel.podcasts.count == 1 {
                // single podcast
                let podcast = viewModel.podcasts[0]
                if let loaded = viewModel.loadedPodcasts[podcast.id] {
                    PodcastDetailView(podcast: loaded)
                } else {
                    LoadingPodcastDetailView()
                        .onAppear {
                            viewModel.loadPodcast(podcast).done {}.catch { _ in }
                        }
                }
            } else {
                Text("Something went wrong, this school has no podcasts")
            }
        }
        .navigationBarTitle("Podcasts", displayMode: .inline)
        .pullToRefresh(viewModel.getRefreshModifier(for: "podcast", callback: onRefresh))
    }
}

struct PodcastView_Previews: PreviewProvider {
    static var previews: some View {
        PodcastView()
            .environmentObject(ViewModelData.default)
            .environmentObject(PlayerObject.default)
    }
}
