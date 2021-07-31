//
//  CancelledKey.swift
//  CypressApp
//
//  Created by Alex Siracusa on 7/31/21.
//

import SwiftUI

struct AbsencesKey: View {
    var body: some View {
        HStack(spacing: 0) {
            Spacer()

            HStack {
                Dot(color: .red)
                    .offset(y: 1.2)

                Text("Full Day")
            }

            Spacer()
                .frame(width: 50)

            HStack {
                Dot(color: .yellow)
                    .offset(y: 1.2)

                Text("Partial Day")
            }

            Spacer()
        }
    }
}

struct CancelledKey_Previews: PreviewProvider {
    static var previews: some View {
        AbsencesKey()
    }
}
