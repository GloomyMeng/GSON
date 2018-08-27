//
//  SubscriptTests.swift
//  GSONTests
//
//  Created by Gloomy Sunday on 2018/8/27.
//

import XCTest
@testable import GSON

class SubscriptTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testArrayAllNumber() {
        var json: GSON = [1, 2.0, 3.3, 123456789, 987654321.123456789]
        XCTAssertTrue(json == [1, 2.0, 3.3, 123456789, 987654321.123456789])
        XCTAssertTrue(json[0] == 1)
        XCTAssertEqual(json[1].double!, 2.0)
        XCTAssertTrue(json[2].doubleValue == 3.3)
        XCTAssertEqual(json[3].int!, 123456789)
        XCTAssertEqual(json[4].doubleValue, 987654321.123456789)
        
        json[0] = 1.9
        json[1] = 2.899
        json[2] = 3.567
        json[3] = 0.999
        json[4] = 98732
        
        XCTAssertTrue(json[0] == 1.9)
        XCTAssertEqual(json[1].doubleValue, 2.899)
        XCTAssertTrue(json[2] == 3.567)
        XCTAssertTrue(json[3].double! == 0.999)
        XCTAssertTrue(json[4].intValue == 98732)
    }
    
    func testArrayAllBool() {
        var json: GSON = [true, false, false, true, true]
        XCTAssertTrue(json == [true, false, false, true, true])
        XCTAssertTrue(json[0] == true)
        XCTAssertTrue(json[1] == false)
        XCTAssertTrue(json[2] == false)
        XCTAssertTrue(json[3] == true)
        XCTAssertTrue(json[4] == true)
        
        json[0] = false
        json[4] = true
        XCTAssertTrue(json[0] == false)
        XCTAssertTrue(json[4] == true)
    }
    
    func testArrayAllString() {
        var json: GSON = GSON(rawValue: ["aoo", "bpp", "zoo"] as NSArray)!
        XCTAssertTrue(json == ["aoo", "bpp", "zoo"])
        XCTAssertTrue(json[0] == "aoo")
        XCTAssertTrue(json[1] == "bpp")
        XCTAssertTrue(json[2] == "zoo")
        
        json[1] = "update"
        XCTAssertTrue(json[0] == "aoo")
        XCTAssertTrue(json[1] == "update")
        XCTAssertTrue(json[2] == "zoo")
    }
    
    func testArrayWithNull() {
        var json: GSON = GSON(rawValue: ["aoo", "bpp", nil, "zoo"] as NSArray)!
        XCTAssertTrue(json[0] == "aoo")
        XCTAssertTrue(json[1] == "bpp")
        XCTAssertNil(json[2].string)
        XCTAssertNotNil(json[2].null)
        XCTAssertTrue(json[3] == "zoo")
        
        json[2] = "update"
        json[3] = GSON.null
        XCTAssertTrue(json[0] == "aoo")
        XCTAssertTrue(json[1] == "bpp")
        XCTAssertTrue(json[2] == "update")
        XCTAssertNil(json[3].string)
        XCTAssertNotNil(json[3].null)
    }
    
    func testArrayAllDictionary() {
        var json: GSON = [["1": 1, "2": 2], ["a": "A", "b": "B"], ["null": nil]]
        XCTAssertTrue(json[0] == ["1": 1, "2": 2])
        XCTAssertEqual(json[1].dictionary!, ["a": "A", "b": "B"])
        XCTAssertEqual(json[2], GSON(["null": nil]))
        XCTAssertTrue(json[0]["1"] == 1)
        XCTAssertTrue(json[0]["2"] == 2)
        XCTAssertEqual(json[1]["a"], GSON(rawValue: "A")!)
        XCTAssertEqual(json[1]["b"], GSON("B"))
        XCTAssertNotNil(json[2]["null"].null)
        XCTAssertNotNil(json[2, "null"].null)
        let keys: [GSONSubscriptType] = [1, "a"]
        XCTAssertEqual(json[keys], GSON(rawValue: "A")!)
    }
    
    func testDictionaryAllNumber() {
        var json: GSON = ["double": 1.11111, "int": 987654321]
        XCTAssertEqual(json["double"].double!, 1.11111)
        XCTAssertTrue(json["int"] == 987654321)
        
        json["double"] = 2.2222
        json["int"] = 123456789
        json["add"] = 7890
        XCTAssertTrue(json["double"] == 2.2222)
        XCTAssertEqual(json["int"].doubleValue, 123456789.0)
        XCTAssertEqual(json["add"].intValue, 7890)
    }
    
    func testDictionaryAllBool() {
        var json: GSON = ["t": true, "f": false, "false": false, "tr": true, "true": true, "yes": true, "1": true]
        XCTAssertTrue(json["1"] == true)
        XCTAssertTrue(json["yes"] == true)
        XCTAssertTrue(json["t"] == true)
        XCTAssertTrue(json["f"] == false)
        XCTAssertTrue(json["false"] == false)
        XCTAssertTrue(json["tr"] == true)
        XCTAssertTrue(json["true"] == true)
        
        json["f"] = true
        json["tr"] = false
        XCTAssertTrue(json["f"] == true)
        XCTAssertTrue(json["tr"] == GSON(false))
    }
    
    func testDictionaryAllString() {
        var json: GSON = GSON(rawValue: ["a": "aoo", "bb": "bpp", "z": "zoo"] as NSDictionary)!
        XCTAssertTrue(json["a"] == "aoo")
        XCTAssertEqual(json["bb"], GSON("bpp"))
        XCTAssertTrue(json["z"] == "zoo")
        
        json["bb"] = "update"
        XCTAssertTrue(json["a"] == "aoo")
        XCTAssertTrue(json["bb"] == "update")
        XCTAssertTrue(json["z"] == "zoo")
    }
    
    func testDictionaryWithNull() {
        var json: GSON = GSON(rawValue: ["a": "aoo", "bb": "bpp", "null": NSNull(), "z": "zoo"] as NSDictionary)!
        XCTAssertTrue(json["a"] == "aoo")
        XCTAssertEqual(json["bb"], GSON("bpp"))
        XCTAssertEqual(json["null"], GSON(NSNull()))
        XCTAssertTrue(json["z"] == "zoo")
        
        json["null"] = "update"
        XCTAssertTrue(json["a"] == "aoo")
        XCTAssertTrue(json["null"] == "update")
        XCTAssertTrue(json["z"] == "zoo")
    }
    
    func testDictionaryAllArray() {
        //Swift bug: [1, 2.01,3.09] is convert to [1, 2, 3] (Array<Int>)
        let json: GSON = GSON ([[NSNumber(value: 1), NSNumber(value: 2.123456), NSNumber(value: 123456789)], ["aa", "bbb", "cccc"], [true, "766", NSNull(), 655231.9823]] as NSArray)
        XCTAssertTrue(json[0] == [1, 2.123456, 123456789])
        XCTAssertEqual(json[0][1].double!, 2.123456)
        XCTAssertTrue(json[0][2] == 123456789)
        XCTAssertTrue(json[1][0] == "aa")
        XCTAssertTrue(json[1] == ["aa", "bbb", "cccc"])
        XCTAssertTrue(json[2][0] == true)
        XCTAssertTrue(json[2][1] == "766")
        XCTAssertTrue(json[[2, 1]] == "766")
        XCTAssertEqual(json[2][2], GSON(NSNull()))
        XCTAssertEqual(json[2, 2], GSON(NSNull()))
        XCTAssertEqual(json[2][3], GSON(655231.9823))
        XCTAssertEqual(json[2, 3], GSON(655231.9823))
        XCTAssertEqual(json[[2, 3]], GSON(655231.9823))
    }
    
    func testOutOfBounds() {
        let json: GSON = GSON ([[NSNumber(value: 1), NSNumber(value: 2.123456), NSNumber(value: 123456789)], ["aa", "bbb", "cccc"], [true, "766", NSNull(), 655231.9823]] as NSArray)
        XCTAssertEqual(json[9], GSON.null)
        XCTAssertEqual(json[-2].error, GSONError.indexOutOfBounds)
        XCTAssertEqual(json[6].error, GSONError.indexOutOfBounds)
        XCTAssertEqual(json[9][8], GSON.null)
        XCTAssertEqual(json[8][7].error, GSONError.indexOutOfBounds)
        XCTAssertEqual(json[8, 7].error, GSONError.indexOutOfBounds)
        XCTAssertEqual(json[999].error, GSONError.indexOutOfBounds)
    }
    
    func testErrorWrongType() {
        let json = GSON(12345)
        XCTAssertEqual(json[9], GSON.null)
        XCTAssertEqual(json[9].error, GSONError.wrongType)
        XCTAssertEqual(json[8][7].error, GSONError.wrongType)
        XCTAssertEqual(json["name"], GSON.null)
        XCTAssertEqual(json["name"].error, GSONError.wrongType)
        XCTAssertEqual(json[0]["name"].error, GSONError.wrongType)
        XCTAssertEqual(json["type"]["name"].error, GSONError.wrongType)
        XCTAssertEqual(json["name"][99].error, GSONError.wrongType)
        XCTAssertEqual(json[1, "Value"].error, GSONError.wrongType)
        XCTAssertEqual(json[1, 2, "Value"].error, GSONError.wrongType)
        XCTAssertEqual(json[[1, 2, "Value"]].error, GSONError.wrongType)
    }
    
    func testErrorNotExist() {
        let json: GSON = ["name": "NAME", "age": 15]
        XCTAssertEqual(json["Type"], GSON.null)
        XCTAssertEqual(json["Type"].error, GSONError.notExist)
        XCTAssertEqual(json["Type"][1].error, GSONError.notExist)
        XCTAssertEqual(json["Type", 1].error, GSONError.notExist)
        XCTAssertEqual(json["Type"]["Value"].error, GSONError.notExist)
        XCTAssertEqual(json["Type", "Value"].error, GSONError.notExist)
    }
    
    func testMultilevelGetter() {
        let json: GSON = [[[[["one": 1]]]]]
        XCTAssertEqual(json[[0, 0, 0, 0, "one"]].int!, 1)
        XCTAssertEqual(json[0, 0, 0, 0, "one"].int!, 1)
        XCTAssertEqual(json[0][0][0][0]["one"].int!, 1)
    }
    
    func testMultilevelSetter1() {
        var json: GSON = [[[[["num": 1]]]]]
        json[0, 0, 0, 0, "num"] = 2
        XCTAssertEqual(json[[0, 0, 0, 0, "num"]].intValue, 2)
        json[0, 0, 0, 0, "num"] = GSON.null
        XCTAssertEqual(json[0, 0, 0, 0, "num"].null!, GSON.null)
        json[0, 0, 0, 0, "num"] = 100.009
        XCTAssertEqual(json[0][0][0][0]["num"].doubleValue, 100.009)
        json[[0, 0, 0, 0]] = ["name": "Jack"]
        XCTAssertEqual(json[0, 0, 0, 0, "name"].stringValue, "Jack")
        XCTAssertEqual(json[0][0][0][0]["name"].stringValue, "Jack")
        XCTAssertEqual(json[[0, 0, 0, 0, "name"]].stringValue, "Jack")
        json[[0, 0, 0, 0, "name"]].string = "Mike"
        XCTAssertEqual(json[0, 0, 0, 0, "name"].stringValue, "Mike")
        let path: [GSONSubscriptType] = [0, 0, 0, 0, "name"]
        json[path].string = "Jim"
        XCTAssertEqual(json[path].stringValue, "Jim")
    }
    
    func testMultilevelSetter2() {
        var json: GSON = ["user": ["id": 987654, "info": ["name": "jack", "email": "jack@gmail.com"], "feeds": [98833, 23443, 213239, 23232]]]
        json["user", "info", "name"] = "jim"
        XCTAssertEqual(json["user", "id"], 987654)
        XCTAssertEqual(json["user", "info", "name"], "jim")
        XCTAssertEqual(json["user", "info", "email"], "jack@gmail.com")
        XCTAssertEqual(json["user", "feeds"], [98833, 23443, 213239, 23232])
        json["user", "info", "email"] = "jim@hotmail.com"
        XCTAssertEqual(json["user", "id"], 987654)
        XCTAssertEqual(json["user", "info", "name"], "jim")
        XCTAssertEqual(json["user", "info", "email"], "jim@hotmail.com")
        XCTAssertEqual(json["user", "feeds"], [98833, 23443, 213239, 23232])
        json["user", "info"] = ["name": "tom", "email": "tom@qq.com"]
        XCTAssertEqual(json["user", "id"], 987654)
        XCTAssertEqual(json["user", "info", "name"], "tom")
        XCTAssertEqual(json["user", "info", "email"], "tom@qq.com")
        XCTAssertEqual(json["user", "feeds"], [98833, 23443, 213239, 23232])
        json["user", "feeds"] = [77323, 2313, 4545, 323]
        XCTAssertEqual(json["user", "id"], 987654)
        XCTAssertEqual(json["user", "info", "name"], "tom")
        XCTAssertEqual(json["user", "info", "email"], "tom@qq.com")
        XCTAssertEqual(json["user", "feeds"], [77323, 2313, 4545, 323])
    }

    
}
