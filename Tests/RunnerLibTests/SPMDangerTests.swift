@testable import RunnerLib
import XCTest

final class SPMDangerTests: XCTestCase {
    var testPackage: String {
        "testPackage.swift"
    }

    func testItReturnsTrueWhenThePackageHasTheDangerLib() throws {
        let spmDanger = SPMDanger(packagePath: testPackage, readFile: { _ in ".library(name: \"DangerDeps\"" })

        XCTAssertEqual(spmDanger?.depsLibName, "DangerDeps")
    }

    func testItReturnsTrueWhenThePackageHasTheDangerLibDividedInMultipleLines() throws {
        let packageContent = """
        .library(
                 name: "DangerDeps",
                 type: .dynamic,
                 targets: ["DangerDependencies"]),
        """

        let spmDanger = SPMDanger(packagePath: testPackage, readFile: { _ in packageContent })

        XCTAssertEqual(spmDanger?.depsLibName, "DangerDeps")
    }

    func testItAcceptsAnythingStartsWithDangerDeps() throws {
        let spmDanger = SPMDanger(packagePath: testPackage, readFile: { _ in ".library(name: \"DangerDepsEigen\"" })

        XCTAssertEqual(spmDanger?.depsLibName, "DangerDepsEigen")
    }

    func testItAcceptsAnythingStartsWithDangerDepsButIsDividedInMultipleLines() throws {
        let packageContent = """
        .library(
                 name: "DangerDepsEigen",
                 type: .dynamic,
                 targets: ["DangerDependencies"]),
        """

        let spmDanger = SPMDanger(packagePath: testPackage, readFile: { _ in packageContent })

        XCTAssertEqual(spmDanger?.depsLibName, "DangerDepsEigen")
    }

    func testItReturnsFalseWhenThePackageHasNotTheDangerLib() throws {
        try "".write(toFile: testPackage, atomically: false, encoding: .utf8)

        XCTAssertNil(SPMDanger(packagePath: testPackage))
    }

    func testItReturnsFalseWhenThereIsNoPackage() {
        XCTAssertNil(SPMDanger(packagePath: testPackage))
    }

    func testItBuildsTheDependencies() throws {
        let executor = MockedExecutor()

        SPMDanger(packagePath: testPackage, readFile: { _ in ".library(name: \"DangerDeps\"" })?.buildDependencies(executor: executor)

        XCTAssertEqual(executor.receivedCommands, ["swift build --product DangerDeps"])
    }

    func testItReturnsTheCorrectXcodeDepsFlagsWhenThereIsNoDangerLib() throws {
        let fileManager = StubbedFileManager()
        fileManager.stubbedFileExists = false

        XCTAssertEqual(
            SPMDanger(packagePath: testPackage, readFile: { _ in ".library(name: \"DangerDepsEigen\"" }, fileManager: fileManager)?.xcodeImportFlags,
            ["-l DangerDepsEigen"]
        )
    }

    func testItReturnsTheCorrectXcodeDepsFlagsWhenThereIsTheDangerLib() throws {
        let fileManager = StubbedFileManager()
        fileManager.stubbedFileExists = true

        XCTAssertEqual(SPMDanger(packagePath: testPackage, readFile: { _ in ".library(name: \"DangerDepsEigen\"" }, fileManager: fileManager)?.xcodeImportFlags, ["-l DangerDepsEigen", "-l Danger"])
    }

    func testItReturnsTheCorrectSwiftcDepsImport() throws {
        XCTAssertEqual(
            SPMDanger(packagePath: testPackage, readFile: { _ in ".library(name: \"DangerDepsEigen\"" })?.swiftcLibImport,
            "-lDangerDepsEigen"
        )
    }

    func testItReturnsTheCorrectBuildFolder() throws {
        XCTAssertEqual(
            SPMDanger(packagePath: testPackage, readFile: { _ in ".library(name: \"DangerDepsEigen\"" }, fileManager: StubbedFileManager())?.buildFolder,
            "testPath/.build/debug"
        )
    }
}

private class StubbedFileManager: FileManager {
    fileprivate var stubbedFileExists: Bool = true

    override func fileExists(atPath _: String) -> Bool {
        stubbedFileExists
    }

    override var currentDirectoryPath: String {
        "testPath"
    }
}
