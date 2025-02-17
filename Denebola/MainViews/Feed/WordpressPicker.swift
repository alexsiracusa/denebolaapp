//
//  WordpressPicker.swift
//  CypressApp
//
//  Created by Alex Siracusa on 7/28/21.
//

import SwiftUI

struct WordpressPicker: View {
    @EnvironmentObject private var viewModel: ViewModelData
    @Binding var show: Bool

    var body: some View {
        ScrollView {
            VStack(spacing: 15) {
                ForEach(viewModel.sites) { site in
                    Button {
                        viewModel.currentSite = site
                        show = false
                    } label: {
                        SiteBanner(imageURL: site.bannerURL)
                    }
                    .buttonStyle(ScaleButton())
                }
                .padding(.horizontal)
            }
            .padding([.top, .bottom])
        }
    }
}

struct WordpressPicker_Previews: PreviewProvider {
    static var previews: some View {
        WordpressPicker(show: .constant(true))
            .environmentObject(ViewModelData.default)
    }
}
