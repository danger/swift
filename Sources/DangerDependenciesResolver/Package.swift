import Foundation
import Version

public struct Package: Equatable, Codable {
    public let name: String
    public let url: URL
    public var majorVersion: Int
}

extension Package {
    var dependencyString: String {
        return ".package(url: \"\(url.absoluteString)\", from: \"\(majorVersion).0.0\")"
    }
}

extension Package {
    struct Pinned: Decodable, Equatable {
        enum CodingKeys: String, CodingKey {
            case name = "package"
            case url = "repositoryURL"
            case state
        }

        struct State: Decodable, Equatable {
            let version: Version
        }

        let name: String
        let url: URL
        let state: State
    }
}
