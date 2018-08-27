//
//  LiteralConvertibleTests.swift
//  GSONTests
//
//  Created by Gloomy Sunday on 2018/8/27.
//

import XCTest
@testable import GSON

class LiteralConvertibleTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testNumber() {
        var json: GSON = 1234567890.876623
        XCTAssertEqual(json.int!, 1234567890)
        XCTAssertEqual(json.intValue, 1234567890)
        XCTAssertEqual(json.double!, 1234567890.876623)
        XCTAssertEqual(json.doubleValue, 1234567890.876623)
    }
    
    func testBool() {
        var jsonTrue: GSON = true
        XCTAssertEqual(jsonTrue.bool!, true)
        XCTAssertEqual(jsonTrue.boolValue, true)
        var jsonFalse: GSON = false
        XCTAssertEqual(jsonFalse.bool!, false)
        XCTAssertEqual(jsonFalse.boolValue, false)
    }
    
    func testString() {
        var json: GSON = "abcd efg, HIJK;LMn"
        XCTAssertEqual(json.string!, "abcd efg, HIJK;LMn")
        XCTAssertEqual(json.stringValue, "abcd efg, HIJK;LMn")
    }
    
    func testNil() {
        let jsonNil_1: GSON = GSON.null
        XCTAssert(jsonNil_1 == GSON.null)
        let jsonNil_2: GSON = GSON(GSON.nullValue)
        XCTAssert(jsonNil_2 == GSON.null)
        let jsonNil_3: GSON = GSON([1: 2])
        XCTAssert(jsonNil_3 == GSON.null)
    }
    
    func testArray() {
        let json: GSON = [1, 2, "4", 5, "6"]
        XCTAssertEqual(json.array!, [1, 2, "4", 5, "6"])
        XCTAssertEqual(json.arrayValue, [1, 2, "4", 5, "6"])
    }
    
    func testDictionary() {
        let json: GSON = ["1": 2, "2": 2, "three": 3, "list": ["aa", "bb", "dd"]]
        XCTAssertEqual(json.dictionary!, ["1": 2, "2": 2, "three": 3, "list": ["aa", "bb", "dd"]])
        XCTAssertEqual(json.dictionaryValue, ["1": 2, "2": 2, "three": 3, "list": ["aa", "bb", "dd"]])
    }

}
