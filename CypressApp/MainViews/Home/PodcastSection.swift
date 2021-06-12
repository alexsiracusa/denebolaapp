////
////  PodcastSection.swift
////  DenebolaApp
////
////  Created by Alex Siracusa on 5/19/21.
////
//
//import SwiftUI
//
//struct PodcastSection: View {
//    @EnvironmentObject var loader: PodcastLoader
//    @EnvironmentObject private var viewModel: ViewModelData
//
//    @State private var podcasts = [PodcastEpisode]()
//
//    var body: some View {
//        VStack(alignment: .leading, spacing: 5) {
//            Text("Denebacast")
//                .font(.title)
//                .fontWeight(.black)
//                .foregroundColor(.blue)
//                .padding(.bottom)
//
//            if podcasts.count >= 3 {
//                ForEach(0 ..< 3) { index in
//                    HStack {
//                        Button(action: {}) {
//                            Image(systemName: "play.circle")
//                                .font(.system(size: 30))
//                        }
//                        Spacer()
//                        Text(podcasts[index].title) // TODO:
//                            .lineLimit(1)
//                    }
//                }
//            }
//
//            Button(action: {
//                viewModel.selectedTab = 3
//            }) {
//                HStack {
//                    Spacer()
//                    Text("MORE EPISODES")
//                        .bold()
//                        .font(.subheadline)
//                    Image(systemName: "arrowtriangle.right.fill")
//                        .font(.system(size: 10))
//                }
//            }.foregroundColor(.blue)
//        }
//        .padding(.horizontal, 20)
//        .padding(.bottom, 20)
//        .onAppear {
//            if loader.loaded {
//                self.podcasts = loader.episodes
//            } else {
//                loader.load()
//            }
//        }
//    }
//}
//
//struct PodcastSection_Previews: PreviewProvider {
//    static var previews: some View {
//        PodcastSection()
//            .environmentObject(PodcastLoader())
//    }
//}
