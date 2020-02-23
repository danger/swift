import Foundation

protocol FileCreating {
    func createFile(atPath path: String, contents: Data)
}

struct FileCreator: FileCreating {
    func createFile(atPath path: String, contents: Data) {
        FileManager.default.createFile(atPath: path, contents: contents, attributes: [:])
    }
}
