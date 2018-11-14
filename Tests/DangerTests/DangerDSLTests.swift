//
//  DangerDSLTests.swift
//  DangerTests
//
//  Created by Franco Meloni on 06/11/2018.
//

import XCTest
@testable import Danger

final class DangerDSLTests: XCTestCase {
    static var allTests = [
        ("testItParsesCorrectlyTheDangerDSLWhenThePRIsOnGithub", testItParsesCorrectlyTheDangerDSLWhenThePRIsOnGithub),
        ("testItParsesCorrectlyTheDangerDSLWhenThePRIsOnGithubEnterprise", testItParsesCorrectlyTheDangerDSLWhenThePRIsOnGithubEnterprise),
        ("testLinuxTestSuiteIncludesAllTests", testLinuxTestSuiteIncludesAllTests)
    ]
    
    var decoder: JSONDecoder!
    
    override func setUp() {
        super.setUp()
        decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(DateFormatter.defaultDateFormatter)
    }
    
    func testItParsesCorrectlyTheDangerDSLWhenThePRIsOnGithub() throws {
        guard let data = DSLGitHubJSON.data(using: .utf8) else {
            XCTFail("Could not generate data")
            return
        }

        let danger: DangerDSL = try decoder.decode(DSL.self, from: data).danger
        
        XCTAssertNil(danger.bitbucket_server)
        XCTAssertNotNil(danger.github)
        XCTAssertNotNil(danger.git)
        XCTAssert(danger.github.api.configuration.accessToken == "7bd263f8e4becaa3d29b25d534fe6d5f3b555ccf")
    }
    
    func testItParsesCorrectlyTheDangerDSLWhenThePRIsOnGithubEnterprise() throws {
        guard let data = DSLGitHubEnterpriseJSON.data(using: .utf8) else {
            XCTFail("Could not generate data")
            return
        }
        
        let danger: DangerDSL = try decoder.decode(DSL.self, from: data).danger
        
        XCTAssertNil(danger.bitbucket_server)
        XCTAssertNotNil(danger.github)
        XCTAssertNotNil(danger.git)
        XCTAssert(danger.github.api.configuration.accessToken == "7bd263f8e4becaa3d29b25d534fe6d5f3b555ccf")
        XCTAssert(danger.github.api.configuration.apiEndpoint == "https://base.url.io")
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
