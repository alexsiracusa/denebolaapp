//
//  Blur.swift
//  NowPlayingTest
//
//  Created by Alex Siracusa on 7/12/21.
//

import Foundation
import SwiftUI
import UIKit

struct BlurView: UIViewRepresentable {
    func makeUIView(context _: Context) -> UIVisualEffectView {
        let view = UIVisualEffectView(effect: UIBlurEffect(style: .systemChromeMaterial))
        return view
    }

    func updateUIView(_: UIVisualEffectView, context _: Context) {}
}
