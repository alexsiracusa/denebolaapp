//
//  MultimediaView.swift
//  DenebolaApp
//
//  Created by Alex Siracusa on 5/2/21.
//

import SwiftUI

struct MultimediaView: View {
    @EnvironmentObject private var viewModel: ViewModelData
    
    var body: some View {
        NavigationView {
            ScrollView {
                Text("Multimedia")
                    .padding()
            }
                .navigationBarTitle("Multimedia", displayMode: .inline)
                .navigationBarItems(trailing:
                    Button {
                        viewModel.selectedTab = 1
                    } label: {
                        ToolbarLogo()
                    }
                )
        }
    }
}

struct MultimediaView_Previews: PreviewProvider {
    static var previews: some View {
        MultimediaView()
    }
}
