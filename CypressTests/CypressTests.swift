//
//  CypressTests.swift
//  CypressTests
//
//  Created by Connor Tam on 6/17/21.
//

@testable import Cypress
import XCTest

class CypressTests: XCTestCase {
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }

    func testExtractArticle() throws {
        let expectation = self.expectation(description: "Request")

        extractArticleFromUrl(url: try! "https://nshsdenebola.com/2021-22-schedule-everything-you-need-to-know/".asURL()) {
            let result = (try? $0.get()!)!
            XCTAssert(result.head.starts(with: "<head>"))
            XCTAssert(result.scripts.starts(with: "<script>"))
            expectation.fulfill()
        }

        waitForExpectations(timeout: 5, handler: nil)
    }
}
