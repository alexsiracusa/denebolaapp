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

    func selectSchool() -> Promise<Void> {
        return firstly {
            self.retreiveCurrentSchoolFromDisk()
        }.then { school in
            self.loadSchoolData(school)
        }
        .done {
            self.loaded = .all
        }
        .recover { _ in // current school not selected, loading school list
            self.loadSchoolList()
                .done {
                    self.loaded = .list
                }
        }
    }

    func loadSchoolList() -> Promise<Void> {
        return ServerAPI.getSchools().done { schools in
            self.schools = schools
        }
    }

    // load all school data
    // calls loadSchool -> loadBlocks -> loadFullBlocks
    func loadSchoolData(_ school: School, useCache: Bool = true, retry: Bool = true) -> Promise<Void> {
        loadingSchool = school.id

        var loadedConfig: SchoolConfig?
        var loadedBlocks: [BlockData]?
        var loadedFullBlocks: [Int: FullBlock]?

        return getConfig(school: school, useCache: useCache, shouldRetry: retry).then { config -> Promise<[BlockData]> in
            loadedConfig = config

            return self.getBlocks(school: school, useCache: useCache, shouldRetry: retry)
        }
        .then { blocks -> Promise<[Int: FullBlock]> in
            loadedBlocks = blocks

            return self.getFullBlocks(school: school, with: blocks)
        }.then { fullBlocks -> Promise<Void> in
            loadedFullBlocks = fullBlocks

            return Promise()
        }.done {
            self.school = school
            self.config = loadedConfig
            self.blocks = loadedBlocks
            self.fullBlocks = loadedFullBlocks
            self.absences = nil
            self.year = nil

            self.reconcileLocalBlockDataWithServer()
            self.saveCurrentData(school).catch { error in
                print("Could not cache data! Reason: \(error)")
            }

            self.loaded = .all
        }.ensure {
            self.loadingSchool = nil
        }
    }

    func saveCurrentData(_ school: School) -> Promise<Void> {
        firstly {
            self.saveCurrentSchool(school: school)
        }.then {
            self.saveConfig(school: school)
        }.then {
            self.saveBlocks(school: school)
        }.then {
            self.saveFullBlocks(school: school)
        }
    }

    func getConfig(school: School, useCache: Bool = true, shouldRetry: Bool = true) -> Promise<SchoolConfig> {
        return school.getConfig(delay: 0.5, retryCount: 0, timeOut: 6.5).recover { _ -> Promise<SchoolConfig> in
            guard useCache else { return Promise { $0.reject("Cache is disabled") } }
            print("checking disk")
            return self.retreiveConfigDataFromDisk(school: school)
        }.recover { error -> Promise<SchoolConfig> in
            print("disk failed")
            print(error.localizedDescription)

            let retryCount = shouldRetry ? UInt.max : 0
            let timeOut = shouldRetry ? 20.0 : 0.0
            return school.getConfig(delay: 2.5, retryCount: retryCount, timeOut: timeOut)
        }
    }

    func getBlocks(school: School, useCache: Bool = true, shouldRetry: Bool = true) -> Promise<[BlockData]> {
        return school.getCourses(delay: 0.5, retryCount: 0, timeOut: 3.5).recover { _ -> Promise<[BlockData]> in
            guard useCache else { return Promise { $0.reject("Cache is disabled") } }
            print("checking disk")
            return self.retrieveBlockDataFromDisk(school: school)
        }.recover { error -> Promise<[BlockData]> in
            print("disk failed")
            print(error.localizedDescription)

            let retryCount = shouldRetry ? UInt.max : 0
            let timeOut = shouldRetry ? 20.0 : 0.0
            return school.getCourses(delay: 2.5, retryCount: retryCount, timeOut: timeOut)
        }
    }

    /// Attempt to retrieve FullBlock data from the disk. If failed, create and save new default block data and retrieve that.
    func getFullBlocks(school: School, with blocks: [BlockData]) -> Promise<[Int: FullBlock]> {
        return retrieveFullBlockDataFromDisk(school: school).recover { error -> Guarantee<[Int: FullBlock]> in
            print("Could not retrieve data from disk! Recreating data. Reason: \(error)")
            return self.createBlockData(from: blocks)
        }
    }

    /// Compares locally saved data with the fetched server data and sets onServer for the block
    func reconcileLocalBlockDataWithServer() {
        for block in blocks {
            if let fullBlock = fullBlocks[block.id] {
                fullBlock.name = block.name
                fullBlock.onServer = true
            } else {
                fullBlocks[block.id] = FullBlock(id: block.id, name: block.name, onServer: true)
            }
        }
        for (_, fullBlock) in fullBlocks {
            if !blocks.contains(where: { serverBlock in serverBlock.id == fullBlock.id }) {
                fullBlock.onServer = false
            }
        }
    }

    func loadAbsences() -> Promise<Void> {
        guard absences == nil else { return Promise() }
        return firstly {
            school.getLatestAbsences()
        }.done { absences in
            self.absences = absences
        }
    }

    func loadSchoolYear() -> Promise<Void> {
        guard year == nil else { return Promise { $0.reject("Year is already loaded") } }
        return firstly {
            school.getLatestYear()
        }.map { year in
            self.year = year
        }
    }

    /// Retrieves FullBlock data from the disk
    func retrieveFullBlockDataFromDisk(school: School) -> Promise<[Int: FullBlock]> {
        return Promise { seal in
            let fullBlocks = try Disk.retrieve(fullBlockSavePath(school: school), from: .documents, as: [Int: FullBlock].self)
            seal.fulfill(fullBlocks)
        }
    }

    /// Creates new FullBlock data from the server fetched-block data.
    func createBlockData(from blocks: [BlockData]) -> Guarantee<[Int: FullBlock]> {
        return Guarantee { seal in
            seal(blocks.reduce(into: [Int: FullBlock]()) { $0[$1.id] = FullBlock(id: $1.id, name: $1.name, onServer: true) })
        }
    }

    func retrieveBlockDataFromDisk(school: School) -> Promise<[BlockData]> {
        return Promise { seal in
            let blocks = try Disk.retrieve(blockSavePath(school: school), from: .caches, as: [BlockData].self)
            seal.fulfill(blocks)
        }
    }

    func retreiveConfigDataFromDisk(school: School) -> Promise<SchoolConfig> {
        return Promise { seal in
            let config = try Disk.retrieve(configSavePath(school: school), from: .caches, as: SchoolConfig.self)
            seal.fulfill(config)
        }
    }

    func retreiveCurrentSchoolFromDisk() -> Promise<School> {
        return Promise { seal in
            let school = try Disk.retrieve(currentSchoolSavePath(), from: .documents, as: School.self)
            seal.fulfill(school)
        }
    }
}
