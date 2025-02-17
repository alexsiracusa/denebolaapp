//
//  ContentView.swift
//  DenebolaApp
//
//  Created by Connor Tam on 5/1/21.
//

import MediaPlayer
import SwiftUI

struct ContentView: View {
    init() {
        // Initial program code to be run once
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback)

        } catch {
            // report for an error
        }
        addAutoDateFormats()
    }

    var body: some View {
        ViewController()
            .environmentObject(ViewModelData())
            .environmentObject(PlayerObject())
            .environmentObject(ViewModelData())
            .preferredColorScheme(.light) // Until we add dark mode custom theming
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
