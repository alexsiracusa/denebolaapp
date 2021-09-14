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
        return Promise { seal in
            if school != nil {
                seal.fulfill()
            }
            firstly {
                self.retreiveCurrentSchoolFromDisk()
            }.then { school in
                self.loadSchoolData(school, infiniteRetry: true)
            }.done {
                seal.fulfill()
            }.catch { _ in
                self.loadSchoolList().then { _ -> Promise<Void> in
                    if let school = self.schools.first(where: { $0.id == 0 }) {
                        return self.loadSchoolData(school, infiniteRetry: true)
                    } else {
                        self.loaded = .list
                        return Promise()
                    }
                }.done {
                    seal.fulfill()
                }.catch { error in
                    seal.reject(error)
                }
            }
        }
    }

    func loadSchoolList() -> Promise<Void> {
        return ServerAPI.getSchools().perform().done { schools in
            self.schools = schools
        }
    }

    // load all school data
    // calls loadSchool -> loadBlocks -> loadFullBlocks
    func loadSchoolData(_ school: School, infiniteRetry: Bool) -> Promise<Void> {
        guard loadingSchool == nil else { return Promise { $0.reject("Already loading") }}

        loadingSchool = school.id

        var loadedConfig: SchoolConfig?
        var loadedBlocks: [BlockData]?
        var loadedFullBlocks: [Int: FullBlock]?

        return school.getConfig().perform(maxRetry: infiniteRetry ? Int.max : 1).then { config -> Promise<[BlockData]> in
            loadedConfig = config

            return school.getCourses().perform()
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
            self.launching = false
        }.ensure {
            self.loadingSchool = nil
        }
    }

    func saveCurrentData(_ school: School) -> Promise<Void> {
        firstly {
            self.saveCurrentSchool(school: school)
        }.then {
            self.saveFullBlocks(school: school)
        }
    }

    func loadAbsences() -> Promise<Void> {
        return school.getLatestAbsences().perform().done { absences in
            self.absences = absences
        }
    }

    func loadSchoolYear() -> Promise<Void> {
        guard year == nil else { return Promise { $0.fulfill() } }
        return school.getLatestYear().perform().done { year in
            self.year = year
        }
    }

    func loadPodcast(_ podcast: Podcast) -> Promise<Void> {
        guard !isPodcastLoaded(podcast) else { return Promise { $0.fulfill() } }
        return Promise { seal in
            RSSLoader.loadPodcast(podcast.rssUrl).done { loaded in
                self.loadedPodcasts[podcast.id] = loaded
                seal.fulfill()
            }.catch { error in
                seal.reject(error)
            }
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

    /// Retrieves FullBlock data from the disk
    private func retrieveFullBlockDataFromDisk(school: School) -> Promise<[Int: FullBlock]> {
        return Promise { seal in
            let fullBlocks = try Disk.retrieve(fullBlockSavePath(school: school), from: .documents, as: [Int: FullBlock].self)
            seal.fulfill(fullBlocks)
        }
    }

    /// Creates new FullBlock data from the server fetched-block data.
    private func createBlockData(from blocks: [BlockData]) -> Guarantee<[Int: FullBlock]> {
        return Guarantee { seal in
            seal(blocks.reduce(into: [Int: FullBlock]()) { $0[$1.id] = FullBlock(id: $1.id, name: $1.name, onServer: true) })
        }
    }

    private func retreiveCurrentSchoolFromDisk() -> Promise<School> {
        return Promise { seal in
            let school = try Disk.retrieve(currentSchoolSavePath(), from: .documents, as: School.self)
            seal.fulfill(school)
        }
    }
}
