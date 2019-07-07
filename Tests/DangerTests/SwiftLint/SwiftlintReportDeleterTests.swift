@testable import Danger
import XCTest

final class SwiftlintReportDeleterTests: XCTestCase {
    func testCallsRemoveItemOnFileManager() throws {
        let spyFileManager = SpyFileManager()
        let deleter = SwiftlintReportDeleter(fileManager: spyFileManager)
        let testPath = "testPath"

        try deleter.deleteReport(atPath: testPath)

        XCTAssertEqual(spyFileManager.receivedPath, testPath)
    }
}

private class SpyFileManager: FileManager {
    private(set) var receivedPath: String?

    override func removeItem(atPath path: String) throws {
        receivedPath = path
    }
}
