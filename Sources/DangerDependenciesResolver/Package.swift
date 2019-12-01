import Foundation
import Version

extension Package {
    var dependencyString: String {
        return ".package(url: \"\(url.absoluteString)\", from: \"\(majorVersion).0.0\")"
    }
}

extension Package {
    struct Pinned: Decodable {
        enum CodingKeys: String, CodingKey {
            case name = "package"
            case url = "repositoryURL"
            case state
        }

        struct State: Decodable {
            let version: Version
        }

        let name: String
        let url: URL
        let state: State
    }
}
