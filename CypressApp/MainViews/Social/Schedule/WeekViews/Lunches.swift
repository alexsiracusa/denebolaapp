//
//  LunchColumn.swift
//  CypressApp
//
//  Created by Alex Siracusa on 6/29/21.
//

import SwiftUI

struct Lunches: View {
    @EnvironmentObject var viewModel: ViewModelData

    // let day: Day
    let lunches: [Block]
    let startTime: Date
    let endTime: Date

    var length: Int {
        let interval = endTime - startTime
        return Int(interval / 60)
    }

    let height: CGFloat

    init(lunches: [Block], height: CGFloat = 375, start: Date, end: Date) {
        self.lunches = lunches
        startTime = start
        endTime = end
        self.height = height
    }

    var body: some View {
        GeometryReader { _ in
            if lunches.count > 0 {
                let perMinute = height / CGFloat(length)
                ForEach(lunches, id: \.id) { lunch in
                    let height = CGFloat(lunch.times.length / 60) * perMinute
                    let offset = CGFloat(lunch.times.from - startTime) / 60 * perMinute
                    BlockView(block: lunch, height: height, color: .yellow)
                        .offset(y: offset)
                        .shadow(radius: 5.0)
                }
            }
        }
        .frame(height: height)
        .frame(maxWidth: 100)
    }
}

struct LunchColumn_Previews: PreviewProvider {
    static var previews: some View {
        let df: DateFormatter = {
            let formatter = DateFormatter()
            formatter.dateFormat = "hh:mm a"
            return formatter
        }()
        let startTime = df.date(from: "9:15 AM")!
        let endTime = df.date(from: "3:55 PM")!
        Lunches(lunches: Day.default.lunch, start: startTime, end: endTime)
            .environmentObject(ViewModelData.default)
    }
}
