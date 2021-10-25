//
//  PlayerObject.swift
//  DenebolaApp
//
//  Created by Alex Siracusa on 5/14/21.
//

import Combine
import Foundation
import MediaPlayer
import Nuke
import PromiseKit
import SwiftUI

class PlayerObject: AVPlayer, ObservableObject {
    private var audioSession = AVAudioSession.sharedInstance()

    @Published var playing: Bool
    @Published var episode: PodcastEpisode? = nil

    @Published var loading = false
    @Published var audioLength = 0.0
    @Published var time = 0.0
    @Published var seeking = false

    @Published var volumeLevel = 0.0
    @Published var playbackSpeed = 0.0

    override var rate: Float {
        didSet {
            guard MPNowPlayingInfoCenter.default().nowPlayingInfo != nil else { return }
            MPNowPlayingInfoCenter.default().nowPlayingInfo?[MPNowPlayingInfoPropertyPlaybackRate] = rate
        }
    }

    override init() {
        playing = false
        super.init()
        try! audioSession.setCategory(.playAndRecord, mode: .spokenAudio, options: [.defaultToSpeaker, .allowAirPlay, .allowBluetoothA2DP])
        try! audioSession.setActive(true)
        registerObservers()
        playbackSpeed = Double(rate)
        volumeLevel = Double(volume * 100)
    }

    static var `default`: PlayerObject {
        let player = PlayerObject()
        player.setAudio(PodcastEpisode.default)
        return player
    }

    func setAudio(_ episode: PodcastEpisode) {
        replaceCurrentItem(with: nil)
        guard let url = episode.audioURL else { return }
        withAnimation {
            self.episode = episode
        }
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
        replaceCurrentItem(with: item)
        if let duration = currentItem?.asset.duration {
            audioLength = CMTimeGetSeconds(duration)
        }

        try! audioSession.setCategory(.playAndRecord, mode: .spokenAudio, options: [.defaultToSpeaker, .allowAirPlay, .allowBluetoothA2DP])
        try! AVAudioSession.sharedInstance().setActive(true)

        loading = false
        setupRemoteTransportControls()
        setupNowPlaying()
    }

    func togglePlay() {
        if playing {
            pause()
        } else {
            play()
        }
    }

    func seek(to: Double) {
        guard currentItem != nil else { return }
        seek(to: to < 0.5 ? .zero : CMTimeMakeWithSeconds(to, preferredTimescale: TIME_SCALE)) { _ in
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

    override func play() {
        super.play()
        if playbackSpeed < 0.25 { playbackSpeed = 1 }
        rate = Float(playbackSpeed)
        volume = Float(volumeLevel / 100)
        MPNowPlayingInfoCenter.default().nowPlayingInfo?[MPNowPlayingInfoPropertyElapsedPlaybackTime] = time
    }

    override func pause() {
        super.pause()
        MPNowPlayingInfoCenter.default().nowPlayingInfo?[MPNowPlayingInfoPropertyElapsedPlaybackTime] = time
    }

    func reset() {
        pause()
        time = 0.0
        episode = nil
        audioSession = AVAudioSession.sharedInstance()
        MPNowPlayingInfoCenter.default().nowPlayingInfo = nil
    }

    func resetSettings() {
        volumeLevel = 100
        volume = 1.0
        playbackSpeed = 1.0
        rate = playing ? 1.0 : 0.0
    }

    // MARK: Observers

    private var playingObserverToken: Any?
    private var timeObserverToken: Any?
    private var playerContext = 0

    private func registerObservers() {
        let interval = CMTimeMakeWithSeconds(1, preferredTimescale: TIME_SCALE)
        playingObserverToken = addObserver(self, forKeyPath: "rate", options: [.old, .new], context: &playerContext)
        timeObserverToken = addPeriodicTimeObserver(forInterval: interval, queue: .main) {
            [weak self] _ in
                if !(self?.seeking ?? true) {
                    self?.time = self?.currentTime().seconds ?? 0.0
                }
        }
    }

    override func observeValue(forKeyPath keyPath: String?,
                               of object: Any?,
                               change: [NSKeyValueChangeKey: Any]?,
                               context: UnsafeMutableRawPointer?)
    {
        // Only handle observations for the playerItemContext
        guard context == &playerContext else {
            super.observeValue(forKeyPath: keyPath,
                               of: object,
                               change: change,
                               context: context)
            return
        }

        playing = rate != 0
    }

    deinit {
        if let token = timeObserverToken {
            self.removeTimeObserver(token)
            timeObserverToken = nil
        }
        if let token = playingObserverToken {
            self.removeTimeObserver(token)
            playingObserverToken = nil
        }
    }

    // MARK: Now Playing Widget

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

        FetchImage.load(episode?.imageURL).done { image in
            let image = image.image
            MPNowPlayingInfoCenter.default().nowPlayingInfo?[MPMediaItemPropertyArtwork] =
                MPMediaItemArtwork(boundsSize: image.size) { _ in
                    image
                }
        }.catch { error in
            print(error.localizedDescription)
            if let image = UIImage(named: "CypressLogo") {
                MPNowPlayingInfoCenter.default().nowPlayingInfo?[MPMediaItemPropertyArtwork] =
                    MPMediaItemArtwork(boundsSize: image.size) { _ in
                        image
                    }
            }
        }

        nowPlayingInfo[MPNowPlayingInfoPropertyElapsedPlaybackTime] = currentItem?.currentTime().seconds
        nowPlayingInfo[MPMediaItemPropertyPlaybackDuration] = currentItem!.asset.duration.seconds
        nowPlayingInfo[MPNowPlayingInfoPropertyPlaybackRate] = 1.0
        nowPlayingInfo[MPNowPlayingInfoPropertyElapsedPlaybackTime] = Float(CMTimeGetSeconds(currentItem!.currentTime()))

        // Set the metadata
        MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
    }
}
