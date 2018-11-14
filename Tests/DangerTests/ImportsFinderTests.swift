//
//  ImportsFinderTests.swift
//  DangerTests
//
//  Created by Franco Meloni on 04/11/2018.
//

import XCTest
import Danger

final class ImportsFinderTests: XCTestCase {
    static var allTests = [
        ("testItRetunsTheCorrectFilePathsWhenThePassedStringContainsImports", testItRetunsTheCorrectFilePathsWhenThePassedStringContainsImports),
        ("testItRetunsAnEmptyListWhenThePassedStringDoesntContainImports",
         testItRetunsAnEmptyListWhenThePassedStringDoesntContainImports),
        ("testLinuxTestSuiteIncludesAllTests", testLinuxTestSuiteIncludesAllTests)
    ]
    
    var importsFinder: ImportsFinder!
    
    override func setUp() {
        super.setUp()
        importsFinder = ImportsFinder()
    }
    
    func testItRetunsTheCorrectFilePathsWhenThePassedStringContainsImports() {
        checkReturnsTheCorrectFilePaths(string: stringWithImports, expectedResult: ["File1", "File2"])
    }

    func testItRetunsAnEmptyListWhenThePassedStringDoesntContainImports() {
        checkReturnsTheCorrectFilePaths(string: stringWithoutImports, expectedResult: [])
    }
    
    func testLinuxTestSuiteIncludesAllTests() {
        #if !os(Linux)
        let thisClass = type(of: self)
        let linuxCount = thisClass.allTests.count
        let darwinCount = thisClass.defaultTestSuite.tests.count
        XCTAssertEqual(linuxCount, darwinCount, "\(darwinCount - linuxCount) tests are missing from allTests")
        #endif
    }
}

extension ImportsFinderTests {
    private var stringWithImports: String {
        return """
        // fileImport: File1
        
        text text
        
        // fileImport: File2
        """
    }
    
    private var stringWithoutImports: String {
        return """
        // comment
        
        text text
        
        more text
        """
    }
    
    private func checkReturnsTheCorrectFilePaths(string: String, expectedResult: [String]) {
        let files = importsFinder.findImports(inString: string)
        XCTAssertEqual(files, expectedResult)
    }
}
