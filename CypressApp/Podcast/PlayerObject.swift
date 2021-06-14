//
//  PlayerObject.swift
//  DenebolaApp
//
//  Created by Alex Siracusa on 5/14/21.
//

import Foundation
import MediaPlayer

class PlayerObject: ObservableObject {
    private let audioSession = AVAudioSession.sharedInstance()
    @Published var player: AVPlayer
    
    @Published var playing: Bool
    @Published var showingToolbar: Bool
    @Published var episode: PodcastEpisode? = nil
    
    @Published var loading = false
    @Published var audioLength = 0.0
    @Published var time = 0.0
    @Published var seeking = false

    init() {
        self.player = AVPlayer()
        try! audioSession.setCategory(.playAndRecord, mode: .spokenAudio, options: [.defaultToSpeaker, .allowAirPlay, .allowBluetoothA2DP])
        try! self.audioSession.setActive(true)
        self.playing = false
        self.showingToolbar = false
    }
    
    func setAudio(_ episode: PodcastEpisode) {
        self.pause()
        player.replaceCurrentItem(with: nil)
        guard let url = episode.audioURL else { return }
        self.episode = episode
        let asset = AVAsset(url: url)
        loading = true
        asset.loadValuesAsynchronously(forKeys: ["playable"]) {
            var error: NSError?
            let status = asset.statusOfValue(forKey: "playable", error: &error)
            switch status {
                case .loaded:
                    DispatchQueue.main.async {
                        self.setAsset(asset)
                    }
                case .failed:
                    fallthrough
                case .cancelled:
                    // TODO:
                    break
                default:
                    break
            }
        }
    }
    
    private func setAsset(_ asset: AVAsset) {
        let item = AVPlayerItem(asset: asset)
        player.replaceCurrentItem(with: item)
        if let duration = player.currentItem?.asset.duration {
            self.audioLength = CMTimeGetSeconds(duration)
        } else {
            self.audioLength = 0.0
        }
        player.addPeriodicTimeObserver(
            forInterval: CMTimeMake(value: 1, timescale: 2), // 1/2 seconds
            queue: DispatchQueue.main,
            using: {
                if !self.seeking {
                    self.time = $0.seconds
                }
            }
        )
        
        try! audioSession.setCategory(.playAndRecord, mode: .spokenAudio, options: [.defaultToSpeaker, .allowAirPlay, .allowBluetoothA2DP])
        try! AVAudioSession.sharedInstance().setActive(true)
        
        self.loading = false
        setupRemoteTransportControls()
        setupNowPlaying()
    }
    
    func seek(to: Double) {
        guard player.currentItem != nil else { return }
        player.seek(to: to < 0.5 ? .zero : CMTime(seconds: to, preferredTimescale: CMTimeScale(audioLength * 10))) { _ in
            self.seeking = false
        }
        self.time = to
        MPNowPlayingInfoCenter.default().nowPlayingInfo?[MPNowPlayingInfoPropertyElapsedPlaybackTime] = time
    }
    
    func goForward(seconds: Double) {
        if time + seconds <= 0 {
            seek(to: 0.0)
            return
        }
        seek(to: time + seconds)
    }

    func play() {
        self.playing = true
        MPNowPlayingInfoCenter.default().nowPlayingInfo?[MPNowPlayingInfoPropertyElapsedPlaybackTime] = time
        self.player.play()
    }

    func pause() {
        self.playing = false
        MPNowPlayingInfoCenter.default().nowPlayingInfo?[MPNowPlayingInfoPropertyElapsedPlaybackTime] = time
        self.player.pause()
    }
    
    func reset() {
        player.pause()
        self.player = AVPlayer()
        episode = nil
        MPNowPlayingInfoCenter.default().nowPlayingInfo = nil
    }
    
    func setupRemoteTransportControls() {
        let commandCenter = MPRemoteCommandCenter.shared()
        
        commandCenter.playCommand.isEnabled = true
        commandCenter.playCommand.addTarget { [unowned self] event in
            self.play()
            return .success
        }
        
        commandCenter.pauseCommand.isEnabled = true
        commandCenter.pauseCommand.addTarget { [unowned self] event in
            self.pause()
            return .success
        }
        
        commandCenter.changePlaybackRateCommand.isEnabled = true
        commandCenter.changePlaybackPositionCommand.addTarget { [weak self](remoteEvent) -> MPRemoteCommandHandlerStatus in
            guard let self = self else {return .commandFailed}
            if let event = remoteEvent as? MPChangePlaybackPositionCommandEvent {
                self.seek(to: event.positionTime)
                return .success
            }
            return .commandFailed
        }
        
        let skipBackwardCommand = commandCenter.skipBackwardCommand
        skipBackwardCommand.isEnabled = true
        skipBackwardCommand.addTarget(handler: skipBackward)
        skipBackwardCommand.preferredIntervals = [-15]

        let skipForwardCommand = commandCenter.skipForwardCommand
        skipForwardCommand.isEnabled = true
        skipForwardCommand.addTarget(handler: skipForward)
        skipForwardCommand.preferredIntervals = [15]
    }
    
    // stolen from https://stackoverflow.com/questions/20591156/is-there-a-public-way-to-force-mpnowplayinginfocenter-to-show-podcast-controls/24818340#24818340
    func skipBackward(_ event: MPRemoteCommandEvent) -> MPRemoteCommandHandlerStatus {
        guard let command = event.command as? MPSkipIntervalCommand else {
            return .noSuchContent
        }
        let interval = command.preferredIntervals[0]
        self.goForward(seconds: Double(truncating: interval))
        return .success
    }

    func skipForward(_ event: MPRemoteCommandEvent) -> MPRemoteCommandHandlerStatus {
        guard let command = event.command as? MPSkipIntervalCommand else {
            return .noSuchContent
        }
        let interval = command.preferredIntervals[0]
        self.goForward(seconds: Double(truncating: interval))
        return .success
    }
    
    func setupNowPlaying() {
        
        // Define Now Playing Info
        var nowPlayingInfo = [String : Any]()
        nowPlayingInfo[MPMediaItemPropertyTitle] = episode?.title ?? "none"

        if let image = UIImage(named: "DenebolaLogo") {
            nowPlayingInfo[MPMediaItemPropertyArtwork] =
                MPMediaItemArtwork(boundsSize: image.size) { size in
                    return image
            }
        }
        nowPlayingInfo[MPNowPlayingInfoPropertyElapsedPlaybackTime] = player.currentItem?.currentTime().seconds
        nowPlayingInfo[MPMediaItemPropertyPlaybackDuration] = player.currentItem!.asset.duration.seconds
        nowPlayingInfo[MPNowPlayingInfoPropertyPlaybackRate] = 1.0
        nowPlayingInfo[MPNowPlayingInfoPropertyElapsedPlaybackTime] = Float(CMTimeGetSeconds(player.currentItem!.currentTime()))
        //nowPlayingInfo[MPNowPlayingInfoPropertyElapsedPlaybackTime] = $time

        // Set the metadata
        MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
    }
}
