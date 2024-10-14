import Danger
import Foundation

/// A function to set up a Danger DSL from a JSON string,
/// you can use Danger JS to generate the JSON strings by using
///
///   danger pr --json [pr_url]
///
///   e.g. danger pr --json https://github.com/danger/swift/pull/65 --dangerfile Dangerfile.swift
///
/// as this is a testing util, it is assumed you've set it up with
/// working fixtured or it will raise an exception.
///
/// - Parameter body: a string representing the JSON from danger pr
/// - Returns: a DangerDSL
///
public func parseDangerDSL(with body: String) -> DangerDSL {
    let dslJSONContents = Data(body.utf8)
    let decoder = JSONDecoder()
    decoder.dateDecodingStrategy = .custom(DateFormatter.dateFormatterHandler)
    return try! decoder.decode(DSL.self, from: dslJSONContents).danger // swiftlint:disable:this force_try
}

/// An example DSL using GitHub
public let githubFixtureDSL = parseDangerDSL(with: DSLGitHubJSON)
/// An example DSL using GitHub Enterprise
public let githubEnterpriseFixtureDSL = parseDangerDSL(with: DSLGitHubEnterpriseJSON)
/// An example DSL using BitBucket Server
public let bitbucketFixtureDSL = parseDangerDSL(with: DSLBitBucketServerJSON)
/// An example DSL without public field in fromRef using BitBucket Sever
public let bitbucketForkedRepoFixtureDSL = parseDangerDSL(with: DSLBitBucketServerForkedRepoJSON)
/// An example DSL using GitLab
public let gitlabFixtureDSL = parseDangerDSL(with: DSLGitLabJSON)
/// An example DSL without milestone date range using GitLab
public let gitlabMilestoneNoDateRangeFixtureDSL = parseDangerDSL(with: DSLGitLabMilestoneNoDateRangeJSON)
/// An example DSL using BitBucket Cloud
public let bitbucketCloudFixtureDSL = parseDangerDSL(with: DSLBitBucketCloudJSON)
/// An example DSL using GitHub
public func githubWithFilesDSL(created: [File] = [],
                               modified: [File] = [],
                               deleted: [File] = [],
                               fileMap: [String: String] = [:]) -> DangerDSL
{
    parseDangerDSL(with: githubJSONWithFiles(created: created,
                                             modified: modified,
                                             deleted: deleted,
                                             fileMap: fileMap))
}
