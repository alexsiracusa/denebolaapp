//
//  LoadingSmallEpisodeRow.swift
//  CypressApp
//
//  Created by Alex Siracusa on 7/30/21.
//

import SwiftUI

struct LoadingSmallEpisodeRow: View {
    var body: some View {
        HStack(alignment: .center, spacing: 0) {
            LoadingRectangle()
                .frame(width: 85, height: 85)
                .cornerRadius(8)
                .padding(15)

            VStack(alignment: .leading, spacing: 5) {
                LoadingRectangle()
                    .frame(height: 10)
                    .cornerRadius(5)
                    .padding(.trailing, 30)
                LoadingRectangle()
                    .frame(height: 10)
                    .cornerRadius(5)
                    .padding(.trailing, 50)

                LoadingRectangle()
                    .frame(width: 80, height: 8)
                    .cornerRadius(5)
                    .padding(.top, 3)

                Spacer(minLength: 0)
            }
            .padding(.top, 18)
            Spacer(minLength: 0)
        }
        .padding(.trailing, 15)
        .frame(height: 100)
    }
}

struct LoadingSmallEpisodeRow_Previews: PreviewProvider {
    static var previews: some View {
        LoadingSmallEpisodeRow()
    }
}
