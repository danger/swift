import Foundation

protocol CurrentPathProvider {
    var currentPath: String { get }
}

final class DefaultCurrentPathProvider: CurrentPathProvider {
    var currentPath: String {
        FileManager.default.currentDirectoryPath
    }
}
