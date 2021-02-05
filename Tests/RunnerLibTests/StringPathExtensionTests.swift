@testable import RunnerLib
import XCTest

public class StringPathExtensionTests: XCTestCase {
    func testAppendingPathWhenPathEndsWithSlash() {
        XCTAssertEqual("/usr/".appendingPath("f-meloni"), "/usr/f-meloni")
    }

    func testAppendingPathWhenPathEndsWithoutSlash() {
        XCTAssertEqual("/usr".appendingPath("f-meloni"), "/usr/f-meloni")
    }

    func testRemovingLastPathComponentWhenPathHasOnlyOneComponent() {
        XCTAssertEqual("usr".removingLastPathComponent(), "usr")
    }

    func testRemovingLastPathComponentWhenPathHasOnlyOneComponentAndStartsWithSlash() {
        XCTAssertEqual("/usr".removingLastPathComponent(), "/usr")
    }

    func testRemovingLastPathComponentWhenPathHasMoreThanOneComponentAndStartsWithSlash() {
        XCTAssertEqual("usr/f-meloni".removingLastPathComponent(), "usr")
    }

    func testRemovingLastPathComponentWhenPathHasMoreThanOneComponent() {
        XCTAssertEqual("/usr/f-meloni".removingLastPathComponent(), "/usr")
    }
}
