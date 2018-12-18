@testable import RunnerLib
import XCTest

final class DangerCommandTests: XCTestCase {
    func testItReturnsTheCorrectCommandsListText() {
        let expectedResult = DangerCommand.allCases.reduce("") { (result, command) -> String in
            return result + command.rawValue + "\t" + command.commandDescription + "\n"
        }

        XCTAssertEqual(DangerCommand.commandsListText, expectedResult)
    }
}
