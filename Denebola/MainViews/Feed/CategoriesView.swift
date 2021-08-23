//
//  CategoriesView.swift
//  DenebolaApp
//
//  Created by Alex Siracusa on 5/2/21.
//

import SwiftUI

struct CategoriesView: View {
    @EnvironmentObject var viewModel: ViewModelData
    var currentSite: Wordpress! {
        viewModel.currentSite
    }

    var sites: [Wordpress]! {
        viewModel.sites
    }

    @State var displayPicker = false

    var body: some View {
        ScrollView(.vertical) {
            VStack(alignment: .leading) {
                Button {
                    displayPicker = true
                } label: {
                    SiteBanner(imageURL: currentSite.bannerURL)
                }
                .buttonStyle(ScaleButton())
                .disabled(sites.count == 1)
                .padding([.leading, .trailing], 15)

                CategoriesList(site: viewModel.currentSite)

                Spacer()
                    .frame(height: 15)

                Text("Latest Posts")
                    .font(.headline)
                    .padding(.leading)

                Spacer()
                    .frame(height: 5)

                PostFeed(site: viewModel.currentSite)
            }
            .padding(.top, 10)
            .padding(.bottom, 15)
        }
        .navigationBarTitle("Feed", displayMode: .inline)
        .navigationBarItems(
            trailing:
            HStack(spacing: 15) {
                NavigationLink(destination:
                    SearchView(site: currentSite)
                ) {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.black)
                }
                SiteLogo(url: currentSite.logoURL)
            }
        )
        .sheet(isPresented: $displayPicker) {
            WordpressPicker(show: $displayPicker)
        }
    }
}

struct CategoriesView_Previews: PreviewProvider {
    static var previews: some View {
        CategoriesView()
            .environmentObject(ViewModelData.default)
    }
}
