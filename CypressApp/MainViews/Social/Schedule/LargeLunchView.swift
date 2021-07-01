//
//  LargeLunchView.swift
//  CypressApp
//
//  Created by Alex Siracusa on 6/29/21.
//

import SwiftUI

struct LargeLunchView: View {
    let lunch: Lunch
    let color = Color.yellow

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(lunch.name)
                    .font(.title)
                    .bold()
                    .foregroundColor(color.textColor)
                Spacer()
            }
            Text("\(lunch.times.from) - \(lunch.times.to) (\(Int(lunch.times.length / 60)) minutes)")
                .foregroundColor(color.textColor)
        }
        .padding()
        .background(color.cornerRadius(15.0))
    }
}

struct LargeLunchView_Previews: PreviewProvider {
    static var previews: some View {
        LargeLunchView(lunch: Lunch.default)
    }
}
