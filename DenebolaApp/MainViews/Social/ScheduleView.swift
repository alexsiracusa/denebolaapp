//
//  ScheduleView.swift
//  DenebolaApp
//
//  Created by Connor Tam on 5/26/21.
//

import SwiftUI

struct ScheduleView: View {
    let blockTimes: [[BlockTime]]
    let onDayTap: (Int) -> Void

    var body: some View {
        HStack(alignment: .top, spacing: 0) {
            ForEach(0 ..< BlockTimes.blocksDay.count) { index in
                VStack(spacing: 0) {
                    
                    Text("\(BlockTimes.days[index])")
                        .font(.system(size: 10))
                        .padding(.bottom, 5)
                    
                    ForEach(BlockTimes.blocksDay[index]) { block in
                        ZStack {
                            Rectangle()
                                .stroke(Color.black, lineWidth: 1)
                                .frame(height: 80)

                            VStack {
                                Text(block.block)
                                    .bold()
                                    .lineLimit(1)
                                Text("\(block.startTime.toFormat("h:mm"))-\(block.endTime.toFormat("h:mm"))")
                                    .font(.system(size: 10))
                            }.padding(.horizontal, 2)
                        }
                    }
                    
                }.onTapGesture {
                    onDayTap(index)
                }
            }
        }
    }
}

struct ScheduleView_Previews: PreviewProvider {
    static var previews: some View {
        ScheduleView(blockTimes: BlockTimes.blocksDay, onDayTap: {_ in})
    }
}
