//
//  LoadingSmallPostCard.swift
//  CypressApp
//
//  Created by Alex Siracusa on 7/30/21.
//

import SwiftUI

struct LoadingPostCard: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            LoadingRectangle()
                .aspectRatio(1.6, contentMode: .fit)
                .cornerRadius(10)
                .frame(width: 220, height: 137.5)

            VStack(alignment: .leading, spacing: 0) {
                LoadingRectangle()
                    .frame(width: 200, height: 10)
                    .cornerRadius(10)
                    .offset(y: -2)
                    .padding(.bottom, 2)
                LoadingRectangle()
                    .frame(width: 100, height: 9)
                    .cornerRadius(10)
            }
            .frame(height: 36)
        }
        .foregroundColor(.black)
        .frame(width: 220, height: 163.5)
    }
}

struct LoadingSmallPostCard_Previews: PreviewProvider {
    static var previews: some View {
        LoadingPostCard()
    }
}
