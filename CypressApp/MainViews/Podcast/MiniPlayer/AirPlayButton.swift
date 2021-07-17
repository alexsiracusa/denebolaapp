//
//  AirPlayButton.swift
//  CypressApp
//
//  Created by Alex Siracusa on 7/13/21.
//

import Foundation
import MediaPlayer
import SwiftUI
import UIKit

// stolen from https://stackoverflow.com/questions/60079607/how-to-display-the-airplay-menu-swiftui

struct AirPlayButton: UIViewControllerRepresentable {
    func makeUIViewController(context _: UIViewControllerRepresentableContext<AirPlayButton>) -> UIViewController {
        return AirPlayViewController()
    }

    func updateUIViewController(_: UIViewController, context _: UIViewControllerRepresentableContext<AirPlayButton>) {}
}

class AirPlayViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        let button = UIButton()
        let boldConfig = UIImage.SymbolConfiguration(scale: .large)
        let boldSearch = UIImage(systemName: "airplayaudio", withConfiguration: boldConfig)

        button.setImage(boldSearch, for: .normal)
        button.frame = CGRect(x: 0, y: 0, width: 40, height: 40)

        button.addTarget(self, action: #selector(showAirPlayMenu(_:)), for: .touchUpInside)
        view.addSubview(button)
    }

    @objc func showAirPlayMenu(_: UIButton) { // copied from https://stackoverflow.com/a/44909445/7974174
        let rect = CGRect(x: 0, y: 0, width: 0, height: 0)
        let airplayVolume = MPVolumeView(frame: rect)
        airplayVolume.showsVolumeSlider = false
        view.addSubview(airplayVolume)
        for view: UIView in airplayVolume.subviews {
            if let button = view as? UIButton {
                button.sendActions(for: .touchUpInside)
                break
            }
        }
        airplayVolume.removeFromSuperview()
    }
}
