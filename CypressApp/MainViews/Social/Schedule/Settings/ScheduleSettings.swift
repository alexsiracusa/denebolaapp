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

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 15) {
                if let fullBlocks = viewModel.fullBlocks {
                    ForEach(fullBlocks.sorted(by: <), id: \.key) { _, block in
                        BlockEditor(block: block)
                    }
                } else {
                    ForEach(0 ..< 3) { _ in
                        LoadingBlockEditor()
                    }
                }

                // for debug only
                Button {
                    viewModel.deleteAll()
                } label: {
                    Text("Delete All")
                }

                // for debug only
                Button {
                    viewModel.fullBlocks[-10] = FullBlock(id: -10, name: "Bad Block")
                } label: {
                    Text("Add bad block")
                }
            }
        }
        .navigationBarTitle("Blocks", displayMode: .inline)
        .onDisappear {
            viewModel.saveBlocks { error in
                if let error = error {
                    print(error.localizedDescription)
                }
            }
        }
    }
}

struct ScheduleSettings_Previews: PreviewProvider {
    static var previews: some View {
        ScheduleSettings()
            .environmentObject(ViewModelData.default)
    }
}
