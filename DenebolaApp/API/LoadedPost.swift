//
//  LoadedPost.swift
//  DenebolaApp
//
//  Created by Alex Siracusa on 5/2/21.
//

import Foundation
import SwiftUI

struct LoadedPost: Identifiable {
    var id: Int { post.id }
    let post: Post
    let author: String
    let media: Media
    var image: Image?
}
