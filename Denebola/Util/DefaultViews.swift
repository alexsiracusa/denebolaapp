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
    Image("DenebolaLogo")
        .resizable()
        .frame(width: 100, height: 100)
        .cornerRadius(5)
}

func Dot(color: Color) -> some View {
    Circle()
        .foregroundColor(color)
        .frame(width: 10, height: 10)
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

func LoadingRectangle(_ cornerRadius: CGFloat = 0) -> some View {
    Rectangle()
        .fill(Color(UIColor.lightGray))
        .brightness(0.2)
        .cornerRadius(cornerRadius)
}

func PlaceHolderImage() -> some View {
    LoadingRectangle()
        .overlay(
            GeometryReader { geo in
                let size = [geo.size.width, geo.size.height].min() ?? 0 * 0.9
                Image("CypressLogoTemplate")
                    .resizable()
                    .foregroundColor(.gray)
                    .opacity(0.2)
                    .frame(width: size, height: size)
                    .frame(alignment: .center)
                    .position(x: geo.size.width / 2, y: geo.size.width / 2)
            }
        )
}
