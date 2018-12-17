import Foundation

extension URL {
    func deletingLastPathComponent(_ count: Int) -> URL {
        guard count > 0 else { return self }

        var newUrl = self
        (0 ... count).forEach { _ in newUrl.deleteLastPathComponent() }

        return newUrl
    }
}
