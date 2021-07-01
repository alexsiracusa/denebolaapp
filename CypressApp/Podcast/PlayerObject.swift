//
//  PlayerObject.swift
//  DenebolaApp
//
//  Created by Alex Siracusa on 5/14/21.
//

import Foundation
import MediaPlayer

class PlayerObject: ObservableObject {
    private var audioSession = AVAudioSession.sharedInstance()
    @Published var player: AVPlayer

    @Published var playing: Bool
    @Published var episode: PodcastEpisode? = nil

    @Published var loading = false
    @Published var audioLength = 0.0
    @Published var time = 0.0
    @Published var seeking = false

    init() {
        player = AVPlayer()
        try! audioSession.setCategory(.playAndRecord, mode: .spokenAudio, options: [.defaultToSpeaker, .allowAirPlay, .allowBluetoothA2DP])
        try! audioSession.setActive(true)
        playing = false
    }

    static var `default`: PlayerObject {
        let player = PlayerObject()
        player.setAudio(PodcastEpisode.default)
        return player
    }

    func setAudio(_ episode: PodcastEpisode) {
        pause()
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
            audioLength = CMTimeGetSeconds(duration)
        } else {
            audioLength = 0.0
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

        loading = false
        setupRemoteTransportControls()
        setupNowPlaying()
    }

    func seek(to: Double) {
        guard player.currentItem != nil else { return }
        player.seek(to: to < 0.5 ? .zero : CMTime(seconds: to, preferredTimescale: CMTimeScale(audioLength * 10))) { _ in
            self.seeking = false
        }
        time = to
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
        playing = true
        MPNowPlayingInfoCenter.default().nowPlayingInfo?[MPNowPlayingInfoPropertyElapsedPlaybackTime] = time
        player.play()
    }

    func pause() {
        playing = false
        MPNowPlayingInfoCenter.default().nowPlayingInfo?[MPNowPlayingInfoPropertyElapsedPlaybackTime] = time
        player.pause()
    }

    func reset() {
        player.pause()
        player = AVPlayer()
        episode = nil
        audioSession = AVAudioSession.sharedInstance()
        // MPRemoteCommandCenter.shared().
        MPNowPlayingInfoCenter.default().nowPlayingInfo = nil
    }

    var playCommand: NSObject?
    var pauseCommand: NSObject?
    var positionCommand: NSObject?
    var forwardCommand: NSObject?
    var backCommand: NSObject?

    func resetRemooteCommands() {
        MPRemoteCommandCenter.shared().playCommand.removeTarget(playCommand)
        MPRemoteCommandCenter.shared().pauseCommand.removeTarget(pauseCommand)
        MPRemoteCommandCenter.shared().changePlaybackPositionCommand.removeTarget(positionCommand)
        MPRemoteCommandCenter.shared().skipForwardCommand.removeTarget(forwardCommand)
        MPRemoteCommandCenter.shared().skipBackwardCommand.removeTarget(backCommand)
    }

    func setupRemoteTransportControls() {
        let commandCenter = MPRemoteCommandCenter.shared()
        resetRemooteCommands()

        commandCenter.playCommand.isEnabled = true
        playCommand = commandCenter.playCommand.addTarget { [unowned self] _ in
            self.play()
            return .success
        } as? NSObject

        commandCenter.pauseCommand.isEnabled = true
        pauseCommand = commandCenter.pauseCommand.addTarget { [unowned self] _ in
            self.pause()
            return .success
        } as? NSObject

        commandCenter.changePlaybackRateCommand.isEnabled = true
        positionCommand = commandCenter.changePlaybackPositionCommand.addTarget { [weak self] remoteEvent -> MPRemoteCommandHandlerStatus in
            guard let self = self else { return .commandFailed }
            if let event = remoteEvent as? MPChangePlaybackPositionCommandEvent {
                self.seek(to: event.positionTime)
                return .success
            }
            return .commandFailed
        } as? NSObject

        let skipBackwardCommand = commandCenter.skipBackwardCommand
        skipBackwardCommand.isEnabled = true
        backCommand = skipBackwardCommand.addTarget(handler: skipBackward) as? NSObject
        skipBackwardCommand.preferredIntervals = [-15]

        let skipForwardCommand = commandCenter.skipForwardCommand
        skipForwardCommand.isEnabled = true
        forwardCommand = skipForwardCommand.addTarget(handler: skipForward) as? NSObject
        skipForwardCommand.preferredIntervals = [15]
    }

    // stolen from https://stackoverflow.com/questions/20591156/is-there-a-public-way-to-force-mpnowplayinginfocenter-to-show-podcast-controls/24818340#24818340
    func skipBackward(_ event: MPRemoteCommandEvent) -> MPRemoteCommandHandlerStatus {
        guard let command = event.command as? MPSkipIntervalCommand else {
            return .noSuchContent
        }
        let interval = command.preferredIntervals[0]
        goForward(seconds: Double(truncating: interval))
        return .success
    }

    func skipForward(_ event: MPRemoteCommandEvent) -> MPRemoteCommandHandlerStatus {
        guard let command = event.command as? MPSkipIntervalCommand else {
            return .noSuchContent
        }
        let interval = command.preferredIntervals[0]
        goForward(seconds: Double(truncating: interval))
        return .success
    }

    func setupNowPlaying() {
        // Define Now Playing Info
        var nowPlayingInfo = [String: Any]()
        nowPlayingInfo[MPMediaItemPropertyTitle] = episode?.title ?? "none"

        if let image = UIImage(named: "DenebolaLogo") {
            nowPlayingInfo[MPMediaItemPropertyArtwork] =
                MPMediaItemArtwork(boundsSize: image.size) { _ in
                    image
                }
        }
        nowPlayingInfo[MPNowPlayingInfoPropertyElapsedPlaybackTime] = player.currentItem?.currentTime().seconds
        nowPlayingInfo[MPMediaItemPropertyPlaybackDuration] = player.currentItem!.asset.duration.seconds
        nowPlayingInfo[MPNowPlayingInfoPropertyPlaybackRate] = 1.0
        nowPlayingInfo[MPNowPlayingInfoPropertyElapsedPlaybackTime] = Float(CMTimeGetSeconds(player.currentItem!.currentTime()))
        // nowPlayingInfo[MPNowPlayingInfoPropertyElapsedPlaybackTime] = $time

        // Set the metadata
        MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
    }
}
