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

    public let github: GitHub!

    public let bitbucketServer: BitBucketServer!

    public let utils = DangerUtils()

    enum CodingKeys: String, CodingKey {
        case git
        case github
        case bitbucketServer = "bitbucket_server"
        case settings
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        git = try container.decode(Git.self, forKey: .git)
        github = try container.decodeIfPresent(GitHub.self, forKey: .github)
        bitbucketServer = try container.decodeIfPresent(BitBucketServer.self, forKey: .bitbucketServer)

        let settings = try container.decode(Settings.self, forKey: .settings)

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
        return github != nil
    }

    var runningOnBitbucketServer: Bool {
        return bitbucketServer != nil
    }

    var supportsSuggestions: Bool {
        return runningOnGithub
    }
}
