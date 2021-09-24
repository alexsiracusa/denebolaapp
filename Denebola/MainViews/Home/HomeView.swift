//
//  HomeView.swift
//  DenebolaApp
//
//  Created by Alex Siracusa on 5/2/21.
//

import PromiseKit
import SwiftUI

struct HomeView: View {
    @EnvironmentObject private var viewModel: ViewModelData

    func onRefresh(_ refreshDone: @escaping () -> Void) {
        var loadingPromises: [Promise<Void>] = []

        loadingPromises += viewModel.siteLoaders.map { $0.refreshNonRemoving().refreshTimeout() }
        loadingPromises += viewModel.podcasts.map {viewModel.loadPodcast($0).refreshTimeout()}

        when(fulfilled: loadingPromises)
            .get { _ in }
            .catch(viewModel.handleError(context: "Refresh failed."))
            .finally {
                refreshDone()
            }
    }

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 0) {
                // sites
                ForEach(viewModel.sites) { site in
                    SiteSection(site: site, loader: viewModel.siteLoaders[viewModel.sites.firstIndex(of: site)!])
                }

                // podcasts
                ForEach(viewModel.podcasts) { podcast in
                    PodcastSection(podcast: podcast)
                }
            }
            .padding(.top, 10)
        }
        .pullToRefresh(viewModel.getRefreshModifier(for: "home", callback: onRefresh))
        .navigationBarTitle("Home", displayMode: .inline)
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .environmentObject(ViewModelData.default)
    }
}
