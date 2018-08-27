//
//  DictionaryTests.swift
//  GSONTests
//
//  Created by Gloomy Sunday on 2018/8/27.
//

import XCTest
@testable import GSON

class DictionaryTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testGetter() {
        let dictionary = ["number": 9823.212, "name": "NAME", "list": [1234, 4.212], "object": ["sub_number": 877.2323, "sub_name": "sub_name"], "bool": true] as [String: Any]
        let json = GSON(dictionary)
        //dictionary
        XCTAssertEqual((json.dictionary!["number"]! as GSON).double!, 9823.212)
        XCTAssertEqual((json.dictionary!["name"]! as GSON).string!, "NAME")
        XCTAssertEqual(((json.dictionary!["list"]! as GSON).array![0] as GSON).int!, 1234)
        XCTAssertEqual(((json.dictionary!["list"]! as GSON).array![1] as GSON).double!, 4.212)
        XCTAssertEqual((((json.dictionary!["object"]! as GSON).dictionaryValue)["sub_number"]! as GSON).double!, 877.2323)
        XCTAssertTrue(json.dictionary!["null"] == nil)
        //dictionaryValue
        XCTAssertEqual(((((json.dictionaryValue)["object"]! as GSON).dictionaryValue)["sub_name"]! as GSON).string!, "sub_name")
        XCTAssertEqual((json.dictionaryValue["bool"]! as GSON).bool!, true)
        XCTAssertTrue(json.dictionaryValue["null"] == nil)
        XCTAssertTrue(GSON.null.dictionaryValue == [:])
        //dictionaryObject
        XCTAssertEqual(json.dictionaryObject!["number"]! as? Double, 9823.212)
        XCTAssertTrue(json.dictionaryObject!["null"] == nil)
        XCTAssertTrue(GSON.null.dictionaryObject == nil)
    }
    
    func testSetter() {
        var json: GSON = ["test": "case"]
        XCTAssertEqual(json.dictionaryObject! as! [String: String], ["test": "case"])
        json.dictionaryObject = ["name": "NAME"]
        XCTAssertEqual(json.dictionaryObject! as! [String: String], ["name": "NAME"])
    }

}
