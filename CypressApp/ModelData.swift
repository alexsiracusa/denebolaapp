//
//  ModelData.swift
//  DenebolaApp
//
//  Created by Connor Tam on 5/20/21.
//

import SwiftUI

class ViewModelData: ObservableObject {
    @Published var selectedTab: Int = 0
    @Published var selectedWordpress: Wordpress!
}
