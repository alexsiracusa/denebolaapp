//
//  EpisodeSettings.swift
//  CypressApp
//
//  Created by Alex Siracusa on 7/15/21.
//

import SwiftUI

struct EpisodeSettings: View {
    @EnvironmentObject var player: PlayerObject

    @State var reset = false

    let formatter: NumberFormatter = { () -> NumberFormatter in
        let formatter = NumberFormatter()
        formatter.usesSignificantDigits = true
        formatter.maximumSignificantDigits = 3
        formatter.minimumSignificantDigits = 1
        return formatter
    }()

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("Episode Settings")
                .font(.title2)
                .bold()
                .padding(.bottom, 20)

            ZStack(alignment: .center) {
                HStack {
                    Text("Volume")
                        .bold()

                    Spacer()
                }

                HStack {
                    Spacer()

                    Text("\(Int(player.volumeLevel))%")

                    Spacer()
                }
            }

            HStack(spacing: 5) {
                Slider(value: $player.volumeLevel, in: 0 ... 300, step: 5)
                    .onChange(of: player.volumeLevel) { value in
                        if player.playing {
                            player.volume = Float(value / 100)
                        }
                    }
            }
            .padding(.vertical, 5)
            .padding(.trailing, 5)

            ZStack(alignment: .center) {
                HStack {
                    Text("Speed")
                        .bold()

                    Spacer()
                }

                HStack {
                    Spacer()

                    Text((formatter.string(from: NSNumber(value: player.playbackSpeed)) ?? "") + "x")

                    Spacer()
                }
            }

            HStack(spacing: 5) {
                Slider(value: $player.playbackSpeed, in: 0.25 ... 2.5, step: 0.25)
                    .onChange(of: player.playbackSpeed) { value in
                        if player.playing {
                            player.rate = Float(value)
                        }
                    }
            }
            .padding(.vertical, 5)
            .padding(.trailing, 5)

            Button {
                reset = true
            } label: {
                Text("Reset")
            }
            .padding(.top, 10)

            Spacer()
        }
        .padding(.top, 10)
        .alert(isPresented: $reset) {
            Alert(
                title: Text("Are you sure you want to reset settings?"),
                primaryButton: .destructive(Text("Reset")) {
                    player.resetSettings()
                },
                secondaryButton: .cancel()
            )
        }
    }
}

struct EpisodeSettings_Previews: PreviewProvider {
    static var previews: some View {
        EpisodeSettings()
            .environmentObject(PlayerObject.default)
    }
}
