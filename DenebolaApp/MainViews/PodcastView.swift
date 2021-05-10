//
//  PodcastView.swift
//  DenebolaApp
//
//  Created by Alex Siracusa on 5/2/21.
//

import MediaPlayer
import SwiftUI

struct PodcastView: View {
    @State var audioPlayer: AVAudioPlayer!
    @EnvironmentObject var loader: PodcastLoader
    @EnvironmentObject var handler: APIHandler
    
    var body: some View {
        NavigationView {
            ScrollView {
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
                ForEach(loader.podcasts) { podcast in
                    HStack(alignment: .top) {
                        if let url = podcast.imageURL {
                            ImageView(url: url)
                                .scaledToFill()
                                .frame(width: 50, height: 50)
                                .aspectRatio(1, contentMode: .fit)
                                .clipped()
                                .cornerRadius(5)
                                .padding(.leading, 5)
                        }
                        Button {
                            handler.loadData(url: podcast.audioURL!) { data, error in
                                guard let data = data else {return}
                                self.audioPlayer = try! AVAudioPlayer(data: data)
                                self.audioPlayer.play()
                            }
                        } label: {
                            Text(podcast.title!)
                                .foregroundColor(.black)
                                .lineLimit(2)
                        }
                        Spacer()
                    }
                    
                }
                
            }
            .navigationBarTitle("Denebacast", displayMode: .inline)
            .navigationBarItems(
                trailing: ToolbarLogo()
            )
        }
        .onAppear {
            let data = NSDataAsset(name: "alan walker - faded (ncs release) at very low quality")!.data
            self.audioPlayer = try! AVAudioPlayer(data: data)
            loader.load()
        }
    }
}

struct PodcastView_Previews: PreviewProvider {
    static var previews: some View {
        PodcastView()
            .environmentObject(PodcastLoader())
            .environmentObject(APIHandler())
    }
}
