//
//  CategoriesView.swift
//  DenebolaApp
//
//  Created by Alex Siracusa on 5/2/21.
//

import SwiftUI

struct CategoriesView: View {
    // @EnvironmentObject var handler: WordpressAPIHandler
    @EnvironmentObject private var viewModel: ViewModelData
    @State var sites: [Wordpress]
    
    @State var displayPicker = false
    
    var body: some View {
        let wordpress = viewModel.selectedWordpress!
        
        NavigationView {
            ScrollView {
                VStack(alignment: .leading) {
                    Button {
                        displayPicker = true
                    } label: {
                        SiteBanner(imageURL: wordpress.bannerURL)
                    }
                    .disabled(sites.count == 1)
                    .padding([.leading, .trailing], 15)
                    
                    CategoriesList()
                    Spacer(minLength: 15)
                    
                    Text("Latest Posts")
                        .font(.headline)
                        .padding(.leading)
                        
                    Spacer(minLength: 15)
                        
                    PostFeed(site: wordpress)
                }
                .padding(.top, 10)
                .padding(.bottom, 15)
            }
            .navigationBarTitle("Feed", displayMode: .inline)
            .navigationBarItems(
                trailing:
                HStack(spacing: 15) {
                    NavigationLink(destination:
                        SearchView(site: wordpress)
                    ) {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.black)
                    }
                    LogoButton(url: wordpress.logoURL)
                }
            )
        }
        .sheet(isPresented: $displayPicker) {
            ScrollView {
                VStack(spacing: 15) {
                    ForEach(sites) { site in
                        Button {
                            viewModel.selectedWordpress = site
                            displayPicker = false
                        } label: {
                            SiteBanner(imageURL: site.bannerURL)
                        }
                    }
                    .padding(.horizontal)
                }
                .padding([.top, .bottom])
            }
        }
    }
}

struct CategoriesView_Previews: PreviewProvider {
    static var previews: some View {
        CategoriesView(sites: [Wordpress.default, Wordpress.default])
            // .environmentObject(WordpressAPIHandler())
            .environmentObject(ViewModelData())
    }
}
