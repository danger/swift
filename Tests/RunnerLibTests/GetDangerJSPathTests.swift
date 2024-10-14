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
        executor.result = { _ in "/usr/test/danger-js" }

        let path = try getDangerCommandPath(logger: logger, args: [], shellOutExecutor: executor)
        XCTAssertEqual(executor.receivedCommands, ["command -v danger-js"])
        XCTAssertEqual(path, "/usr/test/danger")
    }

    func testItSearchesForDangerIfTheDangerPathOptionIsNotPresentAndDangerJSIsNotFound() throws {
        let executor = MockedExecutor()
        let expectedResult = "/usr/test/danger"
        executor.result = { command in
            if command.hasSuffix("danger-js") {
                ""
            } else {
                expectedResult
            }
        }

        let path = try getDangerCommandPath(logger: logger, args: [], shellOutExecutor: executor)
        XCTAssertEqual(executor.receivedCommands, ["command -v danger-js", "command -v danger"])
        XCTAssertEqual(path, expectedResult)
    }
}
