import Logger
@testable import RunnerLib
import XCTest

final class GetDangerJSPathTests: XCTestCase {
    private let logger = Logger(isVerbose: false, isSilent: false, printer: SpyPrinter())

    func testItUsesTheDangerJSPathOptionIfPresent() throws {
        let expectedResult = "/franco/test/danger-js"
        let path = try getDangerCommandPath(logger: logger, args: ["test", "--danger-js-path", expectedResult])
        XCTAssertEqual(path, expectedResult)
    }

    func testItSearchesForDangerJSIfTheDangerJSPathOptionIsNotPresent() throws {
        let executor = MockedExecutor()
        let expectedResult = "/usr/test/danger-js"
        executor.result = expectedResult

        let path = try getDangerCommandPath(logger: logger, args: [], shellOutExecutor: executor)
        XCTAssertEqual(executor.receivedCommand, "command -v danger")
        XCTAssertEqual(path, expectedResult)
    }
}
