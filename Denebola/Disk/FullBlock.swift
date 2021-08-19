//
//  FullBlock.swift
//  CypressApp
//
//  Created by Alex Siracusa on 7/1/21.
//

import Foundation
import SwiftUI
import UIKit

class FullBlock: Codable, ObservableObject, Comparable {
    @Published var id: Int
    @Published var name: String
    @Published var codableColor = CodableColor(uiColor: .gray)
    @Published var subject: String = ""
    @Published var room: String = ""
    @Published var teacherFirst: String = ""
    @Published var teacherLast: String = ""
    @Published var onServer: Bool = false

    var color: Color {
        return Color(codableColor.uiColor)
    }

    var textColor: Color {
        return codableColor.uiColor.textColor
    }

    init(id: Int, name: String, color: UIColor = UIColor.lightGray, subject: String = "", room: String = "", teacherFirst: String = "", teacherLast: String = "", onServer: Bool = false) {
        self.id = id
        self.name = name
        codableColor = CodableColor(uiColor: color)
        self.subject = subject
        self.room = room
        self.teacherFirst = teacherFirst
        self.teacherLast = teacherLast
        self.onServer = onServer
    }

    enum CodingKeys: CodingKey {
        case id, name, codableColor, subject, room, teacherFirst, teacherLast, onServer
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(codableColor, forKey: .codableColor)
        try container.encode(subject, forKey: .subject)
        try container.encode(room, forKey: .room)
        try container.encode(teacherFirst, forKey: .teacherFirst)
        try container.encode(teacherLast, forKey: .teacherLast)
        try container.encode(onServer, forKey: .onServer)
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        id = try container.decode(Int.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        codableColor = try container.decode(CodableColor.self, forKey: .codableColor)
        subject = try container.decode(String.self, forKey: .subject)
        room = try container.decode(String.self, forKey: .room)
        teacherFirst = try container.decode(String.self, forKey: .teacherFirst)
        teacherLast = try container.decode(String.self, forKey: .teacherLast)
        onServer = try container.decode(Bool.self, forKey: .onServer)
    }

    static func == (lhs: FullBlock, rhs: FullBlock) -> Bool {
        return lhs.id == rhs.id
    }

    static func < (lhs: FullBlock, rhs: FullBlock) -> Bool {
        return rhs.name < lhs.name
    }

    static var `default`: FullBlock {
        return FullBlock(id: 0, name: "A")
    }
}

struct CodableColor: Codable {
    var red: CGFloat = 0.0
    var green: CGFloat = 0.0
    var blue: CGFloat = 0.0
    var alpha: CGFloat = 0.0

    var uiColor: UIColor {
        return UIColor(red: red, green: green, blue: blue, alpha: alpha)
    }

    init(uiColor: UIColor) {
        uiColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
    }
}
