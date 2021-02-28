import Logger
@testable import RunnerLib
import ShellRunnerTestUtils
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
        let shell = ShellRunnerMock()
        shell.runReturnValue = "/usr/test/danger-js"

        let path = try getDangerCommandPath(logger: logger, args: [], shell: shell)
        XCTAssertEqual(shell.calls, [.run(.init("command -v danger-js"))])
        XCTAssertEqual(path, "/usr/test/danger")
    }

    func testItSearchesForDangerIfTheDangerPathOptionIsNotPresentAndDangerJSIsNotFound() throws {
        let expectedPath = "/usr/test/danger"
        let shell = ShellRunnerMock()
        shell.runReturnValueClosure = {
            if $0.command.contains("danger-js") {
                return ""
            } else {
                return expectedPath
            }
        }

        // when
        let path = try getDangerCommandPath(logger: logger, args: [], shell: shell)

        // then
        XCTAssertEqual(
            shell.calls,
            [
                .run(.init("command -v danger-js")),
                .run(.init("command -v danger"))
            ]
        )
        XCTAssertEqual(path, expectedPath)
    }
}
