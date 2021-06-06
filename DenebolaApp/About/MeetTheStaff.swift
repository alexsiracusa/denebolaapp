//
//  MeetTheStaff.swift
//  DenebolaApp
//
//  Created by Alex Siracusa on 5/27/21.
//

import SwiftUI

struct MeetTheStaff: View {
    @EnvironmentObject private var handler: WordpressAPIHandler
    @State var aboutPost: Post? = nil

    var body: some View {
        ScrollView {
            if aboutPost != nil {
                ContentRenderer(htmlContent: aboutPost!.getHtmlContent())
                    .padding([.leading, .trailing])
            } else {
                Text("Loading")
                    .onAppear {
                        handler.loadPost(25274, embed: true) { post, _ in
                            aboutPost = post
                        }
                    }
            }
        }
    }
}

struct MeetTheStaff_Previews: PreviewProvider {
    static var previews: some View {
        MeetTheStaff()
            .environmentObject(WordpressAPIHandler())
    }
}
