import XCTest

import localizeTests

var tests = [XCTestCaseEntry]()
tests += localizeTests.allTests()
XCTMain(tests)