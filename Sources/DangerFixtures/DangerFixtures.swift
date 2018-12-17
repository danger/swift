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
    let dslJSONContents = body.data(using: .utf8)!
    let decoder = JSONDecoder()
    if #available(OSX 10.12, *) {
        decoder.dateDecodingStrategy = .iso8601
    } else {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZ"
        decoder.dateDecodingStrategy = .formatted(dateFormatter)
    }
    return try! decoder.decode(DSL.self, from: dslJSONContents).danger
}

/// An example DSL using GitHub
public let githubFixtureDSL = parseDangerDSL(with: DSLGitHubJSON)
/// An example DSL using GitHub Enterprise
public let githubEnterpriseFixtureDSL = parseDangerDSL(with: DSLGitHubEnterpriseJSON)
/// An example DSL using BitBucket
public let bitbucketFixtureDSL = parseDangerDSL(with: DSLBitBucketServerJSON)
/// An example DSL using GitHub
public func githubWithFilesDSL(created: [File] = [], modified: [File] = [], deleted: [File] = [], fileMap: [String: String] = [:]) -> DangerDSL {
    return parseDangerDSL(with: githubJSONWithFiles(created: created, modified: modified, deleted: deleted, fileMap: fileMap))
}
