//
//  PlayButton.swift
//  DenebolaApp
//
//  Created by Alex Siracusa on 5/10/21.
//

import SwiftUI

struct PlayButton: View {
    var body: some View {
        ZStack {
            Rectangle()
                .frame(width: 80, height: 80)
                .foregroundColor(.secondary)
                .brightness(0.6)
                .aspectRatio(1, contentMode: .fit)
                .clipped()
                .cornerRadius(5)
                .overlay(
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(Color.gray, lineWidth: 3)
                )
            Image(systemName: "play.circle")
                .resizable()
                .frame(width: 60, height: 60)
                .foregroundColor(.gray)
        }
    }
}

struct PlayButton_Previews: PreviewProvider {
    static var previews: some View {
        PlayButton()
    }
}
