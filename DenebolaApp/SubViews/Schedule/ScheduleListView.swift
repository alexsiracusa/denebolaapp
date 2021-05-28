//
//  ScheduleListView.swift
//  DenebolaApp
//
//  Created by Connor Tam on 5/26/21.
//

import SwiftUI

struct ScheduleListView: View {
    let blockTimes: [[BlockTime]]
    let blocks: [String: BlockData]

    @Binding var viewingIndex: Int

    var body: some View {
        VStack {
            HStack {
                Text(BlockTimes.days[viewingIndex])
                Spacer()

                Button(action: { viewingIndex = (viewingIndex - 1 + blockTimes.count) % blockTimes.count }) {
                    Image(systemName: "arrow.left")
                }
                Button(action: { viewingIndex = (viewingIndex + 1) % blockTimes.count }) {
                    Image(systemName: "arrow.right")
                }
            }.padding(.bottom, 15)

            VStack(alignment: .leading, spacing: 10) {
                ForEach(blockTimes[viewingIndex]) { blockTime in
                    HStack(alignment: .top) {
                        Text(blockTime.block)
                            .bold()
                            .padding(.trailing, 5)

                        if let block = blocks[blockTime.block] {
                            VStack(alignment: .leading) {
                                HStack {
                                    switch block.status {
                                        case .normal:
                                            Text(block.courseName)
                                        case .canceled:
                                            HStack {
                                                Text(block.courseName)
                                                    .strikethrough(color: .red)
                                                Text("Cancelled")
                                                    .foregroundColor(.red)
                                            }
                                    }
                                }
                                HStack {
                                    Text(block.teacher)
                                    Spacer()
                                    Text(block.roomNumber)
                                }
                            }
                        }
                    }

                    Divider()
                }
            }
        }
    }
}

struct ScheduleListView_Previews: PreviewProvider {
    static var previews: some View {
        ScheduleListView(blockTimes: BlockTimes.blocksDay, blocks: ScheduleData.testMap, viewingIndex: .constant(0))
    }
}
