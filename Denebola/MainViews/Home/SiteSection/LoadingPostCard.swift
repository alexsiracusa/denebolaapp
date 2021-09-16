//
//  LoadingSmallPostCard.swift
//  CypressApp
//
//  Created by Alex Siracusa on 7/30/21.
//

import SwiftUI

struct LoadingPostCard: View {
    func topLength(_ width: CGFloat) -> CGFloat {
        return CGFloat.random(in: (width / 1.5) ... width)
    }

    func bottomLength(_ width: CGFloat) -> CGFloat {
        return CGFloat.random(in: (width / 8) ... (width / 2))
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            LoadingRectangle()
                .aspectRatio(1.6, contentMode: .fit)
                .cornerRadius(10)
                .frame(width: 220, height: 137.5)

            GeometryReader { geo in
                let width = geo.size.width

                VStack(alignment: .leading, spacing: 0) {
                    Spacer(minLength: 0)
                    LoadingRectangle()
                        .frame(width: topLength(width), height: 10)
                        .cornerRadius(10)
                        .offset(y: -2)
                        .padding(.bottom, 2)
                    LoadingRectangle()
                        .frame(width: bottomLength(width), height: 9)
                        .cornerRadius(10)
                    Spacer(minLength: 0)
                }
            }
            .frame(height: 36)
        }
        .foregroundColor(.black)
        .frame(width: 220, height: 163.5)
    }
}

struct LoadingSmallPostCard_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            LoadingPostCard()
            LoadingPostCard()
            LoadingPostCard()
        }
    }
}
