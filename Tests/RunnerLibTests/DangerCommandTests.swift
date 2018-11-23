//
//  DangerCommandTests.swift
//  DangerTests
//
//  Created by Franco on 23/11/2018.
//

import XCTest
@testable import RunnerLib

final class DangerCommandTests: XCTestCase {
    static var allTests = [
        ("testItReturnsTheCorrectCommandsListText", testItReturnsTheCorrectCommandsListText),
        ("testLinuxTestSuiteIncludesAllTests", testLinuxTestSuiteIncludesAllTests)
    ]
    
    func testItReturnsTheCorrectCommandsListText() {
        let expectedResult = DangerCommand.allCases.reduce("") { (result, command) -> String in
            let parameterText = command.parameterName != nil ? "\t" + command.parameterName! : ""
            
            return result + command.rawValue + parameterText + "\t" + command.commandDescription + "\n"
        }
        
        XCTAssertEqual(DangerCommand.commandsListText, expectedResult)
    }
    
    func testLinuxTestSuiteIncludesAllTests() {
        #if !os(Linux)
        let thisClass = type(of: self)
        let linuxCount = thisClass.allTests.count
        let darwinCount = thisClass.defaultTestSuite.tests.count
        XCTAssertEqual(linuxCount, darwinCount, "\(darwinCount - linuxCount) tests are missing from allTests")
        #endif
    }
}
