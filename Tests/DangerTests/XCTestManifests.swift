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
        ("testItParsesCorrectlyTheDangerDSLWhenThePRIsOnBitBucketServer", testItParsesCorrectlyTheDangerDSLWhenThePRIsOnBitBucketServer),
        ("testItParsesCorrectlyTheDangerDSLWhenThePRIsOnGithub", testItParsesCorrectlyTheDangerDSLWhenThePRIsOnGithub),
        ("testItParsesCorrectlyTheDangerDSLWhenThePRIsOnGithubEnterprise", testItParsesCorrectlyTheDangerDSLWhenThePRIsOnGithubEnterprise),
    ]
}

extension DateFormatterExtensionTests {
    static let __allTests = [
        ("test_DateFormatter_dateFromString", test_DateFormatter_dateFromString),
        ("test_DateFormatter_nilFromInvalidString", test_DateFormatter_nilFromInvalidString),
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
        ("test_GitHubCommit_decode", test_GitHubCommit_decode),
        ("test_GitHubIssue_decode", test_GitHubIssue_decode),
        ("test_GitHubIssueLabel_decode", test_GitHubIssueLabel_decode),
        ("test_GitHubMergeRef_decode", test_GitHubMergeRef_decode),
        ("test_GitHubMilestone_decodeWithAllParameters", test_GitHubMilestone_decodeWithAllParameters),
        ("test_GitHubMilestone_decodeWithSomeParameters", test_GitHubMilestone_decodeWithSomeParameters),
        ("test_GitHubPR_decode", test_GitHubPR_decode),
        ("test_GitHubRepo_decode", test_GitHubRepo_decode),
        ("test_GitHubReview_decode", test_GitHubReview_decode),
        ("test_GitHubTeam_decode", test_GitHubTeam_decode),
        ("test_GitHubUser_decode", test_GitHubUser_decode),
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

#if !os(macOS)
    public func __allTests() -> [XCTestCaseEntry] {
        return [
            testCase(BitBucketServerTests.__allTests),
            testCase(DangerDSLTests.__allTests),
            testCase(DateFormatterExtensionTests.__allTests),
            testCase(FileTests.__allTests),
            testCase(FileTypeTests.__allTests),
            testCase(GitHubTests.__allTests),
            testCase(GitTests.__allTests),
            testCase(NSRegularExpressionExtensionsTests.__allTests),
        ]
    }
#endif
