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
            LoadingRectangle(10)
                .frame(height: 100)
                .aspectRatio(1.6, contentMode: .fit)

            VStack(alignment: .leading, spacing: 0) {
                LoadingRectangle()
                    .frame(height: 13)
                    .cornerRadius(10)
                    .padding(.top, 7)
                LoadingRectangle()
                    .frame(height: 13)
                    .cornerRadius(10)
                    .padding(.top, 8)
                LoadingRectangle()
                    .frame(width: 60, height: 10)
                    .cornerRadius(10)
                    .padding(.top, 12)
                LoadingRectangle()
                    .frame(width: 100, height: 10)
                    .cornerRadius(10)
                    .padding(.top, 8)
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
