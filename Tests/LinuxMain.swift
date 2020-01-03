import XCTest

import DangerDependenciesResolverTests
import DangerTests
import RunnerLibTests

var tests = [XCTestCaseEntry]()
tests += DangerDependenciesResolverTests.__allTests()
tests += DangerTests.__allTests()
tests += RunnerLibTests.__allTests()

XCTMain(tests)
