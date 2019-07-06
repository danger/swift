import XCTest

extension BitBucketServerTests {
    static let __allTests = [
        ("testItParsesTheBitBucketActivities", testItParsesTheBitBucketActivities),
        ("testItParsesTheBitBucketComments", testItParsesTheBitBucketComments),
        ("testItParsesTheBitBucketCommits", testItParsesTheBitBucketCommits),
        ("testItParsesTheBitBucketMetadata", testItParsesTheBitBucketMetadata),
        ("testItParsesTheBitBucketPullRequest", testItParsesTheBitBucketPullRequest),
    ]
}

extension DangerDSLTests {
    static let __allTests = [
        ("testDangerfileResults", testDangerfileResults),
        ("testFileMapWorksCorrectly", testFileMapWorksCorrectly),
        ("testGithubFixtureDSL", testGithubFixtureDSL),
        ("testItParsesCorrectlyTheDangerDSLWhenThePRIsOnBitBucketServer", testItParsesCorrectlyTheDangerDSLWhenThePRIsOnBitBucketServer),
        ("testItParsesCorrectlyTheDangerDSLWhenThePRIsOnGithubEnterprise", testItParsesCorrectlyTheDangerDSLWhenThePRIsOnGithubEnterprise),
    ]
}

extension DangerSwiftLintTests {
    static let __allTests = [
        ("testDoNotExecuteSwiftlintWhenNoFilesToCheck", testDoNotExecuteSwiftlintWhenNoFilesToCheck),
        ("testExecutesSwiftLintWhenLintingAllFiles", testExecutesSwiftLintWhenLintingAllFiles),
        ("testExecutesSwiftLintWhenLintingAllFilesWithDirectoryPassed", testExecutesSwiftLintWhenLintingAllFilesWithDirectoryPassed),
        ("testExecutesSwiftLintWithConfigWhenPassed", testExecutesSwiftLintWithConfigWhenPassed),
        ("testExecutesSwiftLintWithDirectoryPassed", testExecutesSwiftLintWithDirectoryPassed),
        ("testExecutesTheShell", testExecutesTheShell),
        ("testExecutesTheShellWithCustomSwiftLintPath", testExecutesTheShellWithCustomSwiftLintPath),
        ("testExecuteSwiftLintInInlineMode", testExecuteSwiftLintInInlineMode),
        ("testExecuteSwiftWithStructAndInlineMode", testExecuteSwiftWithStructAndInlineMode),
        ("testFiltersOnSwiftFiles", testFiltersOnSwiftFiles),
        ("testMarkdownReporting", testMarkdownReporting),
        ("testMarkdownReportingInStrictMode", testMarkdownReportingInStrictMode),
        ("testPrintsNoMarkdownIfNoViolations", testPrintsNoMarkdownIfNoViolations),
        ("testQuotesPathArguments", testQuotesPathArguments),
        ("testSendsOuputFileToTheExecutorWhenLintingAllTheFiles", testSendsOuputFileToTheExecutorWhenLintingAllTheFiles),
        ("testSendsOuputFileToTheExecutorWhenLintingModifiedFiles", testSendsOuputFileToTheExecutorWhenLintingModifiedFiles),
        ("testViolations", testViolations),
    ]
}

extension DangerUtilsLineSearchTests {
    static let __allTests = [
        ("testItReturnsAnEmptyArrayIfNoResultsAreFound", testItReturnsAnEmptyArrayIfNoResultsAreFound),
        ("testItReturnsTheCorrectResultsIfTheSearchedStringIsPresent", testItReturnsTheCorrectResultsIfTheSearchedStringIsPresent),
    ]
}

extension DangerUtilsTests {
    static let __allTests = [
        ("testLinesForStringReturnsTheCorrectResult", testLinesForStringReturnsTheCorrectResult),
    ]
}

extension DateFormatterExtensionTests {
    static let __allTests = [
        ("test_DateFormatter_dateFromString", test_DateFormatter_dateFromString),
        ("test_DateFormatter_nilFromInvalidString", test_DateFormatter_nilFromInvalidString),
    ]
}

extension DefaultDateFormatterTests {
    static let __allTests = [
        ("testParsesDateWithMilliseconds", testParsesDateWithMilliseconds),
        ("testParsesDateWithoutMilliseconds", testParsesDateWithoutMilliseconds),
    ]
}

extension FileTests {
    static let __allTests = [
        ("test_fileType_forHFile", test_fileType_forHFile),
        ("test_fileType_forJSON", test_fileType_forJSON),
        ("test_fileType_forM", test_fileType_forM),
        ("test_fileType_forMarkdown", test_fileType_forMarkdown),
        ("test_fileType_forMM", test_fileType_forMM),
        ("test_fileType_forPbxproj", test_fileType_forPbxproj),
        ("test_fileType_forPlist", test_fileType_forPlist),
        ("test_fileType_forStoryboard", test_fileType_forStoryboard),
        ("test_fileType_forSwift", test_fileType_forSwift),
        ("test_fileType_forXCScheme", test_fileType_forXCScheme),
        ("test_fileType_forYAML", test_fileType_forYAML),
        ("test_fileType_forYML", test_fileType_forYML),
        ("test_fileType_withMultipleDots", test_fileType_withMultipleDots),
    ]
}

extension FileTypeTests {
    static let __allTests = [
        ("test_extension_matchesRawValue", test_extension_matchesRawValue),
    ]
}

extension GitHubTests {
    static let __allTests = [
        ("test_GitHub_decode", test_GitHub_decode),
        ("test_GitHubBot_decode", test_GitHubBot_decode),
        ("test_GitHubCommit_decode", test_GitHubCommit_decode),
        ("test_GitHubCommit_decodesJSONWithEmptyAuthor", test_GitHubCommit_decodesJSONWithEmptyAuthor),
        ("test_GitHubIssue_decode", test_GitHubIssue_decode),
        ("test_GitHubIssue_emptyBody_decode", test_GitHubIssue_emptyBody_decode),
        ("test_GitHubIssueLabel_decode", test_GitHubIssueLabel_decode),
        ("test_GitHubMergeRef_decode", test_GitHubMergeRef_decode),
        ("test_GitHubMilestone_decodeWithAllParameters", test_GitHubMilestone_decodeWithAllParameters),
        ("test_GitHubMilestone_decodeWithoutDescription", test_GitHubMilestone_decodeWithoutDescription),
        ("test_GitHubMilestone_decodeWithSomeParameters", test_GitHubMilestone_decodeWithSomeParameters),
        ("test_GitHubPR_decode", test_GitHubPR_decode),
        ("test_GitHubRepo_decode", test_GitHubRepo_decode),
        ("test_GitHubReview_decode", test_GitHubReview_decode),
        ("test_GitHubTeam_decode", test_GitHubTeam_decode),
        ("test_GitHubUser_decode", test_GitHubUser_decode),
    ]
}

extension GitLabTests {
    static let __allTests = [
        ("testParsesCorrectlyMetadata", testParsesCorrectlyMetadata),
        ("testParsesMergeRequest", testParsesMergeRequest),
    ]
}

extension GitTests {
    static let __allTests = [
        ("test", test),
    ]
}

extension NSRegularExpressionExtensionsTests {
    static let __allTests = [
        ("test_firstMatchingString_failingRegex", test_firstMatchingString_failingRegex),
        ("test_firstMatchingString_passingRegex", test_firstMatchingString_passingRegex),
    ]
}

extension SwiftlintDefaultPathTests {
    static let __allTests = [
        ("testItReturnsTheSPMCommandIfThePackageContainsTheSwiftlintDependency", testItReturnsTheSPMCommandIfThePackageContainsTheSwiftlintDependency),
        ("testItReturnsTheSwiftlintCLICommandIfThePackageContainsTheSwiftlintDependency", testItReturnsTheSwiftlintCLICommandIfThePackageContainsTheSwiftlintDependency),
    ]
}

extension ViolnationTests {
    static let __allTests = [
        ("testDecoding", testDecoding),
    ]
}

#if !os(macOS)
    public func __allTests() -> [XCTestCaseEntry] {
        return [
            testCase(BitBucketServerTests.__allTests),
            testCase(DangerDSLTests.__allTests),
            testCase(DangerSwiftLintTests.__allTests),
            testCase(DangerUtilsLineSearchTests.__allTests),
            testCase(DangerUtilsTests.__allTests),
            testCase(DateFormatterExtensionTests.__allTests),
            testCase(DefaultDateFormatterTests.__allTests),
            testCase(FileTests.__allTests),
            testCase(FileTypeTests.__allTests),
            testCase(GitHubTests.__allTests),
            testCase(GitLabTests.__allTests),
            testCase(GitTests.__allTests),
            testCase(NSRegularExpressionExtensionsTests.__allTests),
            testCase(SwiftlintDefaultPathTests.__allTests),
            testCase(ViolnationTests.__allTests),
        ]
    }
#endif
