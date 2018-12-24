@testable import RunnerLib
import XCTest

final class DangerJSVersionFinderTests: XCTestCase {
    func testItSendsTheCorrectCommandAndReturnsTheCorrectResult() throws {
        let executor = MockedExecutor()
        executor.result = "1.0.0"

        let dangerJSPath = "/test/danger"

        let version = try DangerJSVersionFinder.findDangerJSVersion(dangerJSPath: dangerJSPath, executor: executor)

        XCTAssertEqual(executor.receivedCommand, dangerJSPath + " --version")
        XCTAssertEqual(version, executor.result)
    }
}

private final class MockedExecutor: ShellOutExecuting {
    var receivedCommand: String!
    var result = ""

    func shellOut(command: String) throws -> String {
        receivedCommand = command
        return result
    }
}
