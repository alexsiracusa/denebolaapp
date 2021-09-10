//
//  LoadingPodcastRow.swift
//  CypressApp
//
//  Created by Alex Siracusa on 7/30/21.
//

import SwiftUI

struct LoadingPodcastRow: View {
    var body: some View {
        HStack(alignment: .top) {
            LoadingRectangle(10)
                .frame(width: 100, height: 100)
            VStack(alignment: .leading, spacing: 12) {
                LoadingRectangle(20)
                    .frame(width: 200, height: 10)
                LoadingRectangle(20)
                    .frame(width: 100, height: 10)
            }
            .padding(.top, 8)
            Spacer(minLength: 0)
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 5)
    }
}

struct LoadingPodcastRow_Previews: PreviewProvider {
    static var previews: some View {
        LoadingPodcastRow()
    }
}
