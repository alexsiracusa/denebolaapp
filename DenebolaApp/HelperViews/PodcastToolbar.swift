//
//  PodcastToolbar.swift
//  DenebolaApp
//
//  Created by Alex Siracusa on 5/13/21.
//

import SwiftUI
import MediaPlayer

struct PodcastToolbar: View {
    var image: ImageView
    @ObservedObject var player: PlayerObject
    @Binding var showingPodcastToolbar: Bool
    
    func toolbarImage(_ name: String, size: CGFloat) -> some View {
        Image(systemName: name)
            .resizable()
            .frame(width: size, height: size)
    }
    
    func seek(to: Double) {
        player.player.seek(to: CMTime(seconds: to, preferredTimescale: CMTimeScale(to))) {_ in
        }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            Divider()
            HStack(spacing: 0) {
                image
                    .scaledToFill()
                    .frame(width: 40, height: 40)
                    .aspectRatio(1.0, contentMode: .fit)
                    .clipped()
                    .cornerRadius(8)
                    .padding(.leading, 20)
                Spacer()
                Button {
                    seek(to: player.player.currentTime().seconds - 15)
                } label: {
                    toolbarImage("gobackward.15", size: 30)
                }
                Spacer()
                Button {
                    if player.playing {
                        pause()
                    } else {
                        play()
                    }
                } label: {
                    toolbarImage(player.playing ? "pause.fill" : "play.fill", size: 25)
                }
                Spacer()
                Button {
                    seek(to: player.player.currentTime().seconds + 30)
                } label: {
                    toolbarImage("goforward.30", size: 30)
                }
                Spacer()
                Button {
                    withAnimation {
                        showingPodcastToolbar = false
                    }
                } label: {
                    toolbarImage("xmark.circle", size: 30)
                }
                .padding(.trailing, 20)
            }
            .frame(height: 40)
            .padding([.top, .bottom], 5)
            .background(Color.white)
        }
    }
    
    func play() {
        self.player.play()
        self.player.playing = true
    }
    
    func pause() {
        self.player.pause()
        self.player.playing = false
    }
}

struct PodcastToolbar_Previews: PreviewProvider {
    static var previews: some View {
        PodcastToolbar(image: ImageView(url: URL(string: "https://helpx.adobe.com/content/dam/help/en/photoshop/using/convert-color-image-black-white/jcr_content/main-pars/before_and_after/image-before/Landscape-Color.jpg")!), player: PlayerObject(), showingPodcastToolbar: .constant(true))
    }
}
