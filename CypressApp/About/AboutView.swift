//
//  AboutView.swift
//  DenebolaApp
//
//  Created by Connor Tam on 5/27/21.
//

import SwiftUI

private let TAB_NAMES = ["About", "Meet The Staff", "Submit Idea"]

struct AboutView: View {
    //@EnvironmentObject private var handler: WordpressAPIHandler
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var viewModel: ViewModelData

    @State private var currentPage = TAB_NAMES[0]

    @State private var offset: CGFloat = 0
    @State private var width: CGFloat = 0

    @ViewBuilder private func Underline() -> some View {
        Rectangle()
            .frame(height: 1)
            .frame(width: width)
            .foregroundColor(.accentColor)
            .padding(.leading, offset)
    }

    var body: some View {
        VStack(spacing: 0) {
            VStack(spacing: 0) {
                HStack(alignment: .top) {
                    Spacer()
                    ForEach(TAB_NAMES, id: \.self) { name in

                        Button(action: {
                            currentPage = name
                        }) {
                            Text(name)
                                .foregroundColor(.accentColor)
                                .overlay(
                                    // Watch for page change and update offset/width
                                    GeometryReader { reader in

                                        Spacer().onChange(of: currentPage) { _ in
                                            if currentPage == name {
                                                self.offset = reader.frame(in: .named("container")).minX
                                                self.width = reader.size.width
                                            }
                                        }
                                    }
                                )
                        }

                        Spacer()
                    }
                }
                .padding([.top, .bottom], 13)
                Divider()
            }
            .overlay(Underline(), alignment: .bottomLeading)
            .coordinateSpace(name: "container")
            .animation(.spring())

            TabView(selection: $currentPage) {
                AboutText()
                    .tag(TAB_NAMES[0])

                MeetTheStaff()
                    .tag(TAB_NAMES[1])
                    //.environmentObject(handler)

                ScrollView {
                    ContentRenderer(url: try! "https://docs.google.com/forms/d/e/1FAIpQLSeSz4MLlH9YAeXSaROQWMoW1NKdKoTJaXXyWy2QADKA-v8STQ/viewform?c=0&w=1".asURL())
                }
                .tag(TAB_NAMES[2])
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
        }
        .navigationBarTitle("About", displayMode: .inline)
        .navigationBarItems(
            trailing:
            Button {
                presentationMode.wrappedValue.dismiss()
            } label: {
                Logo(url: viewModel.selectedWordpress.logoURL)
            }
        )
    }
}

struct AboutView_Previews: PreviewProvider {
    static var previews: some View {
        AboutView()
            //.environmentObject(WordpressAPIHandler())
            .environmentObject(ViewModelData())
    }
}
