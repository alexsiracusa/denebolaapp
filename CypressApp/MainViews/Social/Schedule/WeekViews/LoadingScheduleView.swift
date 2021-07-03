//
//  LoadingScheduleView.swift
//  CypressApp
//
//  Created by Alex Siracusa on 6/29/21.
//

import SwiftUI

struct LoadingScheduleView: View {
    let height: CGFloat

    let column1: [(height: CGFloat, offset: CGFloat)] = [(80, 0), (130, 90), (80, 230), (80, 320)]
    let column2: [(height: CGFloat, offset: CGFloat)] = [(80, 0), (130, 90), (80, 230), (30, 320), (45, 355)]
    let column3: [(height: CGFloat, offset: CGFloat)] = [(70, 0), (120, 80), (70, 210), (70, 290)]

    var body: some View {
        VStack(alignment: .leading, spacing: 3) {
            HStack(alignment: .bottom) {
                Rectangle()
                    .fill(Color(UIColor.lightGray))
                    .brightness(0.2)
                    .frame(width: 120, height: 10)
                    .cornerRadius(5.0)
                Spacer()
                Rectangle()
                    .fill(Color(UIColor.lightGray))
                    .brightness(0.2)
                    .frame(width: 80, height: 10)
                    .cornerRadius(5.0)
            }
            .frame(height: 17)
            .padding(.horizontal, 5)

            HStack(spacing: 3) {
                blankColumn(column: column1)
                blankColumn(column: column2)
                blankColumn(column: column3)
                blankColumn(column: column1)
                blankColumn(column: column2)
            }
            .frame(height: height - 20)
        }
        .frame(height: height)
        .padding(.horizontal, 10)
    }

    func blankColumn(column: [(height: CGFloat, offset: CGFloat)]) -> some View {
        GeometryReader { _ in
            ForEach(0 ..< column.count) { index in
                let block = column[index]
                Rectangle()
                    .fill(Color(UIColor.lightGray))
                    .brightness(0.2)
                    .frame(height: block.height * ((height - 20) / 400))
                    .cornerRadius(5.0)
                    .offset(y: block.offset * ((height - 20) / 400))
            }
        }
        .frame(height: height - 20)
    }
}

struct LoadingScheduleView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingScheduleView(height: 400)
    }
}
