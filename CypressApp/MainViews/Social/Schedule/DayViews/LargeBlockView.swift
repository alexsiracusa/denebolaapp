//
//  LargeBlockView.swift
//  CypressApp
//
//  Created by Alex Siracusa on 6/28/21.
//

import SwiftUI

struct LargeBlockView: View {
    let name: String
    let times: Times
    let color: Color
    var blockName: String = ""
    var subject: String = ""
    var room: String = ""
    var teacherFirst: String = ""
    var teacherLast: String = ""

    init(block: Block, color: Color = Color(.lightGray)) {
        name = block.data.name
        times = block.times
        self.color = color
        blockName = block.data.name
    }

    init(lunch: Lunch, color: Color = .yellow) {
        name = lunch.name
        times = lunch.times
        self.color = color
    }

    init(name: String, times: Times, color: Color, blockName: String = "", subject: String = "", room: String = "", first: String = "", last: String = "") {
        self.name = name
        self.times = times
        self.color = color
        self.blockName = blockName
        self.subject = subject
        self.room = room
        teacherFirst = first
        teacherLast = last
    }

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(name == "" ? subject : name)
                    .font(.title)
                    .bold()
                    .foregroundColor(color.textColor)
                Spacer()
            }
            Text("\(times.from) - \(times.to) (\(Int(times.length / 60)) minutes)")
                .foregroundColor(color.textColor)

            if blockName != "" {
                HStack(alignment: .center) {
                    Image(systemName: "square.fill")
                    Text(blockName)
                }
                .frame(height: 40)
                .foregroundColor(color.textColor)
                .padding(.top, 5)
            }

            if room != "" {
                HStack(alignment: .center) {
                    Image(systemName: "house.fill")
                    Text(room)
                }
                .frame(height: 40)
                .foregroundColor(color.textColor)
            }

            if teacherFirst != "" || teacherLast != "" {
                HStack(alignment: .center) {
                    Image(systemName: "person.circle.fill")
                    Text([teacherLast, teacherFirst].compactMap { $0 }.filter { $0 != "" }.joined(separator: ", "))
                }
                .frame(height: 40)
                .foregroundColor(color.textColor)
            }
        }
        .padding()
        .background(color.cornerRadius(15.0))
    }
}

struct LargeBlockView_Previews: PreviewProvider {
    static var previews: some View {
        LargeBlockView(block: Block.default)
            .environmentObject(ViewModelData.default)
    }
}
