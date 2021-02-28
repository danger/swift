@testable import RunnerLib
import ShellRunnerTestUtils
import XCTest

final class DangerJSVersionFinderTests: XCTestCase {
    func testItSendsTheCorrectCommandAndReturnsTheCorrectResult() throws {
        let shell = ShellRunnerMock()
        shell.runReturnValue = "1.0.0"

        let dangerJSPath = "/test/danger"

        let version = DangerJSVersionFinder.findDangerJSVersion(dangerJSPath: dangerJSPath, shell: shell)

        XCTAssertEqual(shell.calls, [.run(.init(dangerJSPath, ["--version"]))])
        XCTAssertEqual(version, "1.0.0")
    }
}
