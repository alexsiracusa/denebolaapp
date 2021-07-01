//
//  DescriptionPage.swift
//  CypressApp
//
//  Created by Connor Tam on 6/20/21.
//

import SwiftUI

struct DescriptionPage: View {
    @EnvironmentObject var player: PlayerObject

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading) {
                let episode = player.episode!

                Text(episode.title)
                    .font(.title2)
                    .foregroundColor(.black)
                    .bold()

                Spacer()
                    .frame(height: 10)

                Text(episode.from.uppercased())
                    .font(.subheadline)
                    .foregroundColor(.black)

                Text("\(episode.dateString) • \(getFormattedMinutesSeconds(player.audioLength))")
                    .foregroundColor(.gray)
                    .font(.footnote)
                    .bold()

                ContentRenderer(htmlContent: generateHtml(body: [episode.description]))

                Spacer()
            }
        }
    }
}

struct DescriptionPage_Previews: PreviewProvider {
    static var previews: some View {
        DescriptionPage()
            .environmentObject(PlayerObject.default)
    }
}
