@testable import RunnerLib
import XCTest

final class SPMDangerTests: XCTestCase {
    let testPackage = "testPackage.swift"

    override func tearDown() {
        super.tearDown()
        try? FileManager.default.removeItem(atPath: testPackage)
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

    func testItBuildsTheDependenciesIfTheDepsLibIsNotPresent() {
        let executor = MockedExecutor()
        let fileManager = StubbedFileManager()
        fileManager.stubbedFileExists = false

        try! ".library(name: \"DangerDeps\"".write(toFile: testPackage, atomically: false, encoding: .utf8)
        SPMDanger(packagePath: testPackage)?.buildDepsIfNeeded(executor: executor, fileManager: fileManager)

        XCTAssertTrue(executor.receivedCommand == "swift build --product DangerDeps")
    }

    func testItDoesntBuildTheDependenciesIfTheDepsLibIsPresent() {
        let executor = MockedExecutor()
        let fileManager = StubbedFileManager()
        fileManager.stubbedFileExists = true

        SPMDanger(packagePath: testPackage)?.buildDepsIfNeeded(executor: executor, fileManager: fileManager)

        XCTAssertTrue(executor.receivedCommand == nil)
    }

    func testItReturnsTheCorrectDepsImport() {
        try! ".library(name: \"DangerDepsEigen\"".write(toFile: testPackage, atomically: false, encoding: .utf8)
        XCTAssertEqual(SPMDanger(packagePath: testPackage)?.libImport, "-lDangerDepsEigen")
    }
}

private class StubbedFileManager: FileManager {
    fileprivate var stubbedFileExists: Bool = true

    override func fileExists(atPath _: String) -> Bool {
        return stubbedFileExists
    }
}
