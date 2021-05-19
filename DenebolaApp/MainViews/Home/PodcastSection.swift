//
//  PodcastSection.swift
//  DenebolaApp
//
//  Created by Alex Siracusa on 5/19/21.
//

import SwiftUI

struct PodcastSection: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            HStack(alignment: .bottom) {
                Text("Denebacast")
                    .font(.title3)
                    .bold()
                    .padding([.top, .leading])
                Spacer()
                Text("Show More")
                    .font(.subheadline)
                    .padding([.top, .trailing])
            }
            VStack {
                HStack {
                    Text("Play")
                    Spacer()
                    Text("Podcast #1")
                }
            }
            .padding([.leading, .trailing], 10)
            .padding([.top, .bottom], 15)
            .background(Color.white.ignoresSafeArea().cornerRadius(5))
        }
    }
}

struct PodcastSection_Previews: PreviewProvider {
    static var previews: some View {
        PodcastSection()
    }
}
