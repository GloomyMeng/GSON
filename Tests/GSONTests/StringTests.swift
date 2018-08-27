//
//  StringTests.swift
//  GSONTests
//
//  Created by Gloomy Sunday on 2018/8/27.
//

import XCTest
@testable import GSON

class StringTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testString() {
        //getter
        var json = GSON("abcdefg hijklmn;opqrst.?+_()")
        XCTAssertEqual(json.string!, "abcdefg hijklmn;opqrst.?+_()")
        XCTAssertEqual(json.stringValue, "abcdefg hijklmn;opqrst.?+_()")
        
        json.string = "12345?67890.@#"
        XCTAssertEqual(json.string!, "12345?67890.@#")
        XCTAssertEqual(json.stringValue, "12345?67890.@#")
    }
    
    func testUrl() {
        let json = GSON("http://github.com")
        XCTAssertEqual(json.stringValue, "http://github.com")
    }
    
    func testBool() {
        let json = GSON("true")
        XCTAssertTrue(json.boolValue)
    }
    
    func testBoolWithY() {
        let json = GSON("Y")
        XCTAssertTrue(json.boolValue)
    }
    
    func testBoolWithT() {
        let json = GSON("T")
        XCTAssertTrue(json.boolValue)
    }
    
    func testBoolWithYes() {
        let json = GSON("Yes")
        XCTAssertTrue(json.boolValue)
    }
    
    func testBoolWith1() {
        let json = GSON("1")
        XCTAssertTrue(json.boolValue)
    }
    
    func testUrlPercentEscapes() {
        let emDash = "\\u2014"
        let urlString = "http://examble.com/unencoded" + emDash + "string"
        guard let encodedURLString = urlString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) else {
            return XCTFail("Couldn't encode URL string \(urlString)")
        }
        let json = GSON(urlString)
        XCTAssertEqual(json.stringValue, urlString, "Wrong unpacked ")
        let preEscaped = GSON(encodedURLString)
        XCTAssertEqual(preEscaped.stringValue, encodedURLString, "Wrong unpacked ")
    }

    
}
