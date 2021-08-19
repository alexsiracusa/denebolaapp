//
//  Tab.swift
//  DenebolaApp
//
//  Created by Alex Siracusa on 6/1/21.
//

import Foundation
import SwiftUI

protocol Tab {
    var tabIcon: AnyView { get }
    var content: AnyView { get }
    var name: String { get }
    var id: TabID { get }
}

enum TabID: Int {
    case home = 0
    case feed = 1
    case podcast = 2
    case social = 3
    case list = 99
    case settings = 100
}
