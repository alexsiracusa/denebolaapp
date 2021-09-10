//
//  MiniPlayer.swift
//  NowPlayingTest
//
//  Created by Alex Siracusa on 7/12/21.
//

import SwiftUI

struct MiniPlayer: View {
    @EnvironmentObject var player: PlayerObject
    @EnvironmentObject var viewModel: ViewModelData

    var animation: Namespace.ID
    @Binding var expand: Bool {
        didSet {
            impact()
        }
    }

    enum PopupState {
        case none, description, settings
    }

    @State var showTotalTime = true
    var rightTimeDisplay: String {
        if showTotalTime {
            return getFormattedMinutesSeconds(player.audioLength)
        } else {
            return "-" + getFormattedMinutesSeconds(player.audioLength - player.time)
        }
    }

    @State var popup: PopupState = .none
    var height = UIScreen.main.bounds.height / 3
    var safeArea = UIApplication.shared.windows.first?.safeAreaInsets

    @State var offset: CGFloat = 0
    var body: some View {
        if let episode = player.episode {
            ZStack {
                VStack(spacing: 0) {
                    // top bar area
                    HStack {
                        if expand {
                            Button(action: {
                                withAnimation { expand = false }
                            }) {
                                Image(systemName: "chevron.down")
                                    .font(Font.system(size: 25, weight: .bold))
                                    .frame(height: 35)
                            }

                            VStack(alignment: .leading, spacing: 0) {
                                Text(episode.title)
                                    .font(.title3)
                                    .foregroundColor(.primary)
                                    .fontWeight(.bold)
                                    .lineLimit(1)

                                Text(episode.from)
                                    .font(.caption)
                                    .foregroundColor(.gray)
                                    .fontWeight(.bold)
                                    .lineLimit(1)
                            }
                            Spacer()
                        }
                        Spacer(minLength: 0)
                    }
                    .padding(.horizontal)
                    .padding(.top, expand ? (safeArea?.top ?? 0) + 15 : 0)
                    .padding(.bottom, expand ? 15 : 0)

                    // image + bottom toolbar
                    HStack(spacing: 0) {
                        // centering image...
                        if expand {
                            Spacer(minLength: 0)
                        }

                        ImageView(url: episode.imageURL!, aspectRatio: 1.0)
                            .aspectRatio(contentMode: .fill)
                            .frame(width: expand ? nil : 50, height: expand ? nil : 50)
                            .cornerRadius(expand ? 15 : 10)
                            .scaledToFit()
                            .padding(.horizontal, expand ? 30 : 0)
                            .onTapGesture(perform: {
                                withAnimation { expand = true }
                            })
                            .disabled(expand == true)

                        if !expand {
                            Spacer(minLength: 0)

                            Button {
                                player.goForward(seconds: -15)
                            } label: {
                                MediaControlImage("gobackward.15", size: 32)
                                    .matchedGeometryEffect(id: "back", in: animation)
                            }
                            .frame(width: 50)

                            Spacer(minLength: 0)

                            Button {
                                player.togglePlay()
                            } label: {
                                MediaControlImage(player.playing ? "pause.fill" : "play.fill", size: 40)
                                    .matchedGeometryEffect(id: "Pause/Play", in: animation)
                            }
                            .frame(width: 50)

                            Spacer(minLength: 0)

                            Button {
                                player.goForward(seconds: 15)
                            } label: {
                                MediaControlImage("goforward.15", size: 32)
                                    .matchedGeometryEffect(id: "forward", in: animation)
                            }
                            .frame(width: 50)

                            Spacer(minLength: 0)

                            Button {
                                player.reset()
                            } label: {
                                MediaControlImage("xmark", size: 30)
                                    .frame(width: 50)
                            }
                        }
                    }
                    .padding(.horizontal, 10)

                    // expanded controls
                    if expand {
                        VStack(spacing: 15) {
                            // Slider
                            VStack(spacing: 0) {
                                Slider(value: $player.time, in: 0 ... player.audioLength) { editing in
                                    if !editing {
                                        player.seek(to: player.time)
                                    } else {
                                        player.seeking = true
                                    }
                                }
                                .opacity(expand ? 1 : 0)

                                HStack {
                                    Text(getFormattedMinutesSeconds(player.time))
                                        .font(.caption)

                                    Spacer()

                                    Button {
                                        showTotalTime.toggle()
                                    } label: {
                                        Text(rightTimeDisplay)
                                            .font(.caption)
                                    }
                                    .buttonStyle(NoButtonAnimation())
                                }
                                .foregroundColor(.black)
                            }
                            .padding(.top, 15)
                            .padding(.horizontal, 40)

                            // expanded toolbar
                            HStack(alignment: .center, spacing: 30) {
                                Button {
                                    player.goForward(seconds: -15)
                                } label: {
                                    MediaControlImage("gobackward.15", size: 32)
                                        .matchedGeometryEffect(id: "back", in: animation)
                                }

                                Button {
                                    player.togglePlay()
                                } label: {
                                    MediaControlImage(player.playing ? "pause.fill" : "play.fill", size: 40)
                                        .matchedGeometryEffect(id: "Pause/Play", in: animation)
                                        .frame(width: 75)
                                }
                                .frame(width: 75)

                                Button {
                                    player.goForward(seconds: 15)
                                } label: {
                                    MediaControlImage("goforward.15", size: 32)
                                        .matchedGeometryEffect(id: "forward", in: animation)
                                }
                            }
                            .frame(height: 50)
                            .padding()
                            Spacer(minLength: 0)

                            // bottom popup buttons
                            HStack(spacing: 10) {
                                Spacer(minLength: 0)

                                Button {
                                    withAnimation { popup = .settings }
                                } label: {
                                    MediaControlImage("slider.horizontal.3", size: 20)
                                        .frame(width: 40, height: 40)
                                }

                                AirPlayButton()
                                    .frame(width: 40, height: 40)

                                Button {
                                    withAnimation { popup = .description }
                                } label: {
                                    MediaControlImage("info.circle", size: 20)
                                        .frame(width: 40, height: 40)
                                }

                                Spacer(minLength: 0)
                            }
                            .opacity(expand ? 1 : 0)
                            .frame(height: expand ? nil : 0)
                            .padding(.bottom, expand ? (safeArea?.bottom ?? 0) + 15 : 0)
                        }
                    }
                }

                // popup
                if popup == .description {
                    Popup(AnyView(EpisodeDescription()))
                        .zIndex(1)
                } else if popup == .settings {
                    Popup(AnyView(EpisodeSettings()))
                        .zIndex(1)
                }
            }
            .frame(maxHeight: expand ? .infinity : 65)
            .background(
                VStack(spacing: 0) {
                    if expand {
                        BlurView()
                    } else {
                        Rectangle().foregroundColor(Color.white.opacity(0.95))
                    }
                    Divider()
                }
                .onTapGesture(perform: {
                    guard !expand else { return }
                    withAnimation { expand = true }
                })
            )
            .cornerRadius(expand ? 20 : 0)
            .offset(y: expand ? 0 : -49)
            .offset(y: offset)
            .gesture(
                popup == .none ? DragGesture().onChanged(onChanged).onEnded(onEnded) : nil
            )
            .ignoresSafeArea()
            .transition(AnyTransition.opacity)
        }
    }

    func Popup(_ content: AnyView) -> some View {
        ZStack {
            PopupView(content: content)
                .zIndex(1)
            VisualEffectView(uiVisualEffect: UIBlurEffect(style: .light))
                .zIndex(0)
                .transition(.opacity)
                .onTapGesture {
                    withAnimation { popup = .none }
                }
        }
    }

    func onChanged(value: DragGesture.Value) {
        // only allowing when its expanded...
        if value.translation.height > 0, expand {
            offset = value.translation.height
        }
    }

    func onEnded(value: DragGesture.Value) {
        withAnimation(.interactiveSpring(response: 0.5, dampingFraction: 0.95, blendDuration: 0.95)) {
            // if value is > than 1/3 of screen height then close view...
            if value.translation.height > height {
                expand = false
            }
            offset = 0
        }
    }

    func MediaControlImage(_ name: String, size: CGFloat = 50) -> some View {
        return Image(systemName: name)
            .font(.system(size: size))
    }
}

struct MiniPlayer_Previews: PreviewProvider {
    struct TestView: View {
        @Namespace var ns
        @State var expand = false
        var body: some View {
            MiniPlayer(animation: ns, expand: $expand)
        }
    }

    static var previews: some View {
        ZStack(alignment: .bottom) {
            TabView {
                Text("")
                    .tabItem {
                        Image(systemName: "rectangle.stack.fill")
                        Text("Library")
                    }
            }
            TestView()
        }
        .environmentObject(PlayerObject.default)
        .environmentObject(ViewModelData.default)
    }
}
