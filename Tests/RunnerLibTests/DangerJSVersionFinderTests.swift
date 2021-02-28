@testable import RunnerLib
import XCTest

final class DangerJSVersionFinderTests: XCTestCase {
    func testItSendsTheCorrectCommandAndReturnsTheCorrectResult() throws {
        let shell = ShellRunnerMock()
        shell.result = { _ in "1.0.0" }

        let dangerJSPath = "/test/danger"

        let version = DangerJSVersionFinder.findDangerJSVersion(dangerJSPath: dangerJSPath, shell: shell)

        XCTAssertEqual(shell.receivedCommands, [dangerJSPath + " --version"])
        XCTAssertEqual(version, "1.0.0")
    }
}
