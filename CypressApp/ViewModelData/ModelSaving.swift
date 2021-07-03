//
//  ModelSaving.swift
//  CypressApp
//
//  Created by Alex Siracusa on 7/1/21.
//

import Disk
import Foundation
import PromiseKit

extension ViewModelData {
    func getFullBlockSavePath() -> String {
        return "schools/\(school.id)/fullBlocks.json"
    }

    func saveBlocks() -> Promise<Void> {
        let fullBlocks = self.fullBlocks.values.map { $0 } as [FullBlock]

        return Promise { seal in
            try Disk.save(fullBlocks, to: .documents, as: getFullBlockSavePath())
            seal.fulfill(())
        }
    }

    func deleteAll() {
        // for debug only
        try? Disk.clear(.documents)
    }
}
