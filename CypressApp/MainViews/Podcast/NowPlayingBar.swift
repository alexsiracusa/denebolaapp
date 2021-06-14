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
    @Binding var showingBar: Bool
    @EnvironmentObject var player: PlayerObject
    @State var fullScreen = false
    
    var body: some View {
        ZStack(alignment: .bottom) {
            content
            if showingBar {
                ZStack {
                    if let episode = player.episode {
                        Rectangle().foregroundColor(Color.white.opacity(0.0)).frame(width: UIScreen.main.bounds.size.width, height: 65).background(Color.white)
                            .shadow(radius: 5)
                        Toolbar(episode)
                    }
                }
                .fullScreenCover(isPresented: $fullScreen) {
                    PodcastEpisodeView(showFullScreen: $fullScreen)
                        .environmentObject(player)
                        .accentColor(.orange)
                }
            }
        }
    }
    
    func Toolbar(_ episode: PodcastEpisode) -> some View {
        HStack(alignment: .center, spacing: 0) {
            
            Button {
                player.reset()
            } label: {
                MediaControlImage("xmark.circle")
            }
            
            Spacer()
            
            Button {
                player.goForward(seconds: -15)
            } label: {
                MediaControlImage("gobackward.15")
            }
            
            Spacer()
            
            Button {
                if player.playing {
                    player.pause()
                } else {
                    player.play()
                }
            } label: {
                MediaControlImage(player.playing ? "pause.fill" : "play.fill", size: 40)
            }
            
            Spacer()
            
            Button {
                player.goForward(seconds: 15)
            } label: {
                MediaControlImage("goforward.15")
            }
            
            Spacer()
            Button {
                fullScreen = true
            } label: {
                ImageView(url: episode.imageURL!, aspectRatio: 1.0)
                    .frame(width: 50, height: 50)
                    .cornerRadius(5)
            }
        }
        .padding([.leading, .trailing], 20)
    }
    
    func MediaControlImage(_ name: String, size: CGFloat = 30) -> some View {
        return Image(systemName: name)
            .font(.system(size: size))
    }
}

struct NowPlayingBar_Previews: PreviewProvider {
    static var previews: some View {
        NowPlayingBar(content: AnyView(SocialView()), showingBar: .constant(true))
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
