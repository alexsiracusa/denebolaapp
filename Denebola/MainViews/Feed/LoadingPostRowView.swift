//
//  LoadingPostRowView.swift
//  DenebolaApp
//
//  Created by Alex Siracusa on 5/2/21.
//

import SwiftUI

struct LoadingPostRowView: View {
    func longLength(_ width: CGFloat) -> CGFloat {
        return CGFloat.random(in: (width / 2) ... width)
    }

    func shortLength(_ width: CGFloat) -> CGFloat {
        return CGFloat.random(in: (width / 5) ... (width / 3))
    }

    var body: some View {
        HStack(alignment: .top) {
            LoadingRectangle(10)
                .frame(height: 90)
                .aspectRatio(1.6, contentMode: .fit)

            GeometryReader { geo in
                let width = geo.size.width

                VStack(alignment: .leading, spacing: 0) {
                    LoadingRectangle()
                        .frame(width: longLength(width), height: 11)
                        .cornerRadius(10)
                        .padding(.top, 7)
                    LoadingRectangle()
                        .frame(width: longLength(width), height: 11)
                        .cornerRadius(10)
                        .padding(.top, 8)
                        .padding(.trailing, 30)
                    LoadingRectangle()
                        .frame(width: shortLength(width), height: 10)
                        .cornerRadius(10)
                        .padding(.top, 9)
                    LoadingRectangle()
                        .frame(width: shortLength(width), height: 10)
                        .cornerRadius(9)
                        .padding(.top, 8)
                    Spacer()
                }
                .foregroundColor(.black)
            }
            Spacer(minLength: 0)
        }
        .frame(height: 90)
        .padding(.horizontal, 15)
        .padding(.vertical, 5)
    }
}

struct LoadingPostRowView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            LoadingPostRowView()
            LoadingPostRowView()
            LoadingPostRowView()
            LoadingPostRowView()
            LoadingPostRowView()
            LoadingPostRowView()
        }
    }
}
