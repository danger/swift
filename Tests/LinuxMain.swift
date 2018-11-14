// https://github.com/apple/swift-corelibs-xctest/blob/master/Documentation/Linux.md

import XCTest
@testable import DangerTests

XCTMain([
    testCase(CliParserTests.allTests),
    testCase(GitHubTests.allTests),
    testCase(GitTests.allTests),
    testCase(BitBucketServerTests.allTests),
    testCase(DangerDSLTests.allTests),
    testCase(DangerFileGeneratorTests.allTests),
    testCase(DateFormatterExtensionTests.allTests),
    testCase(FileTests.allTests),
    testCase(FileTypeTests.allTests),
    testCase(ImportsFinderTests.allTests),
    testCase(NSRegularExpressionExtensionsTests.allTests)
])
