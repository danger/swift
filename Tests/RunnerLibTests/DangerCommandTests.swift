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
            return result + command.rawValue + "\t" + command.commandDescription + "\n"
        }
        
        XCTAssertEqual(DangerCommand.commandsListText, expectedResult)
    }
}
