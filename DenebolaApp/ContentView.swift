//
//  ContentView.swift
//  DenebolaApp
//
//  Created by Connor Tam on 5/1/21.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        ViewController()
            .environmentObject(APIHandler())
            .preferredColorScheme(.light) // Until we add dark mode custom theming
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
