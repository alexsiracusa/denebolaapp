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

    var body: some View {
        NavigationView {
            ScrollView(/*@START_MENU_TOKEN@*/ .vertical/*@END_MENU_TOKEN@*/, showsIndicators: false) {
                VStack(alignment: .leading) {
                    Group {
                        Text("Your Schedule")
                            .font(.title)
                            .bold()

                        HStack {
                            Text("Monday")
                            Spacer()
                            Image(systemName: "arrow.left")
                            Image(systemName: "arrow.right")
                        }.padding(.bottom, 15)

                        VStack(alignment: .leading, spacing: 10) {
                            ForEach(ScheduleData.test) { block in
                                HStack(alignment: .top) {
                                    Text(block.block)
                                        .bold()
                                        .padding(.trailing, 5)

                                    VStack(alignment: .leading) {
                                        HStack {
                                            switch block.status {
                                                case .normal:
                                                    Text(block.courseName)
                                                case .canceled:
                                                    HStack {
                                                        Text(block.courseName)
                                                            .strikethrough(color: .red)
                                                        Text("Cancelled")
                                                            .foregroundColor(.red)
                                                    }
                                            }
                                        }
                                        HStack {
                                            Text(block.teacher)
                                            Spacer()
                                            Text(block.roomNumber)
                                        }
                                    }
                                }

                                Divider()
                            }
                        }
                    }

                    Group {
                        Text("Friends")
                            .font(.title)
                            .bold()
                        ForEach(FriendData.testData) { friend in
                            NavigationLink(
                                destination: /*@START_MENU_TOKEN@*/Text("Destination")/*@END_MENU_TOKEN@*/
                            ) {
                                VStack(alignment: .leading) {
                                    Text(friend.name)
                                        .bold()
                                    Text(friend.getCurrentClass())
                                }
                            }
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

private struct ScheduleData { // TEMPORARY
    var blocks: [BlockData]

    static let test = [
        BlockData(block: "A", courseName: "Math", roomNumber: "103", teacher: "Donovan K"),
        BlockData(block: "B", courseName: "Bio", roomNumber: "104", teacher: "Julia Yuru", status: .canceled),
        BlockData(block: "C", courseName: "Directed Study", roomNumber: "9000", teacher: "Samuel Adams")
    ]
}

private struct BlockData: Identifiable {
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

private struct BlockTimes {
    let days: [[BlockTime]] = [
        [
            BlockTime(block: "A", time: "9:35")!
        ]
    ]
}

private struct BlockTime {
    let block: String
    let time: DateInRegion

    init?(block: String, time: String) {
        self.block = block

        if let time = time.toDate("HH:MM", region: .current) {
            self.time = time
        } else { return nil }
    }
}

private struct FriendData: Identifiable {
    static let testData = [
        FriendData(id: 0, name: "Alex Damn", schedule: [])
    ]

    var id: Int

    var name: String
    var schedule: [[BlockData]]

    func getCurrentClass() -> String {
        return "PLACEHOLDER"
    }
}
