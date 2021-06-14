//
//  PodcastDetailView.swift
//  DenebolaApp
//
//  Created by Alex Siracusa on 5/23/21.
//

import MediaPlayer
import SwiftUI

struct PodcastEpisodeView: View {
    @EnvironmentObject private var viewModel: ViewModelData
    @EnvironmentObject var player: PlayerObject
    
    func MediaControlImage(_ name: String) -> some View {
        return Image(systemName: name)
            .font(.system(size: 30))
    }
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            if let episode = player.episode {
                VStack(spacing: 10) {
                    HStack {
                        Button {
                            player.toolbar = .show
                        } label: {
                            Image(systemName: "chevron.down")
                        }
                        Spacer()
                    }
                    ImageView(url: episode.imageURL!)
                        .scaledToFit()
                        .cornerRadius(10)
                        .aspectRatio(1.0, contentMode: .fit)

                    Slider(value: $player.time, in: 0 ... player.audioLength) { editing in
                        if !editing {
                            player.seek(to: player.time)
                        } else {
                            player.seeking = true
                        }
                    }

                    HStack {
                        Text(getFormattedMinutesSeconds(player.time))
                            .font(.caption)
                        Spacer()
                        Text(getFormattedMinutesSeconds(player.audioLength))
                            .font(.caption)
                    }
                    .padding([.leading, .trailing])

                    HStack(spacing: 30) {
                        Button {
                            player.goForward(seconds: -15)
                        } label: {
                            MediaControlImage("gobackward.15")
                        }

                        Button {
                            if player.playing {
                                player.pause()
                            } else {
                                player.play()
                            }
                        } label: {
                            MediaControlImage(player.playing ? "pause.circle" : "play.circle")
                        }

                        Button {
                            player.goForward(seconds: 15)
                        } label: {
                            MediaControlImage("goforward.15")
                        }
                    }
                    .offset(y: -10)
                    HStack {
                        Text(episode.title)
                            .font(.title3)
                            .bold()
                        Spacer()
                    }
                    .padding(.bottom, 1)
                    HStack {
                        Text(episode.dateString)
                            .foregroundColor(.gray)
                            .font(.footnote)
                        Spacer()
                    }
                    .padding(.bottom)
                    HStack {
                        Text(episode.description)
                        Spacer()
                    }
                }
                .padding(.top)
                .padding(.bottom, 30)
            }
        }
        .padding([.leading, .trailing])
        .background(
            Color.white.ignoresSafeArea()
        )
//        .gesture(
//            DragGesture(minimumDistance: 0, coordinateSpace: .local)
//                .onEnded { value in
//                    if value.translation.height > 0 && value.translation.width < 100 && value.translation.width > -100 {
//                    }
//                }
//        )
    }
    
    let detectDirectionalDrags = DragGesture(minimumDistance: 3.0, coordinateSpace: .local)
    .onEnded { value in
        print(value.translation)
        if value.translation.height > 0 && value.translation.width < 100 && value.translation.width > -100 {
            
        }
    }
    
}

struct PodcastEpisodelView_Previews: PreviewProvider {
    static var previews: some View {
        PodcastEpisodeView()
            .environmentObject(PlayerObject())
    }
}
