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
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 0) {
                        VStack {
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
                        .padding(.bottom, 40)

                        Group {
                            Text("Cancelled Classes")
                                .font(.title)
                                .bold()
                                .padding(.vertical, 5)

                            CancelledList(list: CancelledBlock.test, width: reader.size.width * 0.4)
                        }
                    }
                }
                .padding(.horizontal)
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
    enum CancelledType {
        case partial
        case full
    }

    let id = UUID()
    
    let teacher: Teacher
    let cancelledType: CancelledType
    let remarks: String

    static let test: [CancelledBlock] = [
        CancelledBlock(teacher: Teacher(firstName: "ARANSKY", lastName: "AMY"), cancelledType: .full, remarks: "E, F cancelled, in-person to library, check Schoology for update"),
        CancelledBlock(teacher: Teacher(firstName: "ASTONE", lastName: "ELIZABETH"), cancelledType: .full, remarks: ""),
        CancelledBlock(teacher: Teacher(firstName: "BEUTEL", lastName: "DAVID"), cancelledType: .full, remarks: "Classes canceled. In person students to library."),
        CancelledBlock(teacher: Teacher(firstName: "BUSHEY", lastName: "ANNEMARIE"), cancelledType: .full, remarks: ""),
        CancelledBlock(teacher: Teacher(firstName: "CallAHAN", lastName: "LAURIE"), cancelledType: .full, remarks: ""),
        CancelledBlock(teacher: Teacher(firstName: "CASSELL", lastName: "FAYE"), cancelledType: .full, remarks: ""),
        CancelledBlock(teacher: Teacher(firstName: "CULPEPPER", lastName: "SARAH"), cancelledType: .full, remarks: "E block and Community canceled (go to the library)"),
        CancelledBlock(teacher: Teacher(firstName: "CURLEY", lastName: "JOHN"), cancelledType: .full, remarks: ""),
        CancelledBlock(teacher: Teacher(firstName: "CURRAN", lastName: "LUCIA"), cancelledType: .full, remarks: ""),
        CancelledBlock(teacher: Teacher(firstName: "Curtis", lastName: "Kimberly"), cancelledType: .full, remarks: "E, G, Community Cancelled, go to library"),
        CancelledBlock(teacher: Teacher(firstName: "DEPARI", lastName: "CHRISTINE"), cancelledType: .full, remarks: ""),
        CancelledBlock(teacher: Teacher(firstName: "DINSMORE", lastName: "ANN"), cancelledType: .full, remarks: ""),
        CancelledBlock(teacher: Teacher(firstName: "DRUREY", lastName: "SUZY"), cancelledType: .full, remarks: "F,G blocks cancelled to library, 3rd lunch, Advisory to Gym B"),
        CancelledBlock(teacher: Teacher(firstName: "GABOVITCH", lastName: "NAOMI"), cancelledType: .partial, remarks: ""),
        CancelledBlock(teacher: Teacher(firstName: "Gallagher", lastName: "Talia"), cancelledType: .full, remarks: "F Block cancelled, go to the library and take 3rd lunch"),
        CancelledBlock(teacher: Teacher(firstName: "HAHN", lastName: "DEBORAH"), cancelledType: .partial, remarks: "Morning absence only. F block in-person students to Library. F block students check Schoology for assignments. G block and Community WILL be held in person."),
        CancelledBlock(teacher: Teacher(firstName: "HENDERSON", lastName: "KELLY"), cancelledType: .full, remarks: "E and G canceled - in person folks go to library."),
        CancelledBlock(teacher: Teacher(firstName: "HURLEY", lastName: "GABRIELLE"), cancelledType: .full, remarks: ""),
        CancelledBlock(teacher: Teacher(firstName: "KNOEDLER", lastName: "JEFFREY"), cancelledType: .full, remarks: "E block canceled report to library"),
        CancelledBlock(teacher: Teacher(firstName: "KOBAYASHI", lastName: "DIANNA"), cancelledType: .full, remarks: "E Block and Community canceled. Report to library."),
        CancelledBlock(teacher: Teacher(firstName: "LEWIS", lastName: "AARON"), cancelledType: .full, remarks: ""),
        CancelledBlock(teacher: Teacher(firstName: "MCNallY", lastName: "RACHAEL"), cancelledType: .full, remarks: "Wed. FLEX Power History - see Schoology for instructions :-)"),
        CancelledBlock(teacher: Teacher(firstName: "MEDEIROS", lastName: "JAMES"), cancelledType: .full, remarks: ""),
        CancelledBlock(teacher: Teacher(firstName: "MOSBROOKER", lastName: "MICHAEL"), cancelledType: .full, remarks: "Classes/community cancelled report to library"),
        CancelledBlock(teacher: Teacher(firstName: "MOYER", lastName: "allISON"), cancelledType: .partial, remarks: "E-block is canceled - go to room 6268. Contact Mr. Foster if you need assistance."),
        CancelledBlock(teacher: Teacher(firstName: "PALILUNAS", lastName: "ALEXANDER"), cancelledType: .full, remarks: "G Block and Community Remote report to library"),
        CancelledBlock(teacher: Teacher(firstName: "PAPPAS", lastName: "MEGAN"), cancelledType: .full, remarks: ""),
        CancelledBlock(teacher: Teacher(firstName: "RAUBACH", lastName: "THOMAS"), cancelledType: .full, remarks: "F block and Commmunity canceled (Library) / FLEX on Zoom"),
        CancelledBlock(teacher: Teacher(firstName: "ROBERTSON", lastName: "JEANNETTE"), cancelledType: .full, remarks: "all classes below are in room 2306: F Block (10th Honors English):cancelled, to library, 3rd lunchG Block (Seniors-Women in Lit): cancelled, go to library or go homeCommunity (10th): cancelled; go to library or go home.Flex: cancelled"),
        CancelledBlock(teacher: Teacher(firstName: "ROTATORI", lastName: "ALAN"), cancelledType: .full, remarks: ""),
        CancelledBlock(teacher: Teacher(firstName: "SHOREY", lastName: "CARA"), cancelledType: .full, remarks: "all classes cancelled, report to library. E, F, G Blocks see Weekly Learning Plan."),
        CancelledBlock(teacher: Teacher(firstName: "SPEZIALE", lastName: "DANIELLA"), cancelledType: .full, remarks: "E block Cancelled class G block Cancelled classReport to Library"),
        CancelledBlock(teacher: Teacher(firstName: "STYLE", lastName: "SARAH"), cancelledType: .full, remarks: ""),
        CancelledBlock(teacher: Teacher(firstName: "BUREN", lastName: "ALEXANDRA"), cancelledType: .full, remarks: "G Block and Community Cancelled report to library"),
        CancelledBlock(teacher: Teacher(firstName: "WEINTRAUB", lastName: "DAVID"), cancelledType: .full, remarks: "Community canceled. G-Block students should work on their projects report to library"),



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
            Circle()
                .foregroundColor(cancelled.cancelledType == .full ? .red : .yellow)
                .frame(width: 10, height: 10)
            
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
            switch cancelled.cancelledType {
                case .full:
                    Text("All Blocks Cancelled")
                        .foregroundColor(.secondary)
                case .partial:
                    Text(cancelled.remarks)
                        .foregroundColor(.secondary)
            }
        }
    }
}
