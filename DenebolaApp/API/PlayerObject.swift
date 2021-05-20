//
//  PlayerObject.swift
//  DenebolaApp
//
//  Created by Alex Siracusa on 5/14/21.
//

import Foundation
import MediaPlayer

class PlayerObject: ObservableObject {
    @Published var player: AVPlayer
    @Published var playing: Bool
    @Published var showingToolbar: Bool
    @Published var image: ImageView
    
    init() {
        self.player = AVPlayer()
        self.playing = false
        showingToolbar = false
        self.image = ImageView(url: URL(string: "https://upload.wikimedia.org/wikipedia/commons/thumb/b/b6/Image_created_with_a_mobile_phone.png/1200px-Image_created_with_a_mobile_phone.png")!)
    }
    
    func play() {
        self.player.play()
        self.playing = true
    }
    
    func pause() {
        self.player.pause()
        self.playing = false
    }
}
