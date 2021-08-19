//
//  PopupView.swift
//  CypressApp
//
//  Created by Alex Siracusa on 7/14/21.
//

import SwiftUI

struct PopupView: View {
    let content: AnyView

    private let HORIZONTAL_PADDING: CGFloat = 40
    private let VERTICAL_PADDING: CGFloat = 160

    var body: some View {
        GeometryReader { geo in
            let width = geo.size.width - (HORIZONTAL_PADDING * 2)
            let height = geo.size.height - (VERTICAL_PADDING * 2)

            HStack {
                Spacer(minLength: 0)

                VStack {
                    Spacer(minLength: 0)

                    VStack {
                        content
                            .frame(width: width)
                            .frame(height: height)
                    }
                    .padding(10)
                    .background(Color(.lightGray).brightness(0.3))
                    .clipShape(RoundedRectangle(cornerRadius: 15))
                    .contentShape(RoundedRectangle(cornerRadius: 15))
                    .shadow(radius: 10)

                    Spacer(minLength: 0)
                }

                Spacer(minLength: 0)
            }
        }
        // .scaledToFit()
    }
}

struct VisualEffectView: UIViewRepresentable {
    var uiVisualEffect: UIVisualEffect?

    func makeUIView(context _: UIViewRepresentableContext<Self>) -> UIVisualEffectView {
        UIVisualEffectView()
    }

    func updateUIView(_ uiView: UIVisualEffectView, context _: UIViewRepresentableContext<Self>) {
        uiView.effect = uiVisualEffect
    }
}

struct PopupView_Previews: PreviewProvider {
    static var previews: some View {
        PopupView(content: AnyView(EpisodeDescription()))
            .environmentObject(PlayerObject.default)
    }
}
