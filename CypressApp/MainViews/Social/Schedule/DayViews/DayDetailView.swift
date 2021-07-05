//
//  DayDetailView.swift
//  CypressApp
//
//  Created by Alex Siracusa on 6/28/21.
//

import SwiftUI

struct DayDetailView: View {
    @EnvironmentObject var viewModel: ViewModelData
    let day: Day

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 10) {
                if day.blocksAndLunches.count > 0 {
                    ForEach(day.blocksAndLunches, id: \.displayId) { block in
                        if let fullBlock = viewModel.fullBlocks[block.data.id] {
                            LargeFullBlockView(block: block, fullBlock: fullBlock)
                                .padding(.horizontal)
                                .padding(.top, 20)
                        } else {
                            let type = block.data.blockType
                            let blockColor = type == .course ? Color(.lightGray) : .yellow
                            LargeBlockView(block: block, color: blockColor, type: type)
                                .padding(.horizontal)
                                .padding(.top, type == .course ? 20 : 0)
                        }
                    }
                } else {
                    Rectangle()
                        .fill(Color(red: 220 / 255, green: 220 / 255, blue: 220 / 255))
                        .frame(height: 219)
                        .cornerRadius(15.0)
                        .padding(.horizontal)
                        .padding(.top, 20)
                }
            }
            .padding(.vertical, 20)
        }
    }
}

struct DayDetailView_Previews: PreviewProvider {
    static var previews: some View {
        DayDetailView(day: Day.default)
            .environmentObject(ViewModelData.default)
    }
}
