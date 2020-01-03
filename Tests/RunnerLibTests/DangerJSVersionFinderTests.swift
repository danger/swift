@testable import RunnerLib
import XCTest

final class DangerJSVersionFinderTests: XCTestCase {
    func testItSendsTheCorrectCommandAndReturnsTheCorrectResult() throws {
        let executor = MockedExecutor()
        executor.result = "1.0.0"

        let dangerJSPath = "/test/danger"

        let version = DangerJSVersionFinder.findDangerJSVersion(dangerJSPath: dangerJSPath, executor: executor)

        XCTAssertEqual(executor.receivedCommand, dangerJSPath + " --version")
        XCTAssertEqual(version, executor.result)
    }
}
