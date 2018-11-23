//
//  DangerCommandTests.swift
//  DangerTests
//
//  Created by Franco on 23/11/2018.
//

import XCTest
@testable import RunnerLib

final class DangerCommandTests: XCTestCase {
    func testItReturnsTheCorrectCommandsListText() {
        let expectedResult = DangerCommand.allCases.reduce("") { (result, command) -> String in
            let parameterText = command.parameterName != nil ? "\t" + command.parameterName! : ""
            
            return result + command.rawValue + parameterText + "\t" + command.commandDescription + "\n"
        }
        
        XCTAssertEqual(DangerCommand.commandsListText, expectedResult)
    }
}
