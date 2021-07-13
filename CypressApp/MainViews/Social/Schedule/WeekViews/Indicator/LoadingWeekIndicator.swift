//
//  LoadingWeekIndicator.swift
//  CypressApp
//
//  Created by Alex Siracusa on 7/6/21.
//

import SwiftUI

struct LoadingWeekIndicator: View {
    var body: some View {
        HStack(spacing: 0) {
            ForEach(0 ..< 7) { _ in
                Block()
            }
        }
        .frame(height: 40)
    }

    func Block() -> some View {
        Rectangle()
            .fill(Color.gray)
            .opacity(0.2)
            .frame(height: 40)
            .border(Color.gray, width: 0.5)
    }
}

struct LoadingWeekIndicator_Previews: PreviewProvider {
    static var previews: some View {
        LoadingWeekIndicator()
    }
}
