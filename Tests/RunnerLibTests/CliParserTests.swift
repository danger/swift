//
//  CliParserTests.swift
//  DangerTests
//
//  Created by Franco Meloni on 12/11/2018.
//

import XCTest
@testable import RunnerLib

final class CliParserTests: XCTestCase {
    static var allTests = [
        ("testItReturnsTheCliArgsIfTheJSONIsCorrect", testItReturnsTheCliArgsIfTheJSONIsCorrect),
        ("testItReturnsTheCliArgsIfTheJSONIsCorrectButDoesntContainAllTheFields", testItReturnsTheCliArgsIfTheJSONIsCorrectButDoesntContainAllTheFields),
        ("testItReturnsNilIfTheJSONDoesntContainCliArgs", testItReturnsNilIfTheJSONDoesntContainCliArgs),
        ("testLinuxTestSuiteIncludesAllTests", testLinuxTestSuiteIncludesAllTests)
    ]
    
    private var parser: CliArgsParser!

    override func setUp() {
        super.setUp()
        parser = CliArgsParser()
    }

    override func tearDown() {
        parser = nil
        super.tearDown()
    }

    func testItReturnsTheCliArgsIfTheJSONIsCorrect() {
        let cli = parser.parseCli(fromData: correctJSON.data(using: .utf8)!)
        
        XCTAssertEqual(cli?.id, "testId")
        XCTAssertEqual(cli?.base, "testBase")
        XCTAssertEqual(cli?.verbose, "testVerbose")
        XCTAssertEqual(cli?.externalCiProvider, "testExternalCiProvider")
        XCTAssertEqual(cli?.textOnly, "testTextOnly")
        XCTAssertEqual(cli?.dangerfile, "testDangerfile")
    }
    
    func testItReturnsTheCliArgsIfTheJSONIsCorrectButDoesntContainAllTheFields() {
        let cli = parser.parseCli(fromData: correctJSONWithOnlyDangerfile.data(using: .utf8)!)
        
        XCTAssertNil(cli?.id)
        XCTAssertNil(cli?.base)
        XCTAssertNil(cli?.verbose)
        XCTAssertNil(cli?.externalCiProvider)
        XCTAssertNil(cli?.textOnly)
        XCTAssertEqual(cli?.dangerfile, "testDangerfile")
    }
    
    func testItReturnsNilIfTheJSONDoesntContainCliArgs() {
        let cli = parser.parseCli(fromData: jsonWithoutCliArgs.data(using: .utf8)!)
        
        XCTAssertNil(cli)
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

extension CliParserTests {
    private var correctJSON: String {
        return """
        {
            "danger": {
                "settings": {
                    "cliArgs": {
                        "id": "testId",
                        "base": "testBase",
                        "verbose": "testVerbose",
                        "externalCiProvider": "testExternalCiProvider",
                        "textOnly": "testTextOnly",
                        "dangerfile": "testDangerfile"
                    }
                }
            }
        }
        """
    }
    
    private var correctJSONWithOnlyDangerfile: String {
        return """
        {
            "danger": {
                "settings": {
                    "cliArgs": {
                        "dangerfile": "testDangerfile"
                    }
                }
            }
        }
        """
    }
    
    private var jsonWithoutCliArgs: String {
        return """
        {
            "danger": {
                "settings": {
                }
            }
        }
        """
    }
}
