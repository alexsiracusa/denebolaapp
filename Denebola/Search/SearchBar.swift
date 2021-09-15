//
//  SearchBar.swift
//  DenebolaApp
//
//  Created by Alex Siracusa on 5/22/21.
//

import SwiftUI

struct SearchBar: View {
    @ObservedObject var loader: IncrementalLoader<WordpressSearchLoader>

    @State var searchFor: String = ""
    @Binding var updateSearch: String
    @State var isEditing = false

    var body: some View {
        HStack(spacing: 0) {
            HStack(spacing: 0) {
                TextField(
                    "Search",
                    text: $searchFor
                ) { isEditing in
                    withAnimation {
                        self.isEditing = isEditing
                    }
                } onCommit: {
                    updateSearch = searchFor
                }
            }
            .background(
                Rectangle()
                    .foregroundColor(Color.gray)
                    .brightness(0.37)
                    .frame(height: 35)
                    .cornerRadius(10)
                    .padding([.leading, .trailing], -10)
            )
            if isEditing {
                Button {
                    searchFor = updateSearch
                    UIApplication.shared.endEditing()
                } label: {
                    Text("Cancel")
                        .foregroundColor(.blue)
                }
                .transition(.move(edge: .trailing))
                .padding(.leading, 20)
            }
        }
        .onAppear {
            self.searchFor = loader.pageLoader.searchTerm
        }
        .padding([.leading, .trailing], 20)
        .background(
            Rectangle()
                .fill(Color.white)
                .frame(height: 50)
        )
        .frame(height: 50)
    }
}

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

struct SearchBar_Previews: PreviewProvider {
    static var previews: some View {
        SearchBar(loader: IncrementalLoader(WordpressSearchLoader(Wordpress.default)), updateSearch: .constant(""))
    }
}
