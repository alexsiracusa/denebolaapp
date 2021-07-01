//
//  PodcastDetailView.swift
//  DenebolaApp
//
//  Created by Alex Siracusa on 5/23/21.
//

import MediaPlayer
import SwiftUI
import SwiftUIPager

private let PAGE_COUNT = 2

struct PodcastEpisodeView: View {
    @EnvironmentObject private var viewModel: ViewModelData
    @EnvironmentObject private var player: PlayerObject

    @StateObject var currentPage: Page = .first()
    // For hiding the view using a drag gesture
    @State var viewOffset: CGFloat = 0
    @State var viewHeight: CGFloat = 0
    // Dots indicating the current page
    @ViewBuilder func PageIndicator() -> some View {
        HStack {
            ForEach(0 ..< PAGE_COUNT, id: \.self) { index in
                let selected = currentPage.index == index

                Circle()
                    .frame(width: 10, height: 10)
                    .foregroundColor(selected ? .black : .gray)
            }
        }
    }

    var body: some View {
        let episode = player.episode!
        VStack(alignment: .center) {
            HStack(spacing: 15) {
                Button(action: {
                    viewModel.podcastViewState = .show
                }) {
                    Image(systemName: "chevron.down")
                        .font(.system(size: 25))
                        .foregroundColor(.black)
                }

                VStack(alignment: .leading) {
                    Text(episode.title)
                        .font(.title3)
                        .foregroundColor(.black)
                        .bold()
                        .lineLimit(1)

                    Text(episode.from.uppercased())
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .lineLimit(1)
                }
                Spacer()
            }

            Spacer()
                .frame(height: 15)

            PageIndicator()

            Spacer()
                .frame(height: 20)

            Pager(page: currentPage, data: Array(0 ..< PAGE_COUNT), id: \.self) { page in
                switch page {
                case 0:
                    NowPlayingPage()
                case 1:
                    DescriptionPage()
                default:
                    EmptyView()
                }
            }
            .itemSpacing(5.0)
            .sensitivity(.high)
            .pagingPriority(.simultaneous)
        }
        .padding(.horizontal, 15)
        .background(Color.white.ignoresSafeArea())
        // DRAG GESTURE STUFF
        .offset(y: viewOffset)
        .overlay(GeometryReader { reader in
            Spacer().onAppear { viewHeight = reader.size.height }
        })
        .animation(.easeInOut)
        .simultaneousGesture(DragGesture(minimumDistance: 100, coordinateSpace: .local)
            .onChanged { value in
                // Only allow first page
                guard currentPage.index == 0 else { return }

                // Offset distance - 10% of the view height to prevent dragging down while swiping right
                let offset = max(value.location.y - value.startLocation.y - viewHeight * 0.1, 0)

                // Hide the view if > 30% dragged down
                if offset / viewHeight > 0.3 {
                    viewModel.podcastViewState = .show
                }

                withAnimation {
                    viewOffset = offset
                }
            }
            .onEnded { _ in viewOffset = 0 })
    }
}

struct PodcastEpisodelView_Previews: PreviewProvider {
    static var previews: some View {
        PodcastEpisodeView()
            .environmentObject(PlayerObject.default)
            .environmentObject(ViewModelData())
    }
}
