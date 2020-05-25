import Logger
@testable import RunnerLib
import XCTest

final class GetDangerJSPathTests: XCTestCase {
    private var logger: Logger {
        Logger(isVerbose: false, isSilent: false, printer: SpyPrinter())
    }

    func testItUsesDangerJSPathOptionIfPresent() throws {
        let expectedResult = "/franco/test/danger-js"
        let path = try getDangerCommandPath(logger: logger, args: ["test", "--danger-js-path", expectedResult])
        XCTAssertEqual(path, expectedResult)
    }

    func testItSearchesForDangerJSIfDangerJSPathOptionIsNotPresent() throws {
        let executor = MockedExecutor()
        let expectedResult = "/usr/test/danger-js"
        executor.result = { _ in expectedResult }

        let path = try getDangerCommandPath(logger: logger, args: [], shellOutExecutor: executor)
        XCTAssertEqual(executor.receivedCommands, ["command -v danger-js"])
        XCTAssertEqual(path, expectedResult)
    }

    func testItSearchesForDangerIfTheDangerPathOptionIsNotPresentAndDangerJSIsNotFound() throws {
        let executor = MockedExecutor()
        let expectedResult = "/usr/test/danger"
        executor.result = { command in
            if command.hasSuffix("danger-js") {
                return ""
            } else {
                return expectedResult
            }
        }

        let path = try getDangerCommandPath(logger: logger, args: [], shellOutExecutor: executor)
        XCTAssertEqual(executor.receivedCommands, ["command -v danger-js", "command -v danger"])
        XCTAssertEqual(path, expectedResult)
    }
}
