//
//  FullBlockView.swift
//  CypressApp
//
//  Created by Alex Siracusa on 7/2/21.
//

import SwiftUI

struct FullBlockView: View {
    let block: Block
    @ObservedObject var fullBlock: FullBlock
    let height: CGFloat

    var body: some View {
        BlockView(block: block, height: height, color: fullBlock.color)
    }
}

struct FullBlockView_Previews: PreviewProvider {
    static var previews: some View {
        FullBlockView(block: Block.default, fullBlock: FullBlock.default, height: 100)
    }
}
