//
//  SettingsIcons.swift
//  CypressApp
//
//  Created by Alex Siracusa on 7/29/21.
//

import Foundation
import SwiftUI

enum Icon {
    case school, cache

    var view: AnyView {
        switch self {
        case .school:
            return AnyView(
                Image("AppleIcon")
                    .resizable()
            )
        case .cache:
            return AnyView(
                Image(systemName: "server.rack")
                    .foregroundColor(.white)
                    .font(.system(size: 13, weight: .medium))
                    .frame(width: 28, height: 28)
                    .background(Color.blue)
            )
        }
    }
}
