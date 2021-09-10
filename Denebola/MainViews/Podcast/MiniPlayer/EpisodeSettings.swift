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

    @State var selectedIndex = 0
    let speeds = [0.25, 0.5, 0.75, 1.0, 1.25, 1.5, 1.75, 2.0, 2.25, 2.5]
    let speedIndicators = ["+", "+", "+", "1x", "+", "+", "+", "2x", "+", "+"]
    func indicatorColor(_ indicator: String, index: Int) -> Color {
        index == selectedIndex ? .orange : (indicator == "+" ? .secondary : .black)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // title
            HStack {
                Spacer(minLength: 0)
                VStack(spacing: 6) {
                    Image(systemName: "slider.horizontal.3")
                    Text("Episode Settings")
                        .font(.headline)
                        .bold()
                }
                .padding(.vertical, 12)
                Spacer(minLength: 0)
            }
            .background(Color(UIColor.lightGray).opacity(0.15))

            Divider()
                .padding(.bottom, 10)

            // settings
            VStack(alignment: .leading, spacing: 0) {
                VStack(spacing: 3) {
                    Slider(value: $player.volumeLevel, in: 0 ... 300, step: 5)
                        .onChange(of: player.volumeLevel) { value in
                            if player.playing {
                                player.volume = Float(value / 100)
                            }
                        }

                    HStack {
                        Text("Volume: " + "\(Int(player.volumeLevel))%")
                            .font(.caption)
                            .foregroundColor(.secondary)

                        Spacer(minLength: 0)
                    }
                }
                .padding(.vertical, 5)
                .padding(.trailing, 5)

                Spacer()
                    .frame(height: 20)

                VStack(spacing: 3) {
                    HStack {
                        ForEach(0 ..< speeds.count) { index in
                            let indicator = speedIndicators[index]
                            let color = indicatorColor(indicator, index: index)
                            Text(indicator)
                                .frame(width: 20)
                                .foregroundColor(color)

                            if index != speeds.count - 1 {
                                Spacer(minLength: 0)
                            }
                        }
                    }
                    .padding(.horizontal, 3.2)

                    Slider(value: $player.playbackSpeed, in: 0.25 ... 2.5, step: 0.25)
                        .onChange(of: player.playbackSpeed) { value in
                            if player.playing {
                                player.rate = Float(value)
                            }
                            self.selectedIndex = speeds.firstIndex(of: value) ?? selectedIndex
                        }

                    HStack {
                        Text("Speed: " + (formatter.string(from: NSNumber(value: player.playbackSpeed)) ?? "") + "x")
                            .font(.caption)
                            .foregroundColor(.secondary)

                        Spacer(minLength: 0)
                    }
                }
                .padding(.vertical, 5)
                .padding(.trailing, 5)

                Spacer()
                    .frame(height: 20)

                Button {
                    reset = true
                } label: {
                    Text("Reset")
                }
                .padding(.top, 10)
            }
            .padding(.horizontal, 10)

            Spacer()
        }
        .alert(isPresented: $reset) {
            Alert(
                title: Text("Are you sure you want to reset settings?"),
                primaryButton: .destructive(Text("Reset")) {
                    player.resetSettings()
                },
                secondaryButton: .cancel()
            )
        }
        .onAppear {
            self.selectedIndex = speeds.firstIndex(of: player.playbackSpeed) ?? selectedIndex
        }
    }
}

struct EpisodeSettings_Previews: PreviewProvider {
    static var previews: some View {
        EpisodeSettings()
            .environmentObject(PlayerObject.default)
    }
}
