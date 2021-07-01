//
//  ScheduleSettings.swift
//  CypressApp
//
//  Created by Alex Siracusa on 6/26/21.
//

import CoreData
import SwiftUI

struct ScheduleSettings: View {
    @EnvironmentObject var viewModel: ViewModelData
    @Environment(\.managedObjectContext) var moc

    @State var school: SchoolData?

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 15) {
                if let school = school {
                    ForEach(school.blockArray, id: \.self) { block in
                        BlockEditor(block: block)
                    }
                } else {
                    ForEach(0 ..< 3) { _ in
                        LoadingBlockEditor()
                    }
                }

                Button {
                    moc.delete("SchoolData")
                    moc.delete("BlockInfo")
                } label: {
                    Text("Delete All")
                }
            }
        }
        .navigationBarTitle("Blocks", displayMode: .inline)
        .onAppear {
            DispatchQueue.global(qos: .userInitiated).async {
                if let school = moc.getSchoolWith(id: Int64(viewModel.school.id)) {
                    moc.updateSchool(school: school, blocks: viewModel.blocks)
                    self.school = school
                } else {
                    self.school = moc.createSchool(school: viewModel.school, blocks: viewModel.blocks)
                }
            }
        }
    }
}

struct ScheduleSettings_Previews: PreviewProvider {
    static var previews: some View {
        ScheduleSettings()
            .environmentObject(ViewModelData.default)
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
