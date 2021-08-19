//
//  ScheduleBlockView.swift
//  CypressApp
//
//  Created by Alex Siracusa on 8/4/21.
//

import SwiftUI

struct ScheduleBlockView: View {
    @EnvironmentObject var viewModel: ViewModelData
    let block: Block

    var body: some View {
        if let fullBlock = viewModel.fullBlocks[block.data.id] {
            LargeFullBlockView(block: block, fullBlock: fullBlock)
        } else {
            let type = block.data.blockType
            let blockColor = type == .course ? Color(.lightGray) : .yellow
            LargeBlockView(block: block, color: blockColor, type: type)
        }
    }
}

struct ScheduleBlockView_Previews: PreviewProvider {
    static var previews: some View {
        ScheduleBlockView(block: Block.default)
            .environmentObject(ViewModelData.default)
    }
}
