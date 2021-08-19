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
            }
        }
        .navigationBarTitle("Blocks", displayMode: .inline)
        .onDisappear {
            viewModel.saveFullBlocks(school: viewModel.school).catch { error in
                print(error.localizedDescription)
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
