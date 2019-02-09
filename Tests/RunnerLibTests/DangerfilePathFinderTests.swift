@testable import RunnerLib
import XCTest

final class DangerfilePathFinderTests: XCTestCase {
    func testItReturnsTheCorrectPathIfTheArgumentsContainsTheDangerfileArg() {
        let arguments = ["--id", "danger", "--dangerfile", "Dangertest.swift"]

        XCTAssertEqual(DangerfilePathFinder.dangerfilePath(fromArguments: arguments), "Dangertest.swift")
    }

    func testItReturnsNilIfTheArgumentsDoesntContainTheDangerfileArg() {
        let arguments = ["--id", "danger"]

        XCTAssertEqual(DangerfilePathFinder.dangerfilePath(fromArguments: arguments), nil)
    }
}
