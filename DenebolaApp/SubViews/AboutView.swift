//
//  AboutView.swift
//  DenebolaApp
//
//  Created by Connor Tam on 5/27/21.
//

import SwiftUI

private let TAB_NAMES = ["About", "Meet The Staff", "Submit Idea"]

struct AboutView: View {
    @EnvironmentObject private var handler: APIHandler

    @State private var aboutPost: Post? = Post.default
    @State private var currentPage = TAB_NAMES[0]

    @State private var offset: CGFloat = 0
    @State private var width: CGFloat = 0

    @ViewBuilder private func AboutView() -> some View {
        if let post = aboutPost {
            ScrollView {
                ContentRenderer(htmlContent: post.getHtmlContent())
            }
        } else {
            Text("Loading... \(aboutPost.debugDescription)")
        }
    }

    @ViewBuilder private func Underline() -> some View {
        Rectangle()
            .frame(height: 2)
            .frame(width: width)
            .foregroundColor(.accentColor)
            .padding(.leading, offset)
    }

    var body: some View {
        VStack {
            HStack(alignment: .top) {
                Spacer()
                ForEach(TAB_NAMES, id: \.self) { name in
                    VStack(spacing: 0) {
                        Text(name)
                            .foregroundColor(.accentColor)
                            .overlay(MoveUnderlineButton(offset: $offset, width: $width, onPressed: {
                                currentPage = name
                            }))
                    }

                    Spacer()
                }
            }
            .overlay(Underline(), alignment: .bottomLeading)
            .coordinateSpace(name: "container")
            .animation(.spring())

            TabView(selection: $currentPage) {
                Text("""
                Named after one of the brightest stars in the Leo constellation, Denebola is Newton South High School’s official online newspaper. Converting from a print publication in 2012, Denebola possesses a storied heritage of award-winning news reporting that caters to South students and Newton community members alike. With sections ranging from school news to sports to our proprietary “Procrastinate Here” section, we strive to provide reliable, informative, and relative news and entertainment to the Newton community and beyond.

                Denebola has a single, unifying goal: To represent you, a fellow student at South. As an extracurricular club, Denebola aims to highlight students in school activities and to highlight our communities accomplishments as well as give students a voice.

                Since converting to online, Denebola has been recognized for:
                2013 NSPA Pacemaker award winner
                Featured in NSPA 19 “Best of High School Press”
                2013, 2014, 2015, 2016 and 2017 first place in “Excellence in Online Journalism” from Suffolk University
                2014, 2015, 2016, 2018, 2019 – first place in “ALL – New England” in journalism from the New England Scholastic Press Association
                2015 & 2021 “Highest Achievement” in journalism from the New England Scholastic Press Association
                2016 NSPA “Best in Show” 10th Place
                2017 NSPA “Best in Show” 6th Place
                2018 & 2019 Honorable Mention in “Excellence in Online Journalism” – Suffolk University

                And for a variety of individual awards:
                MASPA – Feature Photo of the Year (First place, 2018); Sports Photo of the Year (Third Place, 2018), Online Video of the Year (Second Place, 2018)
                """).padding()
                    .tag(TAB_NAMES[0])

                AboutView()
                    .tag(TAB_NAMES[1])

                ScrollView {
                    ContentRenderer(url: "https://docs.google.com/forms/d/e/1FAIpQLSeSz4MLlH9YAeXSaROQWMoW1NKdKoTJaXXyWy2QADKA-v8STQ/viewform?c=0&w=1".asURL)
                }
                .tag(TAB_NAMES[2])
            }
            .tabViewStyle(PageTabViewStyle())
        }
        .padding()
        .onAppear {
            handler.loadPost(25274, embed: false, completionHandler: { post, _ in
                guard let post = post else { return }
                aboutPost = post
            })
        }
    }

    private struct MoveUnderlineButton: View {
        @Binding var offset: CGFloat
        @Binding var width: CGFloat
        var onPressed: () -> Void

        var body: some View {
            GeometryReader { geometry in
                Button(action: {
                    self.offset = geometry.frame(in: .named("container")).minX
                    self.width = geometry.size.width
                    onPressed()
                }) {
                    Rectangle().foregroundColor(.clear)
                }
            }
        }
    }
}

struct AboutView_Previews: PreviewProvider {
    static var previews: some View {
        AboutView()
    }
}
