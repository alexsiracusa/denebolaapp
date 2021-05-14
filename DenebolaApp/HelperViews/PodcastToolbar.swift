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
    
    func toolbarImage(_ name: String) -> some View {
        Image(systemName: name)
            .resizable()
            .frame(width: 40, height: 40)
    }
    
    func seek(to: Double) {
        player.player.seek(to: CMTime(seconds: to, preferredTimescale: CMTimeScale(to))) {_ in
        }
    }
    
    var body: some View {
        HStack(spacing: 20) {
            image
                .scaledToFill()
                .frame(width: 60, height: 60)
                .aspectRatio(1.0, contentMode: .fit)
                .clipped()
                .cornerRadius(8)
            Button {
                seek(to: player.player.currentTime().seconds - 15)
            } label: {
                toolbarImage("gobackward.15")
            }
            Button {
                if player.playing {
                    pause()
                } else {
                    play()
                }
            } label: {
                toolbarImage(player.playing ? "pause.circle" : "play.circle")
            }
            Button {
                seek(to: player.player.currentTime().seconds + 30)
            } label: {
                toolbarImage("goforward.30")
            }
            Button {
                
            } label: {
                toolbarImage("xmark.circle")
            }
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
        PodcastToolbar(image: ImageView(url: URL(string: "https://helpx.adobe.com/content/dam/help/en/photoshop/using/convert-color-image-black-white/jcr_content/main-pars/before_and_after/image-before/Landscape-Color.jpg")!), player: PlayerObject())
    }
}
