import XCTest
@testable import RunnerLib

final class SPMDangerTests: XCTestCase {
    let testPackage = "testPackage.swift"
    
    override func setUp() {
      super.setUp()
    }

    override func tearDown() {
      super.tearDown()
    }
    
    func testItReturnsTrueWhenThePackageHasTheDangerLib() {
        try! ".library(name: \"DangerDeps\"".write(toFile: testPackage, atomically: false, encoding: .utf8)
        
        XCTAssertTrue(SPMDanger.isSPMDanger(packagePath: testPackage))
        
        try? FileManager.default.removeItem(atPath: testPackage)
    }
    
    func testItReturnsFalseWhenThePackageHasNotTheDangerLib() {
        try! "".write(toFile: testPackage, atomically: false, encoding: .utf8)
        
        XCTAssertFalse(SPMDanger.isSPMDanger(packagePath: testPackage))
        
        try? FileManager.default.removeItem(atPath: testPackage)
    }
    
    func testItReturnsFalseWhenThereIsNoPackage() {
        XCTAssertFalse(SPMDanger.isSPMDanger(packagePath: testPackage))
    }
    
    func testItBuildsTheDependenciesIfTheDepsLibIsNotPresent() {
        let executor = MockedExecutor()
        let fileManager = StubbedFileManager()
        fileManager.stubbedFileExists = false
        
        SPMDanger.buildDepsIfNeeded(executor: executor, fileManager: fileManager)
        
        XCTAssertTrue(executor.receivedCommand == "swift build --product DangerDeps")
    }
    
    func testItDoesntBuildTheDependenciesIfTheDepsLibIsPresent() {
        let executor = MockedExecutor()
        let fileManager = StubbedFileManager()
        fileManager.stubbedFileExists = true
        
        SPMDanger.buildDepsIfNeeded(executor: executor, fileManager: fileManager)
        
        XCTAssertTrue(executor.receivedCommand == nil)
    }
    
    func testItReturnsTheCorrectDepsImport() {
        XCTAssertEqual(SPMDanger.libImport, "-lDangerDeps")
    }
}

private class StubbedFileManager: FileManager {
    fileprivate var stubbedFileExists: Bool = true
    
    override func fileExists(atPath path: String) -> Bool {
        return stubbedFileExists
    }
}
