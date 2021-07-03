//
//  ScheduleColumn.swift
//  CypressApp
//
//  Created by Alex Siracusa on 6/25/21.
//

import SwiftUI

struct ScheduleColumn: View {
    @EnvironmentObject var viewModel: ViewModelData

    let blocks: [Block]
    let startTime: Date
    let endTime: Date

    var length: Int {
        let interval = endTime - startTime
        return Int(interval / 60)
    }

    let height: CGFloat

    init(blocks: [Block], height: CGFloat = 375, start: Date, end: Date) {
        self.blocks = blocks
        startTime = start
        endTime = end
        self.height = height
    }

    var body: some View {
        GeometryReader { _ in
            if blocks.count > 0 {
                let perMinute = height / CGFloat(length)
                ForEach(blocks, id: \.id) { block in
                    let height = CGFloat(block.times.length / 60) * perMinute
                    let offset = CGFloat(block.times.fromDate - startTime) / 60 * perMinute
                    if let fullBlock = viewModel.fullBlocks[block.data.id] {
                        FullBlockView(block: block, fullBlock: fullBlock, height: height)
                            .offset(y: offset)
                    } else {
                        BlockView(block: block, height: height, color: Color(.lightGray))
                            .offset(y: offset)
                    }
                }
            } else {
                Rectangle()
                    .fill(Color(red: 220 / 255, green: 220 / 255, blue: 220 / 255))
                    .cornerRadius(5.0)
            }
        }
        .frame(height: height)
        .frame(maxWidth: 100)
    }
}

struct ScheduleColumn_Previews: PreviewProvider {
    static var previews: some View {
        let df: DateFormatter = {
            let formatter = DateFormatter()
            formatter.dateFormat = "hh:mm a"
            return formatter
        }()
        let startTime = df.date(from: "9:15 AM")!
        let endTime = df.date(from: "3:55 PM")!
        ScheduleColumn(blocks: Day.default.blocks, start: startTime, end: endTime)
            .environmentObject(ViewModelData.default)
    }
}
