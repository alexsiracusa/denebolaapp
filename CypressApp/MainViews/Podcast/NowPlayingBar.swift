//
//  NowPlayingBar.swift
//  CypressApp
//
//  Created by Alex Siracusa on 6/13/21.
//

import Foundation
import SwiftUI

struct NowPlayingBar: View {
    var content: AnyView
    @EnvironmentObject var player: PlayerObject
    
    var body: some View {
        ZStack(alignment: .bottom) {
            content
                .fullScreenCover(isPresented: $player.toolbarFullScreen) {
                    PodcastEpisodeView()
                        .environmentObject(player)
                        .accentColor(.orange)
                }
            if player.toolbar == .show || player.toolbar == .showFullScreen  {
                ZStack {
                    if let episode = player.episode {
                        Rectangle().foregroundColor(Color.white.opacity(0.95)).frame(width: UIScreen.main.bounds.size.width, height: 55)
                        Toolbar(episode)
                    }
                }
            }
        }
    }
    
    func Toolbar(_ episode: PodcastEpisode) -> some View {
        HStack(alignment: .center, spacing: 0) {
            
            Button {
                player.toolbar = .showFullScreen
            } label: {
                HStack {
                    ImageView(url: episode.imageURL!, aspectRatio: 1.0)
                        .frame(width: 55, height: 55)
                    
                    if let episode = player.episode {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(episode.title)
                                .lineLimit(1)
                                .font(Font.custom("name-of-font", size: 12))
                                .foregroundColor(.black)
                            if let title = episode.from {
                                Text(title)
                                    .lineLimit(1)
                                    .font(Font.custom("name-of-font", size: 12))
                                    .foregroundColor(.secondary)
                            }
                        }
                        .frame(width: 175)
                    }
                    
                    Spacer()
                    
                    Button {
                        if player.playing {
                            player.pause()
                        } else {
                            player.play()
                        }
                    } label: {
                        MediaControlImage(player.playing ? "pause.fill" : "play.fill", size: 30)
                    }
                    .padding(.trailing, 20)
                    
                    Button {
                        player.reset()
                    } label: {
                        MediaControlImage("xmark")
                    }
                    .padding(.trailing, 10)
                    
                }
            }
            .buttonStyle(NoButtonAnimation())
            
        }
        .padding(.trailing, 20)
    }
    
    func MediaControlImage(_ name: String, size: CGFloat = 30) -> some View {
        return Image(systemName: name)
            .font(.system(size: size))
    }
}

struct NowPlayingBar_Previews: PreviewProvider {
    static var previews: some View {
        NowPlayingBar(content: AnyView(SocialView()))
            .environmentObject(PlayerObject())
    }
}


struct Blur: UIViewRepresentable {
    var style: UIBlurEffect.Style = .systemChromeMaterial
    
    func makeUIView(context: Context) -> UIVisualEffectView {
        return UIVisualEffectView(effect: UIBlurEffect(style: style))
    }
    
    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
        uiView.effect = UIBlurEffect(style: style)
    }
}

struct NoButtonAnimation: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
    }
}
