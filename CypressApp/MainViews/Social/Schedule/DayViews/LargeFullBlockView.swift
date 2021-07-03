//
//  LargeFullBlockView.swift
//  CypressApp
//
//  Created by Alex Siracusa on 7/2/21.
//

import SwiftUI

struct LargeFullBlockView: View {
    let block: Block
    @ObservedObject var fullBlock: FullBlock

    var body: some View {
        LargeBlockView(name: block.data.name, times: block.times, color: fullBlock.color, blockName: block.data.name, subject: fullBlock.subject, room: fullBlock.room, first: fullBlock.teacherFirst, last: fullBlock.teacherLast)
    }
}

struct LargeFullBlockView_Previews: PreviewProvider {
    static var previews: some View {
        LargeFullBlockView(block: Block.default, fullBlock: FullBlock.default)
    }
}
