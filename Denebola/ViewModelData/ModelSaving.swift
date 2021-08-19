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
    func schoolPath(school: School) -> String {
        return "schools/\(school.id)/"
    }

    func fullBlockSavePath(school: School) -> String {
        return schoolPath(school: school) + "fullBlocks.json"
    }

    func currentSchoolSavePath() -> String {
        return "user/currentSchool.json"
    }

    func saveFullBlocks(school: School) -> Promise<Void> {
        return Promise { seal in
            try Disk.save(self.fullBlocks, to: .documents, as: fullBlockSavePath(school: school))
            seal.fulfill()
        }
    }

    func saveCurrentSchool(school _: School) -> Promise<Void> {
        return Promise { seal in
            try Disk.save(self.school, to: .documents, as: currentSchoolSavePath())
            seal.fulfill()
        }
    }

    func deleteAll() {
        // for debug only
        try? Disk.clear(.documents)
        try? Disk.clear(.caches)
    }
}
