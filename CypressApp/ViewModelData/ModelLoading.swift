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
        return ServerAPI.getSchools().done { schools in
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

            return self.getFullBlocks()
        }.then { fullBlocks throws -> Promise<Void> in
            self.fullBlocks = fullBlocks
            self.reconcileLocalBlockDataWithServer()

            return self.saveBlocks()
        }.done { _ in
            self.loaded = .all
        }
    }

    /// Attempt to retrieve FullBlock data from the disk. If failed, create and save new default block data and retrieve that.
    func getFullBlocks() -> Promise<[Int: FullBlock]> {
        return retrieveFullBlockDataFromDisk().recover { error -> Guarantee<[Int: FullBlock]> in
            print("Could not retrieve data from disk! Recreating data. Reason: \(error)")
            return self.createBlockData()
        }
    }

    /// Compares locally saved data with the fetched server data and sets onServer for the block
    func reconcileLocalBlockDataWithServer() {
        for (_, fullBlock) in fullBlocks {
            if let matchingBlock = blocks.first(where: { serverBlock in serverBlock.id == fullBlock.id }) {
                fullBlock.name = matchingBlock.name
                fullBlock.onServer = true
            } else {
                fullBlock.onServer = false
            }
        }
    }

    /// Retrieves FullBlock data from the disk
    func retrieveFullBlockDataFromDisk() -> Promise<[Int: FullBlock]> {
        return Promise { seal in
            let fullBlocks = try Disk.retrieve(getFullBlockSavePath(), from: .documents, as: [Int: FullBlock].self)
            seal.fulfill(fullBlocks)
        }
    }

    /// Creates new FullBlock data from the server fetched-block data.
    func createBlockData() -> Guarantee<[Int: FullBlock]> {
        return Guarantee { seal in
            seal(blocks.reduce(into: [Int: FullBlock]()) { $0[$1.id] = FullBlock(id: $1.id, name: $1.name, onServer: true) })
        }
    }
}
