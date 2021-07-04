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
}
