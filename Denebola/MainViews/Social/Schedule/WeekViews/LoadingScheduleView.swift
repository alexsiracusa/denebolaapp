//
//  LoadingScheduleView.swift
//  CypressApp
//
//  Created by Alex Siracusa on 6/29/21.
//

import SwiftUI

struct LoadingScheduleView: View {
    let height: CGFloat
    var blockHeight: CGFloat {
        return height - 20
    }

    let column1: [(height: CGFloat, offset: CGFloat)] = [(80, 0), (130, 90), (80, 230), (80, 320)]
    let column2: [(height: CGFloat, offset: CGFloat)] = [(80, 0), (130, 90), (80, 230), (30, 320), (45, 355)]
    let column3: [(height: CGFloat, offset: CGFloat)] = [(70, 0), (120, 80), (70, 210), (70, 290)]

    var body: some View {
        VStack(alignment: .leading, spacing: 3) {
            HStack(spacing: 3) {
                blankColumn(column: column1)
                blankColumn(column: column2)
                blankColumn(column: column3)
                blankColumn(column: column1)
                blankColumn(column: column2)
            }
            .frame(height: blockHeight)

            HStack(alignment: .bottom) {
                LoadingRectangle(5)
                    .frame(width: 70, height: 10)
                Spacer()
            }
            .frame(height: 17)
            .padding(.horizontal, 5)
        }
        .frame(height: height)
        .padding(.horizontal, 10)
    }

    func blankColumn(column: [(height: CGFloat, offset: CGFloat)]) -> some View {
        VStack(spacing: 5) {
            LoadingRectangle(5)
                .frame(width: 30, height: 10)

            GeometryReader { _ in
                ForEach(0 ..< column.count) { index in
                    let block = column[index]
                    LoadingRectangle(5)
                        .frame(height: block.height * ((blockHeight - 15) / 400))
                        .offset(y: block.offset * ((blockHeight - 15) / 400))
                }
            }
            .frame(height: blockHeight - 15)
        }
        .frame(height: blockHeight)
    }
}

struct LoadingScheduleView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingScheduleView(height: 400)
    }
}
