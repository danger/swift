//
//  VersionCheckerTests.swift
//
//
//  Created by 417.72KI on 2022/02/20.
//

import Logger
@testable import RunnerLib
import XCTest

final class VersionCheckerTests: XCTestCase {
    private var executor: MockedExecutor!
    private var spyPrinter: SpyPrinter!

    override func setUp() {
        executor = MockedExecutor()
        spyPrinter = SpyPrinter()
    }

    func testItShowsNotificationIfNewVersionIsAvailable() throws {
        executor.result = mockResult(tagName: "1.0.1")

        let versionChecker = VersionChecker(
            shellExecutor: executor,
            logger: Logger(
                isVerbose: false,
                isSilent: false,
                printer: spyPrinter
            )
        )
        versionChecker.checkForUpdate(current: "1.0.0")
        XCTAssertTrue(spyPrinter.printedMessages.contains { $0.contains("A new release of danger-swift is available") })
    }

    func testItNotShowNotificationIfRunningIsLatest() throws {
        executor.result = mockResult(tagName: "1.0.0")

        let versionChecker = VersionChecker(
            shellExecutor: executor,
            logger: Logger(
                isVerbose: false,
                isSilent: false,
                printer: spyPrinter
            )
        )
        versionChecker.checkForUpdate(current: "1.0.0")
        XCTAssertFalse(spyPrinter.printedMessages.contains { $0.contains("A new release of danger-swift is available") })
    }
}

private extension VersionCheckerTests {
    func mockResult(tagName: String) -> (String) -> String {
        { _ in #"{"tagName": "\#(tagName)"}"# }
    }
}
