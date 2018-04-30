// https://github.com/apple/swift-corelibs-xctest/blob/master/Documentation/Linux.md

import XCTest
@testable import DangerTests

XCTMain([
    testCase(GitHubTests.allTests),
    testCase(GitTests.allTests),
    testCase(BitBucketServerTests.allTests)
])
