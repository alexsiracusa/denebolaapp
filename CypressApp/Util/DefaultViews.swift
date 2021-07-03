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

func SpinningLoader() -> some View {
    ProgressView()
        .progressViewStyle(CircularProgressViewStyle())
        .frame(width: 30, height: 30, alignment: .center)
}

func WarningIcon() -> some View {
    Image(systemName: "exclamationmark.triangle.fill")
        .foregroundColor(.yellow)
        .background(Color.white.clipped().frame(width: 3, height: 10, alignment: .center))
}
