import XCTest

import DangerTests
import RunnerLibTests

var tests = [XCTestCaseEntry]()
tests += DangerTests.__allTests()
tests += RunnerLibTests.__allTests()

XCTMain(tests)
