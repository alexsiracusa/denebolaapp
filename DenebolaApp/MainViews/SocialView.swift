//
//  SocialView.swift
//  DenebolaApp
//
//  Created by Connor Tam on 5/25/21.
//

import SwiftDate
import SwiftUI

struct SocialView: View {
    @EnvironmentObject var viewModel: ViewModelData

    @State var showingScheduleDay: Int = 0
    @State var showingSchedule: Bool = false

    var body: some View {
        NavigationView {
            ScrollView(/*@START_MENU_TOKEN@*/ .vertical/*@END_MENU_TOKEN@*/, showsIndicators: false) {
                VStack(alignment: .leading) {
                    Group {
                        HStack {
                            Text("Your Schedule")
                                .font(.title)
                                .bold()
                            Spacer()
                            Button(action: {showingSchedule.toggle()}) {
                                Image(systemName: showingSchedule ? "calendar" : "list.dash")
                            }
                        }
                        

                        if showingSchedule {
                            ScheduleListView(blockTimes: BlockTimes.blocksDay, blocks: ScheduleData.testMap, viewingIndex: $showingScheduleDay)
                        } else {
                            ScheduleView(blockTimes: BlockTimes.blocksDay, onDayTap: { showingScheduleDay = $0; showingSchedule = true })
                        }
                    }
                }
            }.padding()
        }
        .navigationBarTitle("South", displayMode: .inline)
        .navigationBarItems(trailing:
            Button {
                viewModel.selectedTab = 1
            } label: {
                ToolbarLogo()
            }
        )
    }
}

struct SocialView_Previews: PreviewProvider {
    static var previews: some View {
        SocialView()
    }
}

struct ScheduleData { // TEMPORARY
    var blocks: [BlockData]

    static let test = [
        BlockData(block: "A", courseName: "Math", roomNumber: "103", teacher: "Donovan K"),
        BlockData(block: "B", courseName: "Bio", roomNumber: "104", teacher: "Julia Yuru", status: .canceled),
        BlockData(block: "C", courseName: "Directed Study", roomNumber: "9000", teacher: "Samuel Adams")
    ]

    static var testMap: [String: BlockData] {
        Dictionary(uniqueKeysWithValues: self.test.map { ($0.block, $0) })
    }
}

struct BlockData: Identifiable {
    enum Status {
        case normal, canceled
    }

    var id = UUID()

    var block: String
    var courseName: String
    var roomNumber: String
    var teacher: String
    var status: Status = .normal
}

enum BlockTimes {
    static let blocksDay: [[BlockTime]] = [
        [
            BlockTime(block: "A", startTime: "9:35 AM", endTime: "10:35 AM")!,
            BlockTime(block: "B", startTime: "10:45 AM", endTime: "12:55 AM")!,
            BlockTime(block: "C", startTime: "1:05 PM", endTime: "2:25 PM")!,
            BlockTime(block: "D", startTime: "2:35 PM", endTime: "3:55 PM")!
        ],
        [
            BlockTime(block: "E", startTime: "9:35 AM", endTime: "10:35 AM")!,
            BlockTime(block: "F", startTime: "10:45 AM", endTime: "12:55 AM")!,
            BlockTime(block: "G", startTime: "1:05 PM", endTime: "2:25 PM")!,
            BlockTime(block: "Community", startTime: "2:35 PM", endTime: "3:05 PM")!,
            BlockTime(block: "Flex", startTime: "3:10 PM", endTime: "3:55 PM")!
        ],
        [
            BlockTime(block: "A", startTime: "9:15 AM", endTime: "10:25 AM")!,
            BlockTime(block: "B", startTime: "10:35 AM", endTime: "12:35 AM")!,
            BlockTime(block: "C", startTime: "12:45 PM", endTime: "1:55 PM")!,
            BlockTime(block: "D", startTime: "2:05 PM", endTime: "3:15 PM")!
        ],
        [
            BlockTime(block: "A", startTime: "9:35 AM", endTime: "10:35 AM")!,
            BlockTime(block: "B", startTime: "10:45 AM", endTime: "12:55 AM")!,
            BlockTime(block: "C", startTime: "1:05 PM", endTime: "2:25 PM")!,
            BlockTime(block: "D", startTime: "2:35 PM", endTime: "3:55 PM")!
        ],
        [
            BlockTime(block: "E", startTime: "9:35 AM", endTime: "10:35 AM")!,
            BlockTime(block: "F", startTime: "10:45 AM", endTime: "12:55 AM")!,
            BlockTime(block: "G", startTime: "1:05 PM", endTime: "2:25 PM")!,
            BlockTime(block: "Community", startTime: "2:35 PM", endTime: "3:05 PM")!,
            BlockTime(block: "Flex", startTime: "3:10 PM", endTime: "3:55 PM")!
        ]
    ]
    
    static let days: [String] = [
        "Monday",
        "Tuesday",
        "Wednesday",
        "Thursday",
        "Friday"
    ]

    static func getEarliestHour() -> Int {
        return
            self.blocksDay.flatMap { $0 }
                .min { lhs, rhs in lhs.startTime.isBeforeDate(rhs.startTime, granularity: .minute) }!.startTime.hour
    }

    static func getLatestHour() -> Int {
        let nearestTime = self.blocksDay.flatMap { $0 }
            .max { lhs, rhs in lhs.startTime.isBeforeDate(rhs.startTime, granularity: .minute) }!.startTime
        return nearestTime.minute > 0 ? nearestTime.hour + 1 : nearestTime.hour
    }
}

struct BlockTime: Identifiable {
    let block: String
    let startTime: DateInRegion
    let endTime: DateInRegion

    let id = UUID()

    init?(block: String, startTime: String, endTime: String) {
        self.block = block

        if let startTime = startTime.toDate("hh:mm a", region: .current), let endTime = endTime.toDate("hh:mm a", region: .current) {
            self.startTime = startTime
            self.endTime = endTime
        } else { return nil }
    }
}
