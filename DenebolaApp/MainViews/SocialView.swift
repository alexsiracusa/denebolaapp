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
            GeometryReader { reader in
                ScrollView(/*@START_MENU_TOKEN@*/ .vertical/*@END_MENU_TOKEN@*/, showsIndicators: false) {
                    VStack(alignment: .leading) {
                        Group {
                            HStack {
                                Text("Your Schedule")
                                    .font(.title)
                                    .bold()
                                    .padding(.vertical, 5)
                                Spacer()
                                Button(action: { showingSchedule.toggle() }) {
                                    Image(systemName: showingSchedule ? "calendar" : "list.dash")
                                }
                            }

                            if showingSchedule {
                                ScheduleListView(blockTimes: BlockTimes.blocksDay, blocks: ScheduleData.testMap, viewingIndex: $showingScheduleDay)
                            } else {
                                ScheduleView(blockTimes: BlockTimes.blocksDay, onDayTap: { showingScheduleDay = $0; showingSchedule = true })
                            }
                        }

                        Group {
                            Text("Cancelled Classes")
                                .font(.title)
                                .bold()
                                .padding(.vertical, 5)

                            CancelledList(list: CancelledBlock.test, width: reader.size.width * 0.5)
                        }
                    }
                }
                .padding()
            }
            .navigationBarTitle("South", displayMode: .inline)
            .navigationBarItems(trailing: LogoButton())
        }
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
        BlockData(block: "A", courseName: "Honors Precalculus", roomNumber: "4207", teacher: "Culpepper, Sarah"),
        BlockData(block: "B", courseName: "Honors Biology (Lab)", roomNumber: "2102", teacher: "Estrada, Molly; McLaren, James", status: .canceled),
        BlockData(block: "C", courseName: "Honors Junior English", roomNumber: "2304", teacher: "Arnaboldi, Dana"),
        BlockData(block: "D", courseName: "Honors Chinese 5", roomNumber: "6116", teacher: "Chen, Lan Lan"),
        BlockData(block: "E", courseName: "U.S. History ACP", roomNumber: "1306", teacher: "Kozuch, Michael"),
        BlockData(block: "F", courseName: "Junior and Senior Wellness", roomNumber: "5138", teacher: "Aransky, Amy"),
        BlockData(block: "G", courseName: "Honors Intro iOS Program Swift", roomNumber: "7107", teacher: "Stulin, Jeffrey")
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

struct CancelledBlock: Identifiable {
    enum BlocksCancelled {
        case specific([String])
        case all
    }

    let id = UUID()

    let teacher: Teacher
    let blocks: BlocksCancelled

    static let test: [CancelledBlock] = [
        CancelledBlock(teacher: Teacher(firstName: "ELIZABETH", lastName: "ASTONE"), blocks: .all),
        CancelledBlock(teacher: Teacher(firstName: "DAVID", lastName: "BEUTEL"), blocks: .all),
        CancelledBlock(teacher: Teacher(firstName: "ANNEMARIE", lastName: "BUSHEY"), blocks: .all),
        CancelledBlock(teacher: Teacher(firstName: "LAURIE", lastName: "CALLAHAN"), blocks: .all),
        CancelledBlock(teacher: Teacher(firstName: "FAYE", lastName: "CASSELL"), blocks: .all),
        CancelledBlock(teacher: Teacher(firstName: "SARAH", lastName: "CULPEPPER"), blocks: .all),
        CancelledBlock(teacher: Teacher(firstName: "JOHN", lastName: "CURLEY"), blocks: .all),
        CancelledBlock(teacher: Teacher(firstName: "LUCIA", lastName: "CURRAN"), blocks: .all),
        CancelledBlock(teacher: Teacher(firstName: "Kimberly", lastName: "Curtis"), blocks: .specific(["E", "G", "Community"])),
        CancelledBlock(teacher: Teacher(firstName: "CHRISTINE", lastName: "DEPARI"), blocks: .all),
        CancelledBlock(teacher: Teacher(firstName: "ANN", lastName: "DINSMORE"), blocks: .all),
        CancelledBlock(teacher: Teacher(firstName: "SUZY", lastName: "DRUREY"), blocks: .all),
        CancelledBlock(teacher: Teacher(firstName: "NAOMI", lastName: "GABOVITCH"), blocks: .all),
        CancelledBlock(teacher: Teacher(firstName: "Talia", lastName: "Gallagher"), blocks: .all),
        CancelledBlock(teacher: Teacher(firstName: "DEBORAH", lastName: "HAHN"), blocks: .all),
        CancelledBlock(teacher: Teacher(firstName: "KELLY", lastName: "HENDERSON"), blocks: .all),
        CancelledBlock(teacher: Teacher(firstName: "GABRIELLE", lastName: "HURLEY"), blocks: .all),
        CancelledBlock(teacher: Teacher(firstName: "JEFFREY", lastName: "KNOEDLER"), blocks: .all),
        CancelledBlock(teacher: Teacher(firstName: "DIANNA", lastName: "KOBAYASHI"), blocks: .all),
        CancelledBlock(teacher: Teacher(firstName: "CATERINA MARIA", lastName: "LEONE"), blocks: .all),
        CancelledBlock(teacher: Teacher(firstName: "AARON", lastName: "LEWIS"), blocks: .all),
        CancelledBlock(teacher: Teacher(firstName: "RACHAEL", lastName: "MCNALLY"), blocks: .all),
        CancelledBlock(teacher: Teacher(firstName: "JAMES", lastName: "MEDEIROS"), blocks: .all),
        CancelledBlock(teacher: Teacher(firstName: "MICHAEL", lastName: "MOSBROOKER"), blocks: .all),
        CancelledBlock(teacher: Teacher(firstName: "ALLISON", lastName: "MURFIN MOYER"), blocks: .all),
        CancelledBlock(teacher: Teacher(firstName: "ALEXANDER", lastName: "PALILUNAS"), blocks: .all),
        CancelledBlock(teacher: Teacher(firstName: "MEGAN", lastName: "PAPPAS"), blocks: .all),
        CancelledBlock(teacher: Teacher(firstName: "THOMAS", lastName: "RAUBACH"), blocks: .all),
        CancelledBlock(teacher: Teacher(firstName: "JEANNETTE", lastName: "ROBERTSON"), blocks: .all),
        CancelledBlock(teacher: Teacher(firstName: "ALAN", lastName: "ROTATORI"), blocks: .all),
        CancelledBlock(teacher: Teacher(firstName: "CARA", lastName: "SHOREY"), blocks: .all),
        CancelledBlock(teacher: Teacher(firstName: "DANIELLA", lastName: "SPEZIALE"), blocks: .all),
        CancelledBlock(teacher: Teacher(firstName: "SARAH", lastName: "STYLE"), blocks: .all),
        CancelledBlock(teacher: Teacher(firstName: "ALEXANDRA", lastName: "VAN BUREN"), blocks: .all),
        CancelledBlock(teacher: Teacher(firstName: "DAVID", lastName: "WEINTRAUB"), blocks: .all)
    ]
}

struct Teacher: Identifiable {
    let id = UUID()

    let firstName: String
    let lastName: String
}

struct CancelledList: View {
    let list: [CancelledBlock]
    let width: CGFloat

    @State var alertShown = false
    @State var selectedBlock: CancelledBlock? = nil

    func getTextForSelectedBlock() -> Text {
        switch self.selectedBlock!.blocks {
            case .specific(let blocks):
                return Text(blocks.joined(separator: ", "))
            case .all:
                return Text("All Blocks")
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            ForEach(list) { cancelled in

                CancelledRow(cancelled: cancelled, width: width)

                Divider()
            }
        }
    }
}

struct CancelledRow: View {
    @State private var showingMore = false
    let cancelled: CancelledBlock
    let width: CGFloat

    var body: some View {
        HStack(alignment: .center) {
            Text(cancelled.teacher.lastName.uppercased())
                .frame(width: width, height: 0, alignment: .leading)
            Text(cancelled.teacher.firstName.uppercased())

            Spacer()

            Image(systemName: showingMore ? "chevron.down" : "chevron.right")
        }
        .onTapGesture {
            showingMore.toggle()
        }

        if showingMore {
            switch cancelled.blocks {
                case .specific(let blocks):
                    Text(blocks.joined(separator: ", "))
                        .foregroundColor(.secondary)
                case .all:
                    Text("All Blocks")
                        .foregroundColor(.secondary)
            }
        }
    }
}
