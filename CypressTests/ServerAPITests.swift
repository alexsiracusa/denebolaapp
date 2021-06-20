//
//  ServerAPITests.swift
//  CypressTests
//
//  Created by Alex Siracusa on 6/19/21.
//

@testable import Cypress
import XCTest
import Alamofire
let SERVER_TEST_URL = "https://cypress.sequal.xyz"

class ServerAPITests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testAbsences() {
        let expectation = self.expectation(description: "Request")
        
        AF.request("\(SERVER_TEST_URL)/schools/0/absences", method: .get, interceptor: Retry()).validate().responseDecodable(of: [Absence].self) { response in
            print(response.request!.url!.absoluteString)
            print(response.value)
            XCTAssert(response.error == nil)
            XCTAssert(response.value != nil)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testBlocks() {
        let expectation = self.expectation(description: "Request")
        
        AF.request("\(SERVER_TEST_URL)/schools/0/schedule/blocks", method: .get, interceptor: Retry()).validate().responseDecodable(of: [BlockData].self) { response in
            print(response.request!.url!.absoluteString)
            print(response.value)
            XCTAssert(response.error == nil)
            XCTAssert(response.value != nil)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testGetWeek() {
        let expectation = self.expectation(description: "Request")
        
        AF.request("\(SERVER_TEST_URL)/schools/0/schedule/weeks/2021-06-21", method: .get, interceptor: Retry()).validate().responseDecodable(of: Week.self) { response in
                print(response.request!.url!.absoluteString)
                print(response.value)
                XCTAssert(response.error == nil)
                XCTAssert(response.value != nil)
                expectation.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
    }

}
