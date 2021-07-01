//
//  LargeBlockView.swift
//  CypressApp
//
//  Created by Alex Siracusa on 6/28/21.
//

import SwiftUI

struct LargeBlockView: View {
    @EnvironmentObject var viewModel: ViewModelData
    @Environment(\.managedObjectContext) var moc

    let block: Block
    @State var fullBlock: BlockInfo?

    init(block: Block) {
        self.block = block
    }

    var body: some View {
        VStack(alignment: .leading) {
            if let fullBlock = fullBlock {
                HStack {
                    Text(fullBlock.classSubject ?? fullBlock.wrappedBlockName)
                        .font(.title)
                        .bold()
                        .foregroundColor(fullBlock.textColor)
                    Spacer()
                }
                Text("\(block.times.from) - \(block.times.to) (\(Int(block.times.length / 60)) minutes)")
                    .foregroundColor(fullBlock.textColor)
                HStack(alignment: .center) {
                    Image(systemName: "square.fill")
                    Text(block.data.name)
                }
                .frame(height: 40)
                .foregroundColor(fullBlock.textColor)
                .padding(.top, 5)

                if let room = fullBlock.roomNumber {
                    HStack(alignment: .center) {
                        Image(systemName: "house.fill")
                        Text(room)
                    }
                    .frame(height: 40)
                    .foregroundColor(fullBlock.textColor)
                }

                if fullBlock.teacherFirst != nil || fullBlock.teacherLast != nil {
                    HStack(alignment: .center) {
                        Image(systemName: "person.circle.fill")
                        if let last = fullBlock.teacherLast {
                            Text(last)
                        }
                        if let first = fullBlock.teacherFirst {
                            Text(first)
                        }
                    }
                    .frame(height: 40)
                    .foregroundColor(fullBlock.textColor)
                }
            } else {
                Text("")
            }
        }
        .padding()
        .background(fullBlock?.color.cornerRadius(15.0))
        .onAppear {
            let school = moc.getSchoolWith(id: Int64(viewModel.school.id))
            self.fullBlock = moc.getBlockWith(id: Int64(block.data.id), school: school)
        }
    }
}

struct LargeBlockView_Previews: PreviewProvider {
    static var previews: some View {
        LargeBlockView(block: Block.default)
            .environmentObject(ViewModelData.default)
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
