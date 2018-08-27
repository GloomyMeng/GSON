//
//  NestedGSONTests.swift
//  GSONTests
//
//  Created by Gloomy Sunday on 2018/8/27.
//

import XCTest
@testable import GSON

class NestedGSONTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testTopLevelNestedJSON() {
        let nestedJSON: GSON = [
            "family": family
        ]
        XCTAssertNotNil(nestedJSON.rawStrings())
    }
    
    func testDeeplyNestedJSON() {
        let nestedFamily: GSON = [
            "count": 1,
            "families": [
                [
                    "isACoolFamily": true,
                    "family": [
                        "hello": family
                    ]
                ]
            ]
        ]
        XCTAssertNotNil(nestedFamily.rawStrings())
    }
    
    func testArrayJSON() {
        let arr: [GSON] = ["a", 1, ["b", 2]]
        let json = GSON(arr)
        XCTAssertEqual(json[0].string, "a")
        XCTAssertEqual(json[2, 1].int, 2)
    }
    
    func testDictionaryJSON() {
        let json: GSON = ["a": GSON("1"), "b": GSON([1, 2, "3"]), "c": GSON(["aa": "11", "bb": 22])]
        XCTAssertEqual(json["a"].string, "1")
        XCTAssertEqual(json["b"].array!, [1, 2, "3"])
        XCTAssertEqual(json["c"]["aa"].string, "11")
    }
    
    func testNestedJSON() {
        let inner = GSON([
            "some_field": "1" + "2"
            ])
        let json = GSON([
            "outer_field": "1" + "2",
            "inner_json": inner
            ])
        XCTAssertEqual(json["inner_json"], ["some_field": "12"])
        
        let foo = "foo"
        let json2 = GSON([
            "outer_field": foo,
            "inner_json": inner
            ])
        XCTAssertEqual(json2["inner_json"].rawValue as! [String: String], ["some_field": "12"])
    }
    
    let family: GSON = [
        "names": [
            "Brooke Abigail Matos",
            "Rowan Danger Matos"
        ],
        "motto": "Hey, I don't know about you, but I'm feeling twenty-two! So, release the KrakenDev!"
    ]
}
