import Foundation

// http://danger.systems/js/reference.html

// MARK: - DangerDSL

public struct DSL: Decodable {
    /// The root danger import
    public let danger: DangerDSL
}

public struct DangerDSL: Decodable {
    public let git: Git

    public let github: GitHub
}
