//
//  ModelLoading.swift
//  CypressApp
//
//  Created by Alex Siracusa on 7/1/21.
//

import Alamofire
import Disk
import Foundation
// import PromiseKit

extension ViewModelData {
    // 1st initial loading for picker
    func loadSchoolList(completion: @escaping (AFError?) -> Void) {
        ServerAPI.getSchools { result in
            switch result {
            case let .success(schools):
                self.schools = schools
                self.loaded = .list
                completion(nil)
            case let .failure(error):
                completion(error)
            }
        }
    }

    // load all school data
    // calls loadSchool -> loadBlocks -> loadFullBlocks
    func loadSchoolData(_ school: School, completion: @escaping (Error?) -> Void) {
        // would be real cool to have async await for this
        loadSchool(school) { error in
            guard error == nil else {
                completion(error); return
            }
            self.loadBlocks(school) { error in
                guard error == nil else {
                    completion(error); return
                }
                self.loadFullBlocks(school, blocks: self.blocks) { error in
                    guard error == nil else {
                        completion(error); return
                    }
                    // fully loaded
                    DispatchQueue.main.async {
                        self.loaded = .all
                    }
                    completion(nil)
                }
            }
        }
    }

    private func loadSchool(_ school: School, completion: @escaping (AFError?) -> Void) {
        school.getConfig { result in
            switch result {
            case let .success(config):
                self.school = school
                self.config = config
                self.tabManager = TabManager(config.allTabs(modelData: self))
                completion(nil)
            case let .failure(error):
                completion(error)
            }
        }
    }

    private func loadBlocks(_ school: School, completion: @escaping (AFError?) -> Void) {
        school.blocks { result in
            switch result {
            case let .success(blocks):
                self.blocks = blocks
                completion(nil)
            case let .failure(error):
                completion(error)
            }
        }
    }

    func loadFullBlocks(_ school: School, blocks: [BlockData], completion: @escaping (NSError?) -> Void) {
        let path = "schools/\(school.id)/fullBlocks.json"
        if Disk.exists(path, in: .documents) {
            updateFullBlockData(school, blocks: blocks) { result in
                switch result {
                case let .success(fullBlocks):
                    DispatchQueue.main.async {
                        self.fullBlocks = fullBlocks.reduce(into: [Int: FullBlock]()) { $0[$1.id] = $1 }
                    }
                    completion(nil)
                case let .failure(error):
                    completion(error)
                }
            }
        } else {
            createFullBlockData(school, blocks: blocks) { result in
                switch result {
                case let .success(fullBlocks):
                    DispatchQueue.main.async {
                        self.fullBlocks = fullBlocks.reduce(into: [Int: FullBlock]()) { $0[$1.id] = $1 }
                    }
                    completion(nil)
                case let .failure(error):
                    completion(error)
                }
            }
        }
    }

    func updateFullBlockData(_ school: School, blocks: [BlockData], completion: @escaping (Result<[FullBlock], NSError>) -> Void) {
        let path = "schools/\(school.id)/fullBlocks.json"

        DispatchQueue.global(qos: .userInitiated).async {
            do {
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
                print(path)
                completion(.success(fullBlocks))
            } catch let error as NSError {
                print(error.localizedDescription)
                completion(.failure(error))
            }
        }
    }

    func createFullBlockData(_ school: School, blocks: [BlockData], completion: @escaping (Result<[FullBlock], NSError>) -> Void) {
        let path = "schools/\(school.id)/fullBlocks.json"
        let fullBlocks = blocks.map { FullBlock(id: $0.id, name: $0.name, onServer: true) }

        DispatchQueue.global(qos: .userInitiated).async {
            do {
                try Disk.save(fullBlocks, to: .documents, as: path)
                print(path)
                completion(.success(fullBlocks))
            } catch let error as NSError {
                print(error.localizedDescription)
                completion(.failure(error))
            }
        }
    }
}
