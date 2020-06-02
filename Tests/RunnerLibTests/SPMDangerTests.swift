@testable import RunnerLib
import XCTest

final class SPMDangerTests: XCTestCase {
    var testPackage: String {
        "testPackage.swift"
    }

    override func tearDown() {
        try? FileManager.default.removeItem(atPath: testPackage)

        super.tearDown()
    }

    func testItReturnsTrueWhenThePackageHasTheDangerLib() throws {
        try ".library(name: \"DangerDeps\"".write(toFile: testPackage, atomically: false, encoding: .utf8)

        let spmDanger = SPMDanger(packagePath: testPackage)

        XCTAssertEqual(spmDanger?.depsLibName, "DangerDeps")
    }

    func testItAcceptsAnythingStartsWithDangerDeps() throws {
        try ".library(name: \"DangerDepsEigen\"".write(toFile: testPackage, atomically: false, encoding: .utf8)

        let spmDanger = SPMDanger(packagePath: testPackage)

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
        let fileManager = StubbedFileManager()
        fileManager.stubbedFileExists = false

        try ".library(name: \"DangerDeps\"".write(toFile: testPackage, atomically: false, encoding: .utf8)
        SPMDanger(packagePath: testPackage)?.buildDependencies(executor: executor, fileManager: fileManager)

        XCTAssertEqual(executor.receivedCommands, ["swift build --product DangerDeps"])
    }

    func testItReturnsTheCorrectXcodeDepsFlagsWhenThereIsNoDangerLib() throws {
        try ".library(name: \"DangerDepsEigen\"".write(toFile: testPackage, atomically: false, encoding: .utf8)
        let fileManager = StubbedFileManager()
        fileManager.stubbedFileExists = false

        XCTAssertEqual(SPMDanger(packagePath: testPackage, fileManager: fileManager)?.xcodeImportFlags, ["-l DangerDepsEigen"])
    }

    func testItReturnsTheCorrectXcodeDepsFlagsWhenThereIsTheDangerLib() throws {
        try ".library(name: \"DangerDepsEigen\"".write(toFile: testPackage, atomically: false, encoding: .utf8)
        let fileManager = StubbedFileManager()
        fileManager.stubbedFileExists = true

        XCTAssertEqual(SPMDanger(packagePath: testPackage, fileManager: fileManager)?.xcodeImportFlags, ["-l DangerDepsEigen", "-l Danger"])
    }

    func testItReturnsTheCorrectSwiftcDepsImport() throws {
        try ".library(name: \"DangerDepsEigen\"".write(toFile: testPackage, atomically: false, encoding: .utf8)

        XCTAssertEqual(SPMDanger(packagePath: testPackage)?.swiftcLibImport, "-lDangerDepsEigen")
    }

    func testItReturnsTheCorrectBuildFolder() throws {
        try ".library(name: \"DangerDepsEigen\"".write(toFile: testPackage, atomically: false, encoding: .utf8)

        XCTAssertEqual(SPMDanger(packagePath: testPackage, fileManager: StubbedFileManager())?.buildFolder, "testPath/.build/debug")
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
