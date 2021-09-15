//
//  HomeView.swift
//  DenebolaApp
//
//  Created by Alex Siracusa on 5/2/21.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject private var viewModel: ViewModelData

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 0) {
                // sites
                ForEach(0 ..< viewModel.sites.count) { index in
                    SiteSection(site: viewModel.sites[index], loader: viewModel.siteLoaders[index])
                }

                // podcasts
                ForEach(viewModel.podcasts) { podcast in
                    PodcastSection(podcast: podcast)
                }
            }
            .padding(.top, 10)
        }
        .navigationBarTitle("Home", displayMode: .inline)
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .environmentObject(ViewModelData.default)
    }
}