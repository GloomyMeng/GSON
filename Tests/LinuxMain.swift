import XCTest

import GSONTests

var tests = [XCTestCaseEntry]()
tests += GSONTests.allTests()
XCTMain(tests)