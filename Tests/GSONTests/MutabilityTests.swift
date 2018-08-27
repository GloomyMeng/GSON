//
//  MutabilityTests.swift
//  GSONTests
//
//  Created by Gloomy Sunday on 2018/8/27.
//

import XCTest
@testable import GSON

class MutabilityTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    
    func testDictionaryMutability() {
        let dictionary: [String: Any] = [
            "string": "STRING",
            "number": 9823.212,
            "bool": true,
            "empty": ["nothing"],
            "foo": ["bar": ["1"]],
            "bar": ["foo": ["1": "a"]]
        ]
        
        var json = GSON(dictionary)
        XCTAssertEqual(json["string"], "STRING")
        XCTAssertEqual(json["number"], 9823.212)
        XCTAssertEqual(json["bool"], true)
        XCTAssertEqual(json["empty"], ["nothing"])
        
        json["string"] = "muted"
        XCTAssertEqual(json["string"], "muted")
        
        json["number"] = 9999.0
        XCTAssertEqual(json["number"], 9999.0)
        
        json["bool"] = false
        XCTAssertEqual(json["bool"], false)
        
        json["empty"] = []
        XCTAssertEqual(json["empty"], [])
        
        json["new"] = GSON(["foo": "bar"])
        XCTAssertEqual(json["new"], ["foo": "bar"])
        
        json["foo"]["bar"] = GSON([])
        XCTAssertEqual(json["foo"]["bar"], [])
        
        json["bar"]["foo"] = GSON(["2": "b"])
        XCTAssertEqual(json["bar"]["foo"], ["2": "b"])
    }
    
    func testArrayMutability() {
        let array: [Any] = ["1", "2", 3, true, []]
        
        var json = GSON(array)
        XCTAssertEqual(json[0], "1")
        XCTAssertEqual(json[1], "2")
        XCTAssertEqual(json[2], 3)
        XCTAssertEqual(json[3], true)
        XCTAssertEqual(json[4], [])
        
        json[0] = false
        XCTAssertEqual(json[0], false)
        
        json[1] = 2
        XCTAssertEqual(json[1], 2)
        
        json[2] = "3"
        XCTAssertEqual(json[2], "3")
        
        json[3] = [:]
        XCTAssertEqual(json[3], [:])
        
        json[4] = [1, 2]
        XCTAssertEqual(json[4], [1, 2])
    }
    
    func testValueMutability() {
        var intArray = GSON([0, 1, 2])
        intArray[0] = GSON(55)
        XCTAssertEqual(intArray[0], 55)
        XCTAssertEqual(intArray[0].intValue, 55)
        
        var dictionary = GSON(["foo": "bar"])
        dictionary["foo"] = GSON("foo")
        XCTAssertEqual(dictionary["foo"], "foo")
        XCTAssertEqual(dictionary["foo"].stringValue, "foo")
        
        var number = GSON(1)
        number = GSON("111")
        XCTAssertEqual(number, "111")
        XCTAssertEqual(number.intValue, 111)
        XCTAssertEqual(number.stringValue, "111")
        
        var boolean = GSON(true)
        boolean = GSON(false)
        XCTAssertEqual(boolean, false)
        XCTAssertEqual(boolean.boolValue, false)
    }
    
    func testArrayRemovability() {
        let array = ["Test", "Test2", "Test3"]
        var json = GSON(array)
        
        json.arrayObject?.removeFirst()
        XCTAssertEqual(false, json.arrayValue.isEmpty)
        XCTAssertEqual(json.arrayValue, ["Test2", "Test3"])
        
        json.arrayObject?.removeLast()
        XCTAssertEqual(false, json.arrayValue.isEmpty)
        XCTAssertEqual(json.arrayValue, ["Test2"])
        
        json.arrayObject?.removeAll()
        XCTAssertEqual(true, json.arrayValue.isEmpty)
        XCTAssertEqual(GSON([]), json)
    }
    
    func testDictionaryRemovability() {
        let dictionary: [String: Any] = ["key1": "Value1", "key2": 2, "key3": true]
        var json = GSON(dictionary)
        
        json.dictionaryObject?.removeValue(forKey: "key1")
        XCTAssertEqual(false, json.dictionaryValue.isEmpty)
        XCTAssertEqual(json.dictionaryValue, ["key2": 2, "key3": true])
        
        json.dictionaryObject?.removeValue(forKey: "key3")
        XCTAssertEqual(false, json.dictionaryValue.isEmpty)
        XCTAssertEqual(json.dictionaryValue, ["key2": 2])
        
        json.dictionaryObject?.removeAll()
        XCTAssertEqual(true, json.dictionaryValue.isEmpty)
        XCTAssertEqual(json.dictionaryValue, [:])
    }

    
}
