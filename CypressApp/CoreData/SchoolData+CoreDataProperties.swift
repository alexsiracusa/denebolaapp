//
//  SchoolData+CoreDataProperties.swift
//  CypressApp
//
//  Created by Alex Siracusa on 6/27/21.
//
//

import CoreData
import Foundation

public extension SchoolData {
    @nonobjc class func fetchRequest() -> NSFetchRequest<SchoolData> {
        return NSFetchRequest<SchoolData>(entityName: "SchoolData")
    }

    @NSManaged var id: Int64
    @NSManaged var name: String?
    @NSManaged var blocks: NSSet?

    var wrappedName: String {
        return name ?? "Unknown"
    }

    var blockArray: [BlockInfo] {
        let set = blocks as? Set<BlockInfo> ?? []

        return set.sorted {
            $0.wrappedBlockName < $1.wrappedBlockName
        }
    }

    func blockWith(id: Int64) -> BlockInfo? {
        return blocks?.first(where: { ($0 as? BlockInfo)?.id == id }) as? BlockInfo
    }
}

// MARK: Generated accessors for blocks

public extension SchoolData {
    @objc(addBlocksObject:)
    @NSManaged func addToBlocks(_ value: BlockInfo)

    @objc(removeBlocksObject:)
    @NSManaged func removeFromBlocks(_ value: BlockInfo)

    @objc(addBlocks:)
    @NSManaged func addToBlocks(_ values: NSSet)

    @objc(removeBlocks:)
    @NSManaged func removeFromBlocks(_ values: NSSet)
}

extension SchoolData: Identifiable {}
