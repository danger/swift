import Foundation
import Version

public struct Package: Equatable, Codable {
    public let name: String
    public let url: URL
    public var majorVersion: Int
}

extension Package {
    func dependencyString(forToolsVersion version: Version) -> String {
        if version >= Version(major: 5, minor: 2, patch: 0) {
            return #".package(name: "\#(name)", url: "\#(url.absoluteString)", from: "\#(majorVersion).0.0")"#
        } else {
            return #".package(url: "\#(url.absoluteString)", from: "\#(majorVersion).0.0")"#
        }
    }
}

extension Package {
    struct Pinned: Decodable, Equatable {
        let name: String
        let url: URL
        let state: State
    }
}

extension Package.Pinned {
    enum CodingKeys: String, CodingKey {
        case name = "package"
        case url = "repositoryURL"
        case state
    }
}

extension Package.Pinned {
    struct State: Decodable, Equatable {
        let version: Version
    }
}

// MARK: - swift-tools-version >= 5.6

extension Package {
    struct PinnedV2: Decodable, Equatable {
        let name: String
        let url: URL
        let state: State
    }
}

extension Package.PinnedV2 {
    enum CodingKeys: String, CodingKey {
        case name = "identity"
        case url = "location"
        case state
    }
}

extension Package.PinnedV2 {
    struct State: Decodable, Equatable {
        let version: Version
    }
}

extension Package.PinnedV2 {
    var v1: Package.Pinned {
        .init(
            name: name,
            url: url,
            state: .init(version: state.version)
        )
    }
}

// MARK: -

extension Sequence where Element == Package.PinnedV2 {
    func v1Converted() -> [Package.Pinned] {
        map(\.v1)
    }
}
