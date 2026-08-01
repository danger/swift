@testable import DangerDependenciesResolver
import Foundation
import Logger
import XCTest

final class ScriptTests: XCTestCase {
    private func makeScript(fileManager: FileManager) -> Script {
        Script(
            name: "TestScript",
            folder: "scriptFolder",
            logger: Logger(isVerbose: false, isSilent: false, printer: SpyPrinter()),
            fileManager: fileManager
        )
    }

    func testArtifactsPathReturnsFlatWhenOnlyTheFlatModuleExists() throws {
        let fileManager = ScriptStubbedFileManager()
        fileManager.existingPaths = ["scriptFolder/.build/debug/Danger.swiftmodule"]

        XCTAssertEqual(
            makeScript(fileManager: fileManager).artifactsPath,
            [".build/debug", expectedCompiledDefaultReleaseFolder]
        )
    }

    func testArtifactsPathReturnsNestedWhenOnlyTheNestedModuleExists() throws {
        let fileManager = ScriptStubbedFileManager()
        fileManager.existingPaths = ["scriptFolder/.build/debug/Modules/Danger.swiftmodule"]

        XCTAssertEqual(
            makeScript(fileManager: fileManager).artifactsPath,
            [".build/debug/Modules", expectedCompiledDefaultReleaseFolder]
        )
    }

    func testArtifactsPathFallsBackToTheCompiledDefaultWhenBothModulesExist() throws {
        let fileManager = ScriptStubbedFileManager()
        fileManager.existingPaths = [
            "scriptFolder/.build/debug/Danger.swiftmodule",
            "scriptFolder/.build/debug/Modules/Danger.swiftmodule",
        ]

        XCTAssertEqual(
            makeScript(fileManager: fileManager).artifactsPath,
            [expectedCompiledDefaultDebugFolder, expectedCompiledDefaultReleaseFolder]
        )
    }

    func testArtifactsPathFallsBackToTheCompiledDefaultWhenNeitherModuleExists() throws {
        let fileManager = ScriptStubbedFileManager()
        fileManager.existingPaths = []

        XCTAssertEqual(
            makeScript(fileManager: fileManager).artifactsPath,
            [expectedCompiledDefaultDebugFolder, expectedCompiledDefaultReleaseFolder]
        )
    }

    func testArtifactsPathProbesUnderTheScriptFolderNotTheProcessCwd() throws {
        let fileManager = ScriptStubbedFileManager()
        // Only exists relative to the process cwd, not under "scriptFolder" — must not match.
        fileManager.existingPaths = [".build/debug/Danger.swiftmodule"]

        XCTAssertEqual(
            makeScript(fileManager: fileManager).artifactsPath,
            [expectedCompiledDefaultDebugFolder, expectedCompiledDefaultReleaseFolder]
        )
    }

    private var expectedCompiledDefaultDebugFolder: String {
        #if compiler(<6.0)
            ".build/debug"
        #else
            ".build/debug/Modules"
        #endif
    }

    private var expectedCompiledDefaultReleaseFolder: String {
        #if compiler(<6.0)
            ".build/release"
        #else
            ".build/release/Modules"
        #endif
    }
}

private class ScriptStubbedFileManager: FileManager {
    fileprivate var existingPaths: Set<String> = []

    override func fileExists(atPath path: String) -> Bool {
        existingPaths.contains(path)
    }
}
