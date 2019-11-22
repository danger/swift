@testable import RunnerLib
import XCTest

final class SPMDangerTests: XCTestCase {
    var testPackage: String {
        return "testPackage.swift"
    }

    override func tearDown() {
        try? FileManager.default.removeItem(atPath: testPackage)
        super.tearDown()
    }

    func testItReturnsTrueWhenThePackageHasTheDangerLib() {
        try! ".library(name: \"DangerDeps\"".write(toFile: testPackage, atomically: false, encoding: .utf8)

        let spmDanger = SPMDanger(packagePath: testPackage)
        XCTAssertEqual(spmDanger?.depsLibName, "DangerDeps")
    }

    func testItAcceptsAnythingStartsWithDangerDeps() {
        try! ".library(name: \"DangerDepsEigen\"".write(toFile: testPackage, atomically: false, encoding: .utf8)

        let spmDanger = SPMDanger(packagePath: testPackage)
        XCTAssertEqual(spmDanger?.depsLibName, "DangerDepsEigen")
    }

    func testItReturnsFalseWhenThePackageHasNotTheDangerLib() {
        try! "".write(toFile: testPackage, atomically: false, encoding: .utf8)

        XCTAssertNil(SPMDanger(packagePath: testPackage))
    }

    func testItReturnsFalseWhenThereIsNoPackage() {
        XCTAssertNil(SPMDanger(packagePath: testPackage))
    }

    func testItBuildsTheDependencies() {
        let executor = MockedExecutor()
        let fileManager = StubbedFileManager()
        fileManager.stubbedFileExists = false

        try! ".library(name: \"DangerDeps\"".write(toFile: testPackage, atomically: false, encoding: .utf8)
        SPMDanger(packagePath: testPackage)?.buildDependencies(executor: executor, fileManager: fileManager)

        XCTAssertEqual(executor.receivedCommand, "swift build --product DangerDeps")
    }

    func testItReturnsTheCorrectXcodeDepsFlagsWhenThereIsNoDangerLib() {
        try! ".library(name: \"DangerDepsEigen\"".write(toFile: testPackage, atomically: false, encoding: .utf8)
        let fileManager = StubbedFileManager()
        fileManager.stubbedFileExists = false

        XCTAssertEqual(SPMDanger(packagePath: testPackage, fileManager: fileManager)?.xcodeImportFlags, ["-l DangerDepsEigen"])
    }

    func testItReturnsTheCorrectXcodeDepsFlagsWhenThereIsTheDangerLib() {
        try! ".library(name: \"DangerDepsEigen\"".write(toFile: testPackage, atomically: false, encoding: .utf8)
        let fileManager = StubbedFileManager()
        fileManager.stubbedFileExists = true

        XCTAssertEqual(SPMDanger(packagePath: testPackage, fileManager: fileManager)?.xcodeImportFlags, ["-l DangerDepsEigen", "-l Danger"])
    }

    func testItReturnsTheCorrectSwiftcDepsImport() {
        try! ".library(name: \"DangerDepsEigen\"".write(toFile: testPackage, atomically: false, encoding: .utf8)
        XCTAssertEqual(SPMDanger(packagePath: testPackage)?.swiftcLibImport, "-lDangerDepsEigen")
    }
}

private class StubbedFileManager: FileManager {
    fileprivate var stubbedFileExists: Bool = true

    override func fileExists(atPath _: String) -> Bool {
        return stubbedFileExists
    }
}
