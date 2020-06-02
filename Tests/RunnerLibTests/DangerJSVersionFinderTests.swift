@testable import RunnerLib
import XCTest

final class DangerJSVersionFinderTests: XCTestCase {
    func testItSendsTheCorrectCommandAndReturnsTheCorrectResult() throws {
        let executor = MockedExecutor()
        executor.result = { _ in "1.0.0" }

        let dangerJSPath = "/test/danger"

        let version = DangerJSVersionFinder.findDangerJSVersion(dangerJSPath: dangerJSPath, executor: executor)

        XCTAssertEqual(executor.receivedCommands, [dangerJSPath + " --version"])
        XCTAssertEqual(version, "1.0.0")
    }
}
