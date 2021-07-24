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
    let date: Date

    var length: Int {
        let interval = endTime - startTime
        return Int(interval / 60)
    }

    let height: CGFloat
    var blockHeight: CGFloat { return height - 15 }

    init(blocks: [Block], height: CGFloat = 375, start: Date, end: Date, date: Date) {
        self.blocks = blocks
        startTime = start
        endTime = end
        self.height = height
        self.date = date
    }

    var body: some View {
        VStack(spacing: 5) {
            Text("\(date.localDay(from: .local))")
                .foregroundColor(date.isLocalToday() ? .orange : .black)
                .bold()
                .font(.caption)
                .frame(height: 10)
            GeometryReader { _ in
                if blocks.count > 0 {
                    let perMinute = blockHeight / CGFloat(length)
                    ForEach(blocks, id: \.id) { block in
                        let height = CGFloat(block.times.length / 60) * perMinute
                        let offset = CGFloat(block.times.from - startTime) / 60 * perMinute
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
            .frame(height: blockHeight)
        }
        .frame(height: height)
        .frame(maxWidth: 100)
    }
}

struct CircleBackground: View {
    let size: CGFloat?

    var body: some View {
        if let size = size {
            Circle()
                .frame(width: size, height: size)
        }
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
        ScheduleColumn(blocks: Day.default.blocks, start: startTime, end: endTime, date: Date())
            .environmentObject(ViewModelData.default)
    }
}
