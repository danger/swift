import Foundation
import OctoKit

// http://danger.systems/js/reference.html

// MARK: - DangerDSL

public struct DSL: Decodable {
    /// The root danger import
    public let danger: DangerDSL
}

public struct DangerDSL: Decodable {
    public enum Remote {
        case github(GitHub)
        case bitbucketServer(BitBucketServer)
        case unknown
    }
    
    public let git: Git

    public let remote: Remote

    public let utils: DangerUtils

    enum CodingKeys: String, CodingKey {
        case git
        case github
        case bitbucketServer = "bitbucket_server"
        case settings
        // Used by plugin testing only
        // See: githubJSONWithFiles
        case fileMap
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        git = try container.decode(Git.self, forKey: .git)
        
        if let github = try container.decodeIfPresent(GitHub.self, forKey: .github) {
            remote = .github(github)
        } else if let bitbucketServer = try container.decodeIfPresent(BitBucketServer.self, forKey: .bitbucketServer) {
            remote = .bitbucketServer(bitbucketServer)
        } else {
            remote = .unknown
        }

        // File map is used so that libraries can make tests without
        // doing a lot of internal hacking for danger, or weird DI in their
        // own code. A bit of a trade-off in complexity for Danger Swift, but I
        // think if it leads to more tested plugins, it's a good spot to be in.
        do {
            let fileMap = try container.decode([String: String].self, forKey: .fileMap)
            utils = DangerUtils(fileMap: fileMap)
        } catch {
            utils = DangerUtils(fileMap: [:])
        }
    }
}

extension DangerDSL {
    var runningOnGithub: Bool {
        if case .github = remote {
            return true
        } else {
            return false
        }
    }

    var runningOnBitbucketServer: Bool {
        if case .bitbucketServer = remote {
            return true
        } else {
            return false
        }
    }

    var supportsSuggestions: Bool {
        return runningOnGithub
    }
}
