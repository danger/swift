import Foundation

extension URL {
    var isForRemoteRepository: Bool {
        absoluteString.hasSuffix(".git")
    }
}
