import Foundation

extension URL {
    var isForRemoteRepository: Bool {
        return absoluteString.hasSuffix(".git")
    }
}
