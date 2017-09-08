// https://github.com/apple/swift-corelibs-xctest/blob/master/Documentation/Linux.md

import XCTest
@testable import Danger

XCTMain([
    testCase(GitHubTests.allTests),
])
