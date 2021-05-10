//
//  BubbleText.swift
//  DenebolaApp
//
//  Created by Alex Siracusa on 5/10/21.
//

import SwiftUI

struct BubbleText: View {
    let text: String
    let backgroundRect: some View = RoundedRectangle(cornerRadius: 1000, style: .circular).foregroundColor(Color.gray)
    
    var body: some View {
        Text(text)
            .padding([.top, .bottom], 3)
            .padding([.leading, .trailing], 15)
            .background(backgroundRect.brightness(0.3))
    }
}

struct BubbleText_Previews: PreviewProvider {
    static var previews: some View {
        BubbleText(text: "opinions")
    }
}
