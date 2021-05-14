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
    
    init() {
        self.player = AVPlayer()
        self.playing = false
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
