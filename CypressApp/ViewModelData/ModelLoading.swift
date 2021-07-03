//
//  ModelLoading.swift
//  CypressApp
//
//  Created by Alex Siracusa on 7/1/21.
//

import Alamofire
import Disk
import Foundation
import PromiseKit

extension ViewModelData {
    // 1st initial loading for picker
    func loadSchoolList() -> Promise<Void> {
        return ServerAPI.getSchools().done {schools in
            self.loaded = .list
            self.schools = schools
        }
    }

    // load all school data
    // calls loadSchool -> loadBlocks -> loadFullBlocks
    func loadSchoolData(_ school: School) -> Promise<Void> {
        self.school = school

        return school.getConfig().then { config -> Promise<[BlockData]> in
            self.config = config
            self.tabManager = TabManager(config.allTabs(modelData: self))

            return school.getBlocks()
        }.then { blocks -> Promise<[Int: FullBlock]> in
            self.blocks = blocks
            return self.getFullBlocks(school, blocks: blocks)
        }.done { fullBlocks in
            self.fullBlocks = fullBlocks
            self.loaded = .all
        }
    }

    /// Attempt to retrieve FullBlock data from the disk. If failed, create and save new default block data and retrieve that.
    func getFullBlocks(_ school: School, blocks: [BlockData]) -> Promise<[Int: FullBlock]> {
        return self.retrieveFullBlockDataFromDisk(school, blocks: blocks).recover {error -> Promise<[FullBlock]> in
            print("Could not retrieve data from disk! Recreating data. Reason: \(error)")
            return self.createBlockDataInDisk(school, blocks: blocks)
        }.map {
            $0.reduce(into: [Int: FullBlock]()) { $0[$1.id] = $1 }
        }
    }

    /// Retrieves FullBlock data from the disk, and compares the stored data to the server
    func retrieveFullBlockDataFromDisk(_ school: School, blocks: [BlockData]) -> Promise<[FullBlock]> {
        let path = "schools/\(school.id)/fullBlocks.json"

        return Promise { seal in
            let fullBlocks = try Disk.retrieve(path, from: .documents, as: [FullBlock].self)
            let blockDict = blocks.reduce(into: [Int: String]()) { $0[$1.id] = $1.name }
            
            fullBlocks.forEach { block in
                if let name = blockDict[block.id] {
                    block.name = name
                    block.onServer = true
                } else {
                    block.onServer = false
                }
            }

            try Disk.save(fullBlocks, to: .documents, as: path)

            seal.fulfill(fullBlocks)
        }
    }

    /// Creates new FullBlock data from the server fetched-block data and stores it.
    func createBlockDataInDisk(_ school: School, blocks: [BlockData]) -> Promise<[FullBlock]> {
        let path = "schools/\(school.id)/fullBlocks.json"
        let fullBlocks = blocks.map { FullBlock(id: $0.id, name: $0.name, onServer: true) }

        return Promise { seal in
            try Disk.save(fullBlocks, to: .documents, as: path)
            seal.fulfill(fullBlocks)
        }
    }
}
