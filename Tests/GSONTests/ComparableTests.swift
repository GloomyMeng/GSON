//
//  ComparableTests.swift
//  GSONTests
//
//  Created by Gloomy Sunday on 2018/8/27.
//

import XCTest
@testable import GSON

class ComparableTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testNumberEqual() {
        let jsonL1: GSON = 1234567890.876623
        let jsonR1: GSON = GSON(1234567890.876623)
        XCTAssertEqual(jsonL1, jsonR1)
        XCTAssertTrue(jsonL1 == 1234567890.876623)
        
        let jsonL2: GSON = 987654321
        let jsonR2: GSON = GSON(987654321)
        XCTAssertEqual(jsonL2, jsonR2)
        XCTAssertTrue(jsonR2 == 987654321)
        
        let jsonL3: GSON = GSON(NSNumber(value: 87654321.12345678))
        let jsonR3: GSON = GSON(NSNumber(value: 87654321.12345678))
        XCTAssertEqual(jsonL3, jsonR3)
        XCTAssertTrue(jsonR3 == 87654321.12345678)
    }
    
    func testNumberNotEqual() {
        let jsonL1: GSON = 1234567890.876623
        let jsonR1: GSON = GSON(123.123)
        XCTAssertNotEqual(jsonL1, jsonR1)
        XCTAssertFalse(jsonL1 == 34343)
        
        let jsonL2: GSON = 8773
        let jsonR2: GSON = GSON(123.23)
        XCTAssertNotEqual(jsonL2, jsonR2)
        XCTAssertFalse(jsonR1 == 454352)
        
        let jsonL3: GSON = GSON(NSNumber(value: 87621.12345678))
        let jsonR3: GSON = GSON(NSNumber(value: 87654321.45678))
        XCTAssertNotEqual(jsonL3, jsonR3)
        XCTAssertFalse(jsonL3 == 4545.232)
    }
    
    func testNumberGreaterThanOrEqual() {
        let jsonL1: GSON = 1234567890.876623
        let jsonR1: GSON = GSON(123.123)
        XCTAssertGreaterThanOrEqual(jsonL1, jsonR1)
        XCTAssertTrue(jsonL1 >= -37434)
        
        let jsonL2: GSON = 8773
        let jsonR2: GSON = GSON(-87343)
        XCTAssertGreaterThanOrEqual(jsonL2, jsonR2)
        XCTAssertTrue(jsonR2 >= -988343)
        
        let jsonL3: GSON = GSON(NSNumber(value: 87621.12345678))
        let jsonR3: GSON = GSON(NSNumber(value: 87621.12345678))
        XCTAssertGreaterThanOrEqual(jsonL3, jsonR3)
        XCTAssertTrue(jsonR3 >= 0.3232)
    }
    
    func testNumberLessThanOrEqual() {
        let jsonL1: GSON = 1234567890.876623
        let jsonR1: GSON = GSON(123.123)
        XCTAssertLessThanOrEqual(jsonR1, jsonL1)
        XCTAssertFalse(83487343.3493 <= jsonR1)
        
        let jsonL2: GSON = 8773
        let jsonR2: GSON = GSON(-123.23)
        XCTAssertLessThanOrEqual(jsonR2, jsonL2)
        XCTAssertFalse(9348343 <= jsonR2)
        
        let jsonL3: GSON = GSON(NSNumber(value: 87621.12345678))
        let jsonR3: GSON = GSON(NSNumber(value: 87621.12345678))
        XCTAssertLessThanOrEqual(jsonR3, jsonL3)
        XCTAssertTrue(87621.12345678 <= jsonR3)
    }
    
    func testNumberGreaterThan() {
        let jsonL1: GSON = 1234567890.876623
        let jsonR1: GSON = GSON(123.123)
        XCTAssertGreaterThan(jsonL1, jsonR1)
        XCTAssertFalse(jsonR1 > 192388843.0988)
        
        let jsonL2: GSON = 8773
        let jsonR2: GSON = GSON(123.23)
        XCTAssertGreaterThan(jsonL2, jsonR2)
        XCTAssertFalse(jsonR2 > 877434)
        
        let jsonL3: GSON = GSON(NSNumber(value: 87621.12345678))
        let jsonR3: GSON = GSON(NSNumber(value: 87621.1234567))
        XCTAssertGreaterThan(jsonL3, jsonR3)
        XCTAssertFalse(-7799 > jsonR3)
    }
    
    func testNumberLessThan() {
        let jsonL1: GSON = 1234567890.876623
        let jsonR1: GSON = GSON(123.123)
        XCTAssertLessThan(jsonR1, jsonL1)
        XCTAssertTrue(jsonR1 < 192388843.0988)
        
        let jsonL2: GSON = 8773
        let jsonR2: GSON = GSON(123.23)
        XCTAssertLessThan(jsonR2, jsonL2)
        XCTAssertTrue(jsonR2 < 877434)
        
        let jsonL3: GSON = GSON(NSNumber(value: 87621.12345678))
        let jsonR3: GSON = GSON(NSNumber(value: 87621.1234567))
        XCTAssertLessThan(jsonR3, jsonL3)
        XCTAssertTrue(-7799 < jsonR3)
    }
    
    func testBoolEqual() {
        let jsonL1: GSON = true
        let jsonR1: GSON = GSON(true)
        XCTAssertEqual(jsonL1, jsonR1)
        XCTAssertTrue(jsonL1 == true)
        
        let jsonL2: GSON = false
        let jsonR2: GSON = GSON(false)
        XCTAssertEqual(jsonL2, jsonR2)
        XCTAssertTrue(jsonL2 == false)
    }
    
    func testBoolNotEqual() {
        let jsonL1: GSON = true
        let jsonR1: GSON = GSON(false)
        XCTAssertNotEqual(jsonL1, jsonR1)
        XCTAssertTrue(jsonL1 != false)
        
        let jsonL2: GSON = false
        let jsonR2: GSON = GSON(true)
        XCTAssertNotEqual(jsonL2, jsonR2)
        XCTAssertTrue(jsonL2 != true)
    }
    
    func testBoolGreaterThanOrEqual() {
        let jsonL1: GSON = true
        let jsonR1: GSON = GSON(true)
        XCTAssertGreaterThanOrEqual(jsonL1, jsonR1)
        XCTAssertTrue(jsonL1 >= true)
        
        let jsonL2: GSON = false
        let jsonR2: GSON = GSON(false)
        XCTAssertGreaterThanOrEqual(jsonL2, jsonR2)
        XCTAssertFalse(jsonL2 >= true)
    }
    
    func testBoolLessThanOrEqual() {
        let jsonL1: GSON = true
        let jsonR1: GSON = GSON(true)
        XCTAssertLessThanOrEqual(jsonL1, jsonR1)
        XCTAssertTrue(true <= jsonR1)
        
        let jsonL2: GSON = false
        let jsonR2: GSON = GSON(false)
        XCTAssertLessThanOrEqual(jsonL2, jsonR2)
        XCTAssertFalse(jsonL2 <= true)
    }
    
    func testBoolGreaterThan() {
        let jsonL1: GSON = true
        let jsonR1: GSON = GSON(true)
        XCTAssertFalse(jsonL1 > jsonR1)
        XCTAssertFalse(jsonL1 > true)
        XCTAssertFalse(jsonR1 > false)
        
        let jsonL2: GSON = false
        let jsonR2: GSON = GSON(false)
        XCTAssertFalse(jsonL2 > jsonR2)
        XCTAssertFalse(jsonL2 > false)
        XCTAssertFalse(jsonR2 > true)
        
        let jsonL3: GSON = true
        let jsonR3: GSON = GSON(false)
        XCTAssertFalse(jsonL3 > jsonR3)
        XCTAssertFalse(jsonL3 > false)
        XCTAssertFalse(jsonR3 > true)
        
        let jsonL4: GSON = false
        let jsonR4: GSON = GSON(true)
        XCTAssertFalse(jsonL4 > jsonR4)
        XCTAssertFalse(jsonL4 > false)
        XCTAssertFalse(jsonR4 > true)
    }
    
    func testBoolLessThan() {
        let jsonL1: GSON = true
        let jsonR1: GSON = GSON(true)
        XCTAssertFalse(jsonL1 < jsonR1)
        XCTAssertFalse(jsonL1 < true)
        XCTAssertFalse(jsonR1 < false)
        
        let jsonL2: GSON = false
        let jsonR2: GSON = GSON(false)
        XCTAssertFalse(jsonL2 < jsonR2)
        XCTAssertFalse(jsonL2 < false)
        XCTAssertFalse(jsonR2 < true)
        
        let jsonL3: GSON = true
        let jsonR3: GSON = GSON(false)
        XCTAssertFalse(jsonL3 < jsonR3)
        XCTAssertFalse(jsonL3 < false)
        XCTAssertFalse(jsonR3 < true)
        
        let jsonL4: GSON = false
        let jsonR4: GSON = GSON(true)
        XCTAssertFalse(jsonL4 < jsonR4)
        XCTAssertFalse(jsonL4 < false)
        XCTAssertFalse(true < jsonR4)
    }
    
    func testStringEqual() {
        let jsonL1: GSON = "abcdefg 123456789 !@#$%^&*()"
        let jsonR1: GSON = GSON("abcdefg 123456789 !@#$%^&*()")
        
        XCTAssertEqual(jsonL1, jsonR1)
        XCTAssertTrue(jsonL1 == "abcdefg 123456789 !@#$%^&*()")
    }
    
    func testStringNotEqual() {
        let jsonL1: GSON = "abcdefg 123456789 !@#$%^&*()"
        let jsonR1: GSON = GSON("-=[]\\\"987654321")
        
        XCTAssertNotEqual(jsonL1, jsonR1)
        XCTAssertTrue(jsonL1 != "not equal")
    }
    
    func testStringGreaterThanOrEqual() {
        let jsonL1: GSON = "abcdefg 123456789 !@#$%^&*()"
        let jsonR1: GSON = GSON("abcdefg 123456789 !@#$%^&*()")
        
        XCTAssertGreaterThanOrEqual(jsonL1, jsonR1)
        XCTAssertTrue(jsonL1 >= "abcdefg 123456789 !@#$%^&*()")
        
        let jsonL2: GSON = "z-+{}:"
        let jsonR2: GSON = GSON("a<>?:")
        XCTAssertGreaterThanOrEqual(jsonL2, jsonR2)
        XCTAssertTrue(jsonL2 >= "mnbvcxz")
    }
    
    func testStringLessThanOrEqual() {
        let jsonL1: GSON = "abcdefg 123456789 !@#$%^&*()"
        let jsonR1: GSON = GSON("abcdefg 123456789 !@#$%^&*()")
        
        XCTAssertLessThanOrEqual(jsonL1, jsonR1)
        XCTAssertTrue(jsonL1 <= "abcdefg 123456789 !@#$%^&*()")
        
        let jsonL2: GSON = "z-+{}:"
        let jsonR2: GSON = GSON("a<>?:")
        XCTAssertLessThanOrEqual(jsonR2, jsonL2)
        XCTAssertTrue("mnbvcxz" <= jsonL2)
    }
    
    func testStringGreaterThan() {
        let jsonL1: GSON = "abcdefg 123456789 !@#$%^&*()"
        let jsonR1: GSON = GSON("abcdefg 123456789 !@#$%^&*()")
        
        XCTAssertFalse(jsonL1 > jsonR1)
        XCTAssertFalse(jsonL1 > "abcdefg 123456789 !@#$%^&*()")
        
        let jsonL2: GSON = "z-+{}:"
        let jsonR2: GSON = GSON("a<>?:")
        XCTAssertGreaterThan(jsonL2, jsonR2)
        XCTAssertFalse("87663434" > jsonL2)
    }
    
    func testStringLessThan() {
        let jsonL1: GSON = "abcdefg 123456789 !@#$%^&*()"
        let jsonR1: GSON = GSON("abcdefg 123456789 !@#$%^&*()")
        
        XCTAssertFalse(jsonL1 < jsonR1)
        XCTAssertFalse(jsonL1 < "abcdefg 123456789 !@#$%^&*()")
        
        let jsonL2: GSON = "98774"
        let jsonR2: GSON = GSON("123456")
        XCTAssertLessThan(jsonR2, jsonL2)
        XCTAssertFalse(jsonL2 < "09")
    }
    
    func testNil() {
        let jsonL1: GSON = GSON.null
        let jsonR1: GSON = GSON(NSNull())
        XCTAssertEqual(jsonL1, jsonR1)
        XCTAssertTrue(jsonL1 != "123")
        XCTAssertFalse(jsonL1 > "abcd")
        XCTAssertFalse(jsonR1 < "*&^")
        XCTAssertFalse(jsonL1 >= "jhfid")
        XCTAssertFalse(jsonR1 <= "你好")
        XCTAssertTrue(jsonL1 >= jsonR1)
        XCTAssertTrue(jsonL1 <= jsonR1)
    }
    
    func testArray() {
        let jsonL1: GSON = [1, 2, "4", 5, "6"]
        let jsonR1: GSON = GSON([1, 2, "4", 5, "6"])
        XCTAssertEqual(jsonL1, jsonR1)
        XCTAssertTrue(jsonL1 == [1, 2, "4", 5, "6"])
        XCTAssertTrue(jsonL1 != ["abcd", "efg"])
        XCTAssertTrue(jsonL1 >= jsonR1)
        XCTAssertTrue(jsonL1 <= jsonR1)
        XCTAssertFalse(jsonL1 > ["abcd", ""])
        XCTAssertFalse(jsonR1 < [])
        XCTAssertFalse(jsonL1 >= [:])
    }
    
    func testDictionary() {
        let jsonL1: GSON = ["2": 2, "name": "Jack", "List": ["a", 1.09, NSNull()]]
        let jsonR1: GSON = GSON(["2": 2, "name": "Jack", "List": ["a", 1.09, NSNull()]])
        
        XCTAssertEqual(jsonL1, jsonR1)
        XCTAssertTrue(jsonL1 != ["1": 2, "Hello": "World", "Koo": "Foo"])
        XCTAssertTrue(jsonL1 >= jsonR1)
        XCTAssertTrue(jsonL1 <= jsonR1)
        XCTAssertFalse(jsonL1 >= [:])
        XCTAssertFalse(jsonR1 <= ["999": "aaaa"])
        XCTAssertFalse(jsonL1 > [")(*&^": 1234567])
        XCTAssertFalse(jsonR1 < ["MNHH": "JUYTR"])
    }
}
