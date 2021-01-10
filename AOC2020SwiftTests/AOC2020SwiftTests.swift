//
//  AOC2020SwiftTests.swift
//  AOC2020SwiftTests
//
//  Created by James Hannah on 11/01/2021.
//

import XCTest

class AOC2020SwiftTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    struct SimpleInit: InitableFromString{
        var x: String
        init(from: String) {
            x=from
        }
    }

    func testBatchCreate() throws {
        let basicInput = ""
        let created: [SimpleInit] = try batchCreate(from: basicInput)
        XCTAssertNotNil(created)
    }
    
    func testBatchCreateWithDataShort() throws {
        let basicInput = """
        abc

        def
        ghi
        """
        let created: [SimpleInit] = try batchCreate(from: basicInput)
        XCTAssertNotNil(created)
        XCTAssertEqual(created.count, 2)
    }
    
    func testBatchCreateWithDataLong() throws {
        let basicInput = """
        abc

        def
        ghi

        sss

        asttast

        arst
        rst
        stts
        enen
        """
        let created: [SimpleInit] = try batchCreate(from: basicInput)
        XCTAssertNotNil(created)
        XCTAssertEqual(created.count, 5)
    }
}
