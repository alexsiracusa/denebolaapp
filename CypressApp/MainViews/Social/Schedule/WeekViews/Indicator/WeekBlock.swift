//
//  WeekBlock.swift
//  CypressApp
//
//  Created by Alex Siracusa on 7/4/21.
//

import SwiftUI

struct WeekBlock: View {
    let date: Date
    let selected: Bool
    var color: Color {
        return selected ? Color.blue : Color.white
    }

    var finalColor: Color {
        return date.isInCurrentWeek() && !selected ? .orange : color.textColor
    }

    var body: some View {
        VStack {
            Text(date.monthName(.short))
                .foregroundColor(finalColor)
                .font(.caption)
                .bold()
            Text("\(date.day)")
                .foregroundColor(finalColor)
                .bold()
        }
        .frame(height: 40)
        .frame(minWidth: 60)
        .frame(maxWidth: .infinity)
        .background(color.opacity(0.6).animation(nil))
        .border(Color.gray, width: 0.5)
    }
}

struct WeekBlock_Previews: PreviewProvider {
    static var previews: some View {
        WeekBlock(date: Date(), selected: true)
    }
}
