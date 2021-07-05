//
//  BlockView.swift
//  CypressApp
//
//  Created by Alex Siracusa on 6/25/21.
//

import CoreData
import SwiftUI

struct BlockView: View {
    @EnvironmentObject var viewModel: ViewModelData

    let block: Block
    let height: CGFloat
    let color: Color

    init(block: Block, height: CGFloat, color: Color) {
        self.block = block
        self.height = height
        self.color = color
    }

    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            if height >= 15 {
                Text(block.times.fromString())
                    .foregroundColor(color.textColor)
                    .font(.caption2)
            }
            Spacer(minLength: 0)
            if height >= 50 {
                Text(block.data.name)
                    .font(.caption)
                    .bold()
                    .foregroundColor(color.textColor)
            }
            Spacer(minLength: 0)
            if height >= 26 {
                Text(block.times.toString())
                    .foregroundColor(color.textColor)
                    .font(.caption2)
            }
        }
        .padding(.vertical, 3)
        .padding(.horizontal, 5)
        .frame(maxWidth: 100)
        .frame(height: height)
        .background(color.cornerRadius(5.0))
    }
}

struct BlockView_Previews: PreviewProvider {
    static var previews: some View {
        BlockView(block: Block.default, height: 100, color: Color(.lightGray))
            .environmentObject(ViewModelData.default)
    }
}
