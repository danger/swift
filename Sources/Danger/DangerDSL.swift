import Foundation

// http://danger.systems/js/reference.html

// MARK: - DangerDSL

public struct DangerDSL: Decodable {

    public let git: Git

    public let github: GitHub

}
