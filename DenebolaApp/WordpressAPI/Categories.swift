////
////  Categories.swift
////  DenebolaApp
////
////  Created by Alex Siracusa on 5/2/21.
////
//
//import Foundation
//import SwiftUI
//
//enum Categories: RawRepresentable, CaseIterable {
//    case arts
//    case photo_gallery
//    case videos
//    case news
//    case club_directory
//    case features
//    case humans_of_south
//    case opinions
//    case procrastinate_here
//    case sports
//    case athlete_of_the_week
//    case multimedia
//
//    var id: Int {
//        return self.rawValue.0
//    }
//
//    var name: String {
//        return self.rawValue.1
//    }
//
//    var image: Image {
//        return self.rawValue.2
//    }
//    
//    var banner: Image {
//        return self.rawValue.3
//    }
//
//    var rawValue: (Int, String, Image, Image) {
//        switch self {
//        case .arts: return (2, "Arts", Image("DenebolaLogo"), Image("DenebolaBanner"))
//        case .photo_gallery: return (55, "Photos", Image("DenebolaLogo"), Image("DenebolaBanner"))
//        case .videos: return (14, "Videos", Image("DenebolaLogo"), Image("DenebolaBanner"))
//        case .news: return (6, "News", Image("DenebolaLogo"), Image("DenebolaBanner"))
//        case .club_directory: return (371, "Clubs", Image("DenebolaLogo"), Image("DenebolaBanner"))
//        case .features: return (255, "Features", Image("DenebolaLogo"), Image("DenebolaBanner"))
//        case .humans_of_south: return (657, "South", Image("DenebolaLogo"), Image("DenebolaBanner"))
//        case .opinions: return (7, "Opinions", Image("DenebolaLogo"), Image("DenebolaBanner"))
//        case .procrastinate_here: return (182, "Procrastinate", Image("DenebolaLogo"), Image("DenebolaBanner"))
//        case .sports: return (10, "Sports", Image("DenebolaLogo"), Image("DenebolaBanner"))
//        case .athlete_of_the_week: return (399, "Athlete", Image("DenebolaLogo"), Image("DenebolaBanner"))
//        case .multimedia: return (164, "Multimedia", Image("DenebolaLogo"), Image("DenebolaBanner"))
//        }
//    }
//
//    init?(rawValue: (Int, String, Image, Image)) {
//        self = .opinions
//    }
//}
