@testable import Danger

final class FakeCurrentPathProvider: CurrentPathProvider {
    var currentPath: String = ""
}
