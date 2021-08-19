//
//  LoadingPodcastDetailView.swift
//  CypressApp
//
//  Created by Alex Siracusa on 7/30/21.
//

import SwiftUI

struct LoadingPodcastDetailView: View {
    var body: some View {
        VStack(spacing: 0) {
            VStack(alignment: .leading, spacing: 0) {
                LoadingPodcastRow()
                    .padding(.bottom)

                VStack(spacing: 12) {
                    ForEach(0 ..< 4) { _ in
                        LoadingRectangle(20)
                            .frame(height: 8)
                    }
                }
            }
            .padding()

            Divider()

            LazyVStack(spacing: 0) {
                ForEach(0 ..< 6) { _ in
                    Spacer()
                        .frame(height: 80)
                    Divider()
                }
            }
            Spacer()
        }
    }
}

struct LoadingPodcastDetailView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingPodcastDetailView()
    }
}
