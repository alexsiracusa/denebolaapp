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
    @EnvironmentObject var siteImages: SiteImages

    @State var sites: [Wordpress]
    @State var currentURL: String = ""
    @State var currentSite: Wordpress? = nil
    
    @State var displayPicker = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                if let site = currentSite {
                    VStack(alignment: .leading) {
                        Button {
                            displayPicker = true
                        } label: {
                            SiteBanner(site: site)
                        }
                        CategoriesList(categories: site.featuredCategoriesWithImage)
                        Spacer(minLength: 15)
                        Text("Latest Posts")
                            .font(.headline)
                            .padding(.leading)
                        
                        Spacer(minLength: 15)
                        
                        PostFeed(domain: site.url)
                    }
                    .padding(.top, 10)
                    .padding(.bottom, 15)
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
                    if let site = currentSite {
                        LogoButton(url: site.logoURL!)
                    }
                }
            )
        }
        .onAppear {
            load()
            updateWordpress()
        }
        .sheet(isPresented: $displayPicker) {
            ScrollView {
                VStack(spacing: 15) {
                    ForEach(sites) { site in
                        Button {
                            currentSite = site
                            displayPicker = false
                        } label: {
                            SiteBanner(site: site)
                        }
                    }
                }
                .padding([.top, .bottom])
            }
            .pickerStyle(MenuPickerStyle())
        }
        .onChange(of: currentSite, perform: { value in
            updateWordpress()
        })
    }
    
    func updateWordpress() {
        guard let site = currentSite else {return}
        handler.domain = site.url
        currentURL = site.url
        if let url = URL(string: site.defaultImage.url) {
            siteImages.defaultImageURL = url
        }
        if let url = URL(string: site.logo.url) {
            siteImages.logoURL = url
        }
    }
    
    func load() {
        if sites.count > 0 && currentSite == nil {
            currentSite = sites[0]
        }
    }
}

struct CategoriesView_Previews: PreviewProvider {
    static var previews: some View {
        CategoriesView(sites: [Wordpress.default, Wordpress.default])
            .environmentObject(WordpressAPIHandler())
            .environmentObject(SiteImages())
    }
}
