//
//  PostContentViewer.swift
//  CypressApp
//
//  Created by Connor Tam on 6/17/21.
//

import SwiftUI

struct PostContentView: View {
    let post: Post

    @State private var html: String? = nil
    @State private var error: String? = nil
    @State private var isLoading: Bool = false

    var body: some View {
        VStack {
            //  Display post body if it exists, or the error
            if let html = html {
                ContentRenderer(htmlContent: html, baseURL: post.getDomain())
            } else if let error = error {
                Text(error)
            } else {
                DefaultLoader()
                    .scaleEffect(0.1)
            }
        }.onAppear {
            guard !isLoading else { return }

            post.getHtmlContent { result in
                switch result {
                case let .success(html):
                    self.html = html
                case let .failure(error):
                    self.error = error.localizedDescription
                }
            }
        }
    }
}

struct PostContentViewer_Previews: PreviewProvider {
    static var previews: some View {
        PostContentView(post: Post.default)
    }
}
