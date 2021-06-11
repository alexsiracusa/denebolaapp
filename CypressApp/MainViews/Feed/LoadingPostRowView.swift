//
//  LoadingPostRowView.swift
//  DenebolaApp
//
//  Created by Alex Siracusa on 5/2/21.
//

import SwiftUI

struct LoadingPostRowView: View {
    var body: some View {
        HStack(alignment: .top) {
            PlaceholderBackground()
                .cornerRadius(5)
                .frame(height: 100)
                .aspectRatio(1.6, contentMode: .fit)

            VStack(alignment: .leading, spacing: 3) {
                PlaceholderBackground()
                    .frame(height: 40)
                    .padding(.top, 3)
                PlaceholderBackground()
                    .frame(width: 100, height: 20)
                    .padding(.top, 1)
                PlaceholderBackground()
                    .frame(width: 150, height: 20)
                    .padding(.top, 1)
                Spacer()
            }
            .foregroundColor(.black)
            Spacer(minLength: 0)
        }
        .frame(height: 100)
    }
}

struct LoadingPostRowView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingPostRowView()
    }
}
