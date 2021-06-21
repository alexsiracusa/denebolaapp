//
//  NowPlayingPage.swift
//  CypressApp
//
//  Created by Connor Tam on 6/20/21.
//

import SwiftUI

struct NowPlayingPage: View {
    @EnvironmentObject var player: PlayerObject
    
    func MediaControlImage(_ name: String, size: CGFloat = 50) -> some View {
        return Image(systemName: name)
            .font(.system(size: size))
    }
    
    @ViewBuilder func PlaybackControls() -> some View {
        VStack {
            Slider(value: $player.time, in: 0 ... player.audioLength) { editing in
                if !editing {
                    player.seek(to: player.time)
                } else {
                    player.seeking = true
                }
            }
            .padding(.horizontal, 15)
            .padding(.top, 10)
            
            HStack {
                Text(getFormattedMinutesSeconds(player.time))
                    .font(.caption)
                    .fixedSize(horizontal: true, vertical: false)

                Spacer()
                
                Text(getFormattedMinutesSeconds(player.audioLength))
                    .font(.caption)
            }
            .padding(.horizontal, 15)
            .offset(y: -10)
        
            Spacer()
                .frame(height: 30)
        
            HStack(alignment: .center, spacing: 30) {
                Button {
                    player.goForward(seconds: -15)
                } label: {
                    MediaControlImage("gobackward.15", size: 45)
                }
        
                Button {
                    if player.playing {
                        player.pause()
                    } else {
                        player.play()
                    }
                } label: {
                    MediaControlImage(player.playing ? "pause.fill" : "play.fill", size: 75)
                        .frame(width: 75)
                }
        
                Button {
                    player.goForward(seconds: 15)
                } label: {
                    MediaControlImage("goforward.15", size: 45)
                }
            }
            .frame(height: 100)
        }
    }
    
    var body: some View {
        VStack(alignment: .center) {
            let episode = player.episode!
            
            ImageView(url: episode.imageURL!)
                .scaledToFit()
                .cornerRadius(15)
                .aspectRatio(1.0, contentMode: .fit)
            
            PlaybackControls()
            
            Spacer()
            
        }
    }
}

struct NowPlayingPage_Previews: PreviewProvider {
    static var previews: some View {
        NowPlayingPage()
            .environmentObject(PlayerObject.default)
    }
}
