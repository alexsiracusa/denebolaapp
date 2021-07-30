//
//  TabManager.swift
//  DenebolaApp
//
//  Created by Alex Siracusa on 6/1/21.
//

import Foundation

class TabManager: ObservableObject {
    @Published var tabs: [Tab] = []

    init(_ tabs: [Tab]) {
        self.tabs = tabs
    }
}
