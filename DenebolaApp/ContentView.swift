//
//  ContentView.swift
//  DenebolaApp
//
//  Created by Connor Tam on 5/1/21.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        //PostFeed()
        ViewController()
            .environmentObject(APIHandler())
        //PostView(id: 25133)
        //    .environmentObject(APIHandler())
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
