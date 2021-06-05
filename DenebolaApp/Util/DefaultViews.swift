//
//  Globals.swift
//  DenebolaApp
//
//  Created by Connor Tam on 5/9/21.
//

import Foundation
import LoaderUI
import SwiftUI

func DefaultLoader() -> some View {
    return BallPulse()
        .foregroundColor(.black)
}

func PlaceholderImage() -> some View {
    return Image("DenebolaLogo")
        .resizable()
        .frame(width: 100, height: 100)
        .cornerRadius(5)
}

func PlaceholderBackground() -> some View {
    return Rectangle()
        .fill(Color.gray)
        .brightness(0.3)
}

