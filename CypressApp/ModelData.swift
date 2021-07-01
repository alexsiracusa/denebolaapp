//
//  ModelData.swift
//  DenebolaApp
//
//  Created by Connor Tam on 5/20/21.
//

import SwiftUI

class ViewModelData: ObservableObject {
    @Published var selectedTab: Int = 0
    @Published var school: School!
    @Published var config: SchoolConfig!
    @Published var blocks: [BlockData]!
    @Published var selectedWordpress: Wordpress!
    @Published var podcastViewState: PodcastState = .hidden

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
        return model
    }
}
