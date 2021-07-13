//
//  ServerAPITests.swift
//  CypressTests
//
//  Created by Alex Siracusa on 6/19/21.
//

import Alamofire
@testable import Cypress
import Disk
import XCTest
let SERVER_TEST_URL = "https://cypress.sequal.xyz"

class ServerAPITests: XCTestCase {
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func doGet<T: Decodable>(endpoint: String, of: T.Type = T.self) {
        let expectation = self.expectation(description: "Request")

        AF.request("\(SERVER_TEST_URL)\(endpoint)", method: .get, interceptor: Retry()).validate().responseDecodable(of: of) { response in
            if let error = response.error {
                XCTFail(error.localizedDescription)
            }
            expectation.fulfill()
        }

        waitForExpectations(timeout: 5, handler: nil)
    }

    func testAbsences() {
        doGet(endpoint: "/schools/0/absences/2021-06-17", of: [Absence].self)
    }

    func testBlocks() {
        doGet(endpoint: "/schools/0/schedule/blocks", of: [BlockData].self)
    }

    func testGetWeek() {
        doGet(endpoint: "/schools/0/schedule/weeks/2021-06-21", of: Week.self)
    }

    func testConfig() {
        doGet(endpoint: "/schools/0/config", of: SchoolConfig.self)
    }

    func testSchoolList() {
        doGet(endpoint: "/schools", of: [School].self)
    }

    func testSchoolYear() {
        doGet(endpoint: "/schools/0/schedule/years/latest", of: SchoolYear.self)
    }
}
