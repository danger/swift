import Foundation

struct ScriptFile {
    enum Errors: Error {
        case failedToRead(String)
    }

    private(set) var packageURLs = [URL]()
    private(set) var scriptURLs = [URL]()

    // MARK: - Init

    init(path: String) throws {
        guard let content = try? String(contentsOfFile: path).components(separatedBy: .newlines) else {
            throw Errors.failedToRead(path)
        }

        for urlString in content {
            guard !urlString.isEmpty else {
                continue
            }

            let url = try absoluteURL(from: urlString, filePath: path)

            if url.isForScript {
                scriptURLs.append(url)
            } else {
                packageURLs.append(url)
            }
        }
    }

    // MARK: - Private

    private func absoluteURL(from urlString: String, filePath path: String) throws -> URL {
        guard let url = URL(string: urlString) else {
            throw Errors.failedToRead(path)
        }

        guard !url.isForRemoteRepository else {
            return url
        }

        guard !urlString.hasPrefix("/"), !urlString.hasPrefix("~") else {
            return url
        }

        throw Errors.failedToRead(path)

//        guard let item = path.sibling(at: url) else {
//            throw Errors.failedToRead(file)
//        }
//
//        return URL(string: item.path)!
    }
}

extension URL {
    var isForRemoteRepository: Bool {
        return absoluteString.hasSuffix(".git")
    }

    fileprivate var isForScript: Bool {
        return absoluteString.hasSuffix(".swift")
    }
}
