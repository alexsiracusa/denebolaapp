//
//  BlockInfo+CoreDataProperties.swift
//  CypressApp
//
//  Created by Alex Siracusa on 6/27/21.
//
//

import CoreData
import Foundation
import SwiftUI

public extension BlockInfo {
    @nonobjc class func fetchRequest() -> NSFetchRequest<BlockInfo> {
        return NSFetchRequest<BlockInfo>(entityName: "BlockInfo")
    }

    @NSManaged var blockName: String?
    @NSManaged var id: Int64
    @NSManaged var classSubject: String?
    @NSManaged var colorHex: String?
    @NSManaged var roomNumber: String?
    @NSManaged var teacherFirst: String?
    @NSManaged var teacherLast: String?
    @NSManaged var onServer: Bool
    @NSManaged var school: SchoolData?

    var wrappedBlockName: String {
        return blockName ?? "-"
    }

    var wrappedClassSubject: String {
        return classSubject ?? "-"
    }

    var color: Color {
        return Color(UIColor(hex: colorHex ?? ""))
    }

    var textColor: Color {
        return UIColor(hex: colorHex ?? "").textColor
    }

    var wrappedRoomNumber: String {
        return roomNumber ?? "-"
    }

    var wrappedTeacherFirstName: String {
        return teacherFirst ?? "-"
    }

    var wrappedTeacherLastName: String {
        return teacherLast ?? "-"
    }

    internal static var `default`: BlockInfo {
        let block = BlockInfo()
        block.blockName = "A"
        block.classSubject = "Math"
        block.colorHex = UIColor.red.hexString()
        block.id = 0
        block.roomNumber = "1102"
        return block
    }
}

extension BlockInfo: Identifiable {}
