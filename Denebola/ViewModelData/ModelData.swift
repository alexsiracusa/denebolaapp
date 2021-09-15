//
//  ModelData.swift
//  DenebolaApp
//
//  Created by Connor Tam on 5/20/21.
//

import Alamofire
import SwiftUI

class ViewModelData: ObservableObject {
    @Published var loaded: LoadedState = .none

    enum LoadedState {
        case none, list, all
    }

    @Published var launching = true

    @Published var selectedTab: Int = 0
    @Published var schools: [School]!

    @Published var podcastExpanded: Bool = false

    @Published var loadingSchool: Int?

    // current school stuff - general
    @Published var school: School!
    @Published var config: SchoolConfig! {
        didSet {
            if let config = self.config {
                tabManager = TabManager(config.allTabs())
                sites = config.wordpress
                currentSite = sites[0]
                podcasts = config.podcasts

                if let sites = sites {
                    siteLoaders = sites.map { IncrementalLoader(WordpressPageLoader($0)) }
                }
            } else {
                tabManager = nil
                sites = nil
                currentSite = nil
                podcasts = nil
            }
        }
    }

    @Published var tabManager: TabManager!

    // current school stuff - feed
    @Published var currentSite: Wordpress!
    @Published var sites: [Wordpress]!
    @Published var siteLoaders: [IncrementalLoader<WordpressPageLoader>] = []

    // current school stuff - podcast
    @Published var podcasts: [Podcast]!
    @Published var loadedPodcasts = [Int: LoadedPodcast]()

    // current school stuff - social
    @Published var year: SchoolYear?
    @Published var blocks: [BlockData]!
    @Published var fullBlocks: [Int: FullBlock]!
    @Published var absences: Absences?

    var navController: UINavigationController!

    static var `default`: ViewModelData {
        let model = ViewModelData()
        // TODO: add more defaults for this
        model.school = School.default
        model.currentSite = Wordpress.default
        model.sites = [Wordpress.default]
        model.podcasts = [Podcast.default]
        model.blocks = Array(repeating: BlockData.default, count: 8)
        model.fullBlocks = [
            0: FullBlock(id: 0, name: "A"),
            1: FullBlock(id: 1, name: "B"),
            2: FullBlock(id: 2, name: "C"),
            3: FullBlock(id: 3, name: "D"),
        ]
        return model
    }
}
