//
//  LoadingPostRowView.swift
//  DenebolaApp
//
//  Created by Alex Siracusa on 5/2/21.
//

import SwiftUI

struct LoadingPostRowView: View {
    
    let rect: some View = Rectangle().foregroundColor(.gray).brightness(0.3)
    
    var body: some View {
        HStack(alignment: .top) {
            rect
                .cornerRadius(5)
                .frame(height: 100)
                .aspectRatio(1.6, contentMode: .fit)
            
            VStack(alignment: .leading, spacing: 3) {
                rect
                    .frame(height: 40)
                    .padding(.top, 3)
                rect
                    .frame(width: 100, height: 20)
                    .padding(.top, 1)
                rect
                    .frame(width: 150, height: 20)
                    .padding(.top, 1)
                Spacer()
            }
            .foregroundColor(.black)
            Spacer()
        }
        .frame(height:100)
        .padding([.leading, .trailing], 10)
    }
}

struct LoadingPostRowView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingPostRowView()
    }
}
