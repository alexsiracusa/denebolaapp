//
//  ModelSaving.swift
//  CypressApp
//
//  Created by Alex Siracusa on 7/1/21.
//

import Disk
import Foundation

extension ViewModelData {
    func saveBlocks(completion: @escaping (NSError?) -> Void) {
        let fullBlocks = self.fullBlocks.values.map { $0 } as [FullBlock]
        let path = "schools/\(school.id)/fullBlocks.json"
        DispatchQueue.global(qos: .userInitiated).async {
            do {
                try Disk.save(fullBlocks, to: .documents, as: path)
                print(path)
                completion(nil)
            } catch let error as NSError {
                print(error.localizedDescription)
                completion(error)
            }
        }
    }

    func deleteAll() {
        // for debug only
        try? Disk.clear(.documents)
    }
}
