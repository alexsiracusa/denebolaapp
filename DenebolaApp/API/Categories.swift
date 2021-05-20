//
//  Categories.swift
//  DenebolaApp
//
//  Created by Alex Siracusa on 5/2/21.
//

import Foundation
import SwiftUI

enum Categories: RawRepresentable, CaseIterable {
    case arts
    case photo_gallery
    case videos
    case news
    case club_directory
    case features
    case humans_of_south
    case opinions
    case procrastinate_here
    case sports
    case athlete_of_the_week
    case multimedia

    var id: Int {
        return self.rawValue.0
    }

    var name: String {
        return self.rawValue.1
    }

    var image: Image {
        return self.rawValue.2
    }

    var rawValue: (Int, String, Image) {
        switch self {
        case .arts: return (2, "Arts", Image("DenebolaLogo"))
        case .photo_gallery: return (55, "Photos", Image("DenebolaLogo"))
        case .videos: return (14, "Videos", Image("DenebolaLogo"))
        case .news: return (6, "News", Image("DenebolaLogo"))
        case .club_directory: return (371, "Clubs", Image("DenebolaLogo"))
        case .features: return (255, "Features", Image("DenebolaLogo"))
        case .humans_of_south: return (657, "South", Image("DenebolaLogo"))
        case .opinions: return (7, "Opinions", Image("DenebolaLogo"))
        case .procrastinate_here: return (182, "Procrastinate", Image("DenebolaLogo"))
        case .sports: return (10, "Sports", Image("DenebolaLogo"))
        case .athlete_of_the_week: return (399, "Athlete", Image("DenebolaLogo"))
        case .multimedia: return (164, "Multimedia", Image("DenebolaLogo"))
        }
    }

    init?(rawValue: (Int, String, Image)) {
        self = .opinions
    }
}
