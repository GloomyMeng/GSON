//
//  ArrayTests.swift
//  GSONTests
//
//  Created by Gloomy Sunday on 2018/8/27.
//

import XCTest
@testable import GSON

class ArrayTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testSingleDimensionalArraysGetter() {
        let array = ["1", "2", "a", "B", "D"]
        let json = GSON(array)
        XCTAssertEqual((json.array![0] as GSON).string!, "1")
        XCTAssertEqual((json.array![1] as GSON).string!, "2")
        XCTAssertEqual((json.array![2] as GSON).string!, "a")
        XCTAssertEqual((json.array![3] as GSON).string!, "B")
        XCTAssertEqual((json.array![4] as GSON).string!, "D")
    }
    
    func testSingleDimensionalArraysSetter() {
        let array = ["1", "2", "a", "B", "D"]
        var json = GSON(array)
        json.arrayObject = ["111", "222"]
        XCTAssertEqual((json.array![0] as GSON).string!, "111")
        XCTAssertEqual((json.array![1] as GSON).string!, "222")
    }
    
}
