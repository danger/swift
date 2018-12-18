@testable import Danger
import DangerFixtures
import XCTest

final class DangerDSLTests: XCTestCase {
    override func setUp() {
        resetDangerResults()
    }

    func testFileMapWorksCorrectly() throws {
        let fileContent = "123easfsfasd"
        let danger = githubWithFilesDSL(created: ["file.swift"], fileMap: ["file.swift": fileContent])
        let file = danger.utils.readFile("file.swift")
        XCTAssertEqual(fileContent, file)
    }

    func testDangerfileResults() throws {
        let danger = githubFixtureDSL
        danger.warn("Warning")
        danger.fail("Fail")
        XCTAssert(globalResults.warnings.count == 1)
        XCTAssert(globalResults.fails.count == 1)
    }

    func testGithubFixtureDSL() throws {
        let danger: DangerDSL = githubFixtureDSL

        XCTAssertNil(danger.bitbucketServer)
        XCTAssertNotNil(danger.github)
        XCTAssertTrue(danger.runningOnGithub)
        XCTAssertTrue(danger.supportsSuggestions)
        XCTAssertNotNil(danger.git)
        XCTAssert(danger.github.api.configuration.accessToken == "7bd263f8e4becaa3d29b25d534fe6d5f3b555ccf")
    }

    func testItParsesCorrectlyTheDangerDSLWhenThePRIsOnGithubEnterprise() throws {
        let danger: DangerDSL = githubEnterpriseFixtureDSL

        XCTAssertNil(danger.bitbucketServer)
        XCTAssertNotNil(danger.github)
        XCTAssertTrue(danger.runningOnGithub)
        XCTAssertTrue(danger.supportsSuggestions)
        XCTAssertNotNil(danger.git)
        XCTAssert(danger.github.api.configuration.accessToken == "7bd263f8e4becaa3d29b25d534fe6d5f3b555ccf")
        XCTAssert(danger.github.api.configuration.apiEndpoint == "https://base.url.io")
    }

    func testItParsesCorrectlyTheDangerDSLWhenThePRIsOnBitBucketServer() throws {
        let danger: DangerDSL = bitbucketFixtureDSL

        XCTAssertNotNil(danger.bitbucketServer)
        XCTAssertNil(danger.github)
        XCTAssertFalse(danger.runningOnGithub)
        XCTAssertFalse(danger.supportsSuggestions)
        XCTAssertNotNil(danger.git)
    }
}
