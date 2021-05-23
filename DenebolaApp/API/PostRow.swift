//
//  PostRow.swift
//  DenebolaApp
//
//  Created by Alex Siracusa on 5/2/21.
//

import Foundation

struct PostRow: Identifiable {
    let id: Int
    let title: String
    let author: String?
    let date: String
    let fullImageURL: URL?
    let thumbnailImageURL: URL?
    let hasMedia: Bool
}
