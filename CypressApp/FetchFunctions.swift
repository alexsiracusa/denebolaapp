//
//  FetchFunctions.swift
//  CypressApp
//
//  Created by Alex Siracusa on 6/28/21.
//

import CoreData
import Foundation
import SwiftUI

// stolen from https://stackoverflow.com/questions/51869261/save-json-to-coredata-as-string-and-use-the-string-to-create-array-of-objects

extension NSManagedObjectContext {
    public func saveAsyncIfNeeded() {
        guard hasChanges else { return }
        DispatchQueue.main.async {
            try? self.save()
        }
    }

    func delete(_ entity: String) {
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        let delete = NSBatchDeleteRequest(fetchRequest: fetch)
        try? persistentStoreCoordinator!.execute(delete, with: self)
        try? save()
    }

    func createSchool(school: School, blocks: [BlockData]) -> SchoolData {
        let schoolData = SchoolData(context: self)
        schoolData.id = Int64(school.id)
        schoolData.name = school.name
        for block in blocks {
            let blockInfo = BlockInfo(context: self)
            blockInfo.blockName = block.name
            blockInfo.colorHex = UIColor.lightGray.hexString()
            blockInfo.id = Int64(block.id)
            blockInfo.school = schoolData
            blockInfo.onServer = true
        }
        try? save()
        return schoolData
    }

    func updateSchool(school: SchoolData, blocks: [BlockData]) {
        for block in school.blockArray {
            if let fromServer = blocks.first(where: { $0.id == block.id }) {
                block.blockName = fromServer.name
                block.onServer = true
            } else {
                block.onServer = false
            }
        }
        try? save()
    }

    func getSchoolWith(id: Int64) -> SchoolData? {
        let requested = NSFetchRequest<SchoolData>(entityName: "SchoolData")
        requested.predicate = NSPredicate(format: "id == %d", id)
        do {
            let fetched = try fetch(requested)

            // fetched is an array we need to convert it to a single object
            if fetched.count > 1 {
                // TODO: handle duplicate records
            } else {
                return fetched.first // only use the first object..
            }
        } catch {
            let nserror = error as NSError
            // TODO: Handle error
            print(nserror.description)
        }

        return nil
    }

    func deleteSchoolWith(id: Int64) -> Bool {
        let success: Bool = true

        let requested = NSFetchRequest<SchoolData>(entityName: "SchoolData")
        requested.predicate = NSPredicate(format: "id == %d", id)

        do {
            let fetched = try fetch(requested)
            for school in fetched {
                for block in school.blockArray {
                    delete(block)
                }
                delete(school)
            }
            return success
        } catch {
            let nserror = error as NSError
            // TODO: Handle Error
            print(nserror.description)
        }

        return !success
    }

    func deleteAllSchools() {
        do {
            let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "SchoolData")
            let deleteALL = NSBatchDeleteRequest(fetchRequest: deleteFetch)

            try execute(deleteALL)
            try save()
        } catch {
            print("There is an error in deleting records")
        }
    }

    func getAllSchools() -> [SchoolData] {
        let all = NSFetchRequest<SchoolData>(entityName: "SchoolData")
        var allSchools = [SchoolData]()

        do {
            let fetched = try fetch(all)
            allSchools = fetched
        } catch {
            let nserror = error as NSError
            // TODO: Handle Error
            print(nserror.description)
        }

        return allSchools
    }

    func getBlockWith(id: Int64, school: SchoolData?) -> BlockInfo? {
        guard let school = school else { return nil }
        let requested = NSFetchRequest<BlockInfo>(entityName: "BlockInfo")
        requested.predicate = NSPredicate(format: "id == %d && school == %@", id, school)
        do {
            let fetched = try fetch(requested)

            // fetched is an array we need to convert it to a single object
            if fetched.count > 1 {
                // TODO: handle duplicate records
            } else {
                return fetched.first // only use the first object..
            }
        } catch {
            let nserror = error as NSError
            // TODO: Handle error
            print(nserror.description)
        }

        return nil
    }
}
