//
//  CategoriesView.swift
//  DenebolaApp
//
//  Created by Alex Siracusa on 5/2/21.
//

import SwiftUI

struct CategoriesView: View {
    @EnvironmentObject var handler: WordpressAPIHandler
    @EnvironmentObject private var viewModel: ViewModelData
    @EnvironmentObject var defaultImage: DefaultImage

    @State var sites: [Wordpress]
    @State var currentURL: String = ""
    @State var currentSite: Wordpress? = nil
    
    init(sites: [Wordpress]) {
        self.sites = sites
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                Picker("Current Site:", selection: $currentSite) {
                    ForEach(sites) { site in
                        Text(site.name)
                            .tag(site as Wordpress?)
                    }
                }
                .onChange(of: currentSite, perform: { value in
                    updateWordpress()
                })
                .pickerStyle(MenuPickerStyle())
                if let site = currentSite {
                    VStack(alignment: .leading) {
                        CategoriesList(categories: site.featuredCategoriesWithImage)
                        
                        Spacer(minLength: 15)

                        Text("Latest Posts")
                            .font(.headline)
                            .padding(.leading)
                        
                        Spacer(minLength: 15)
                        
                        PostFeed(domain: site.url)
                    }
                    .padding([.top, .bottom], 15)
                } else {
                    Text("There are no sites for this school")
                }
            }
            .navigationBarTitle("Feed", displayMode: .inline)
            .navigationBarItems(
                trailing:
                HStack(spacing: 15) {
                    NavigationLink(destination:
                        SearchView(domain: handler.domain)
                    ) {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.black)
                    }
                    LogoButton()
                }
            )
        }
        .onAppear {
            load()
            updateWordpress()
        }
    }
    
    func updateWordpress() {
        guard let site = currentSite else {return}
        handler.domain = site.url
        currentURL = site.url
        if let url = URL(string: site.defaultImage.url) {
            defaultImage.imageURL = url
        }
    }
    
    func load() {
        if sites.count > 0 {
            currentSite = sites[0]
        }
    }
}

struct CategoriesView_Previews: PreviewProvider {
    static var previews: some View {
        CategoriesView(sites: [Wordpress.default, Wordpress.default])
            .environmentObject(WordpressAPIHandler())
            .environmentObject(DefaultImage())
    }
}
