import Foundation
import OctoKit

// http://danger.systems/js/reference.html

// MARK: - DangerDSL

public struct DSL: Decodable {
    /// The root danger import
    public let danger: DangerDSL
}

public struct DangerDSL: Decodable {
    public let git: Git

    public private(set) var github: GitHub!

    public let bitbucketCloud: BitBucketCloud!

    public let bitbucketServer: BitBucketServer!

    public let gitLab: GitLab!

    public let utils: DangerUtils

    enum CodingKeys: String, CodingKey {
        case git
        case github
        case bitbucketServer = "bitbucket_server"
        case bitbucketCloud = "bitbucket_cloud"
        case gitlab
        case settings
        // Used by plugin testing only
        // See: githubJSONWithFiles
        case fileMap
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        git = try container.decode(Git.self, forKey: .git)
        github = try container.decodeIfPresent(GitHub.self, forKey: .github)
        bitbucketServer = try container.decodeIfPresent(BitBucketServer.self, forKey: .bitbucketServer)
        bitbucketCloud = try container.decodeIfPresent(BitBucketCloud.self, forKey: .bitbucketCloud)
        gitLab = try container.decodeIfPresent(GitLab.self, forKey: .gitlab)

        let settings = try container.decode(Settings.self, forKey: .settings)

        // File map is used so that libraries can make tests without
        // doing a lot of internal hacking for danger, or weird DI in their
        // own code. A bit of a trade-off in complexity for Danger Swift, but I
        // think if it leads to more tested plugins, it's a good spot to be in.
        if let fileMap = try container.decodeIfPresent([String: String].self, forKey: .fileMap) {
            utils = DangerUtils(fileMap: fileMap)
        } else {
            utils = DangerUtils(fileMap: [:])
        }

        // Setup the OctoKit once all other
        if runningOnGithub {
            let config: TokenConfiguration
            
            if let baseURL = settings.github.baseURL {
                config = TokenConfiguration(settings.github.accessToken, url: baseURL)
            } else {
                config = TokenConfiguration(settings.github.accessToken)
            }

            github.api = Octokit(config)
        }
    }
}

extension DangerDSL {
    var runningOnGithub: Bool {
        github != nil
    }

    var runningOnBitbucketServer: Bool {
        bitbucketServer != nil
    }

    var supportsSuggestions: Bool {
        runningOnGithub
    }
}
