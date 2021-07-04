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

    @Published var selectedTab: Int = 0
    @Published var schools: [School]!
    @Published var school: School!
    @Published var tabManager: TabManager!
    @Published var config: SchoolConfig!
    @Published var blocks: [BlockData]!
    @Published var fullBlocks: [Int: FullBlock]!
    @Published var selectedWordpress: Wordpress!
    @Published var podcastViewState: PodcastState = .hidden

    var navController: UINavigationController!

    enum PodcastState {
        case hidden
        case show
        case showFullScreen
    }

    static var `default`: ViewModelData {
        let model = ViewModelData()
        // TODO: add more defaults for this
        model.school = School.default
        model.selectedWordpress = Wordpress.default
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
