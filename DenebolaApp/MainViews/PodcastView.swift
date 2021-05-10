//
//  PodcastView.swift
//  DenebolaApp
//
//  Created by Alex Siracusa on 5/2/21.
//

import SwiftUI
import MediaPlayer

struct PodcastView: View {
    @State var audioPlayer: AVAudioPlayer!
    
    var body: some View {
        VStack {
            Button {
                self.audioPlayer.play()
            } label: {
                Text("Play")
            }
            Button {
                self.audioPlayer.pause()
            } label: {
                Text("Pause")
            }
        }
        .onAppear {
            let data = NSDataAsset(name: "alan walker - faded (ncs release) at very low quality")!.data
            self.audioPlayer = try! AVAudioPlayer(data: data)
        }
    }
}

struct PodcastView_Previews: PreviewProvider {
    static var previews: some View {
        PodcastView()
    }
}
