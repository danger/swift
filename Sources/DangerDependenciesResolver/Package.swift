import Foundation
import Version

public struct Package: Equatable, Codable {
    public let name: String
    public let url: URL
    public var majorVersion: Int
    public var minorVersion: Int?
    public var patchVersion: Int?
}

extension Package {
    func dependencyString(forToolsVersion version: Version) -> String {
        switch version {
        case Version(5, 6, 0)...:
            if let minorVersion, let patchVersion {
                return #".package(url: "\#(url.absoluteString)", exact: "\#(majorVersion).\#(minorVersion).\#(patchVersion)")"#
            } else {
                return #".package(url: "\#(url.absoluteString)", from: "\#(majorVersion).0.0")"#
            }
        case Version(5, 2, 0)...:
            if let minorVersion, let patchVersion {
                return #".package(name: "\#(name)", url: "\#(url.absoluteString)", .exact("\#(majorVersion).\#(minorVersion).\#(patchVersion)"))"#
            } else {
                return #".package(name: "\#(name)", url: "\#(url.absoluteString)", from: "\#(majorVersion).0.0")"#
            }
        default:
            if let minorVersion, let patchVersion {
                return #".package(url: "\#(url.absoluteString)", .exact("\#(majorVersion).\#(minorVersion).\#(patchVersion)"))"#
            } else {
                return #".package(url: "\#(url.absoluteString)", from: "\#(majorVersion).0.0")"#
            }
        }
    }

    func targetDependencyString(forToolsVersion version: Version) -> String {
        switch version {
        case Version(5, 6, 0)...:
            return #".product(name: "\#(name)", package: "\#(url.lastPathComponent.replacingOccurrences(of: ".git", with: ""))")"#
        default:
            return "\"\(name)\""
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

extension Sequence<Package.PinnedV2> {
    func v1Converted() -> [Package.Pinned] {
        map(\.v1)
    }
}
