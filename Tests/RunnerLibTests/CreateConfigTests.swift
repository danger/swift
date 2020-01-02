import RunnerLib
import SnapshotTesting
import XCTest

final class CreateConfigTests: XCTestCase {
    func testItCreatesTheCorrectConfig() throws {
        record = false
        let testPath = "test"
        try createConfig(atPath: testPath, libPath: "libPath", libsImport: ["-lDangerDeps", "-lDanger"])

        let createdConfig = try String(contentsOfFile: testPath)

        assertSnapshot(matching: createdConfig, as: .lines)

        try? FileManager.default.removeItem(atPath: testPath)
    }
}
