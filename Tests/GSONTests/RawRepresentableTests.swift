//
//  RawRepresentableTests.swift
//  GSONTests
//
//  Created by Gloomy Sunday on 2018/8/27.
//

import XCTest
@testable import GSON

class RawRepresentableTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testNumber() {
        var json: GSON = GSON(rawValue: 948394394.347384 as NSNumber)!
        XCTAssertEqual(json.int!, 948394394)
        XCTAssertEqual(json.intValue, 948394394)
        XCTAssertEqual(json.double!, 948394394.347384)
        XCTAssertEqual(json.doubleValue, 948394394.347384)
        
        let object: Any = json.rawValue
        if let int = object as? Int {
            XCTAssertEqual(int, 948394394)
        }
        XCTAssertEqual(object as? Double, 948394394.347384)
        if let float = object as? Float {
            XCTAssertEqual(float, 948394394.347384)
        }
        XCTAssertEqual(object as? NSNumber, 948394394.347384)
    }
    
    func testBool() {
        var jsonTrue: GSON = GSON(rawValue: true as NSNumber)!
        XCTAssertEqual(jsonTrue.bool!, true)
        XCTAssertEqual(jsonTrue.boolValue, true)
        
        var jsonFalse: GSON = GSON(rawValue: false)!
        XCTAssertEqual(jsonFalse.bool!, false)
        XCTAssertEqual(jsonFalse.boolValue, false)
        
        
        let objectFalse = jsonFalse.rawValue
        XCTAssertEqual(objectFalse as? Bool, false)
    }
    
    func testString() {
        let string = "The better way to deal with GSON data in Swift."
        if let json: GSON = GSON(rawValue: string) {
            XCTAssertEqual(json.string!, string)
            XCTAssertEqual(json.stringValue, string)
            XCTAssertTrue(json.array == nil)
            XCTAssertTrue(json.dictionary == nil)
            XCTAssertTrue(json.null == nil)
            XCTAssertTrue(json.error == nil)
            XCTAssertTrue(json.type == .string)
            XCTAssertEqual(json.object as? String, string)
        } else {
            XCTFail("Should not run into here")
        }
        
        let object: Any = GSON(rawValue: string)!.rawValue
        XCTAssertEqual(object as? String, string)
    }
    
    func testNil() {
        if GSON(rawValue: NSObject()) != nil {
            XCTFail("Should not run into here")
        }
    }
    
    func testArray() {
        let array = [1, 2, "3", 4102, "5632", "abocde", "!@# $%^&*()"] as NSArray
        if let json: GSON = GSON(rawValue: array) {
            XCTAssertEqual(json, GSON(array))
        }
        
        let object: Any = GSON(rawValue: array)!.rawValue
        XCTAssertTrue(array == object as! NSArray)
    }
    
    func testDictionary() {
        let dictionary = ["1": 2, "2": 2, "three": 3, "list": ["aa", "bb", "dd"]] as NSDictionary
        if let json: GSON = GSON(rawValue: dictionary) {
            XCTAssertEqual(json, GSON(dictionary))
        }
        
        let object: Any = GSON(rawValue: dictionary)!.rawValue
        XCTAssertTrue(dictionary == object as! NSDictionary)
    }

}
