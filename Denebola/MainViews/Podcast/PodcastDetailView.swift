//
//  PodcastDetailView.swift
//  CypressApp
//
//  Created by Alex Siracusa on 6/11/21.
//

import SwiftUI

struct PodcastDetailView: View {
    @EnvironmentObject var viewModel: ViewModelData

    let podcast: LoadedPodcast

    func onRefresh(_ doneRefresh: @escaping () -> Void) {
        viewModel.loadPodcast(viewModel.podcasts.first(where: { $0.id == podcast.id })!)
            .refreshTimeout()
            .ensure(doneRefresh)
            .catch(viewModel.handleError(context: "Podcast refresh failed"))
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                VStack(alignment: .leading, spacing: 0) {
                    HStack(alignment: .top) {
                        ImageView(url: podcast.titleImageURL!)
                            .frame(width: 100, height: 100)
                            .cornerRadius(10)
                        Text(podcast.title)
                            .font(.headline)
                            .foregroundColor(.black)
                        Spacer(minLength: 0)
                    }
                    .padding(.bottom)

                    LongText(podcast.description, lineLimit: 4)
                }
                .padding()

                Divider()

                LazyVStack(spacing: 0) {
                    ForEach(podcast.episodes) { podcast in
                        EpisodeRow(episode: podcast)
                    }
                }
            }
        }.pullToRefresh(viewModel.getRefreshModifier(for: "podcastDetail", callback: onRefresh))
    }
}

struct PodcastDetailView_Previews: PreviewProvider {
    static var previews: some View {
        PodcastDetailView(podcast: LoadedPodcast.default)
            .environmentObject(PlayerObject.default)
            .environmentObject(ViewModelData.default)
    }
}
