@testable import Danger
import DangerFixtures
import XCTest

final class DangerDSLTests: XCTestCase {
    override func tearDown() {
        resetDangerResults()

        super.tearDown()
    }

    func testFileMapWorksCorrectly() throws {
        let fileContent = "123easfsfasd"
        let danger = githubWithFilesDSL(created: ["file.swift"], fileMap: ["file.swift": fileContent])
        let file = danger.utils.readFile("file.swift")
        XCTAssertEqual(fileContent, file)
    }

    func testDangerfileResults() throws {
        let danger = githubFixtureDSL
        danger.message("Message")
        danger.warn("Warning")
        danger.fail("Fail")
        XCTAssertEqual(danger.messages.count, 1)
        XCTAssertEqual(danger.warnings.count, 1)
        XCTAssertEqual(danger.fails.count, 1)
    }

    func testDangerMetaResults() throws {
        let danger = githubFixtureDSL
        danger.meta(Meta(runtimeName: "Foo", runtimeHref: "https://foo.com"))

        XCTAssertEqual(danger.meta.runtimeName, "Foo")
        XCTAssertEqual(danger.meta.runtimeHref, "https://foo.com")
    }

    func testGithubFixtureDSL() throws {
        let danger: DangerDSL = githubFixtureDSL

        XCTAssertNil(danger.bitbucketServer)
        XCTAssertNotNil(danger.github)
        XCTAssertTrue(danger.runningOnGithub)
        XCTAssertTrue(danger.supportsSuggestions)
        XCTAssertNotNil(danger.git)
        XCTAssertEqual(danger.github.api.configuration.accessToken, "7bd263f8e4becaa3d29b25d534fe6d5f3b555ccf".base64Encoded)
    }

    func testItParsesCorrectlyTheDangerDSLWhenThePRIsOnGithubEnterprise() throws {
        let danger: DangerDSL = githubEnterpriseFixtureDSL

        XCTAssertNil(danger.bitbucketServer)
        XCTAssertNotNil(danger.github)
        XCTAssertTrue(danger.runningOnGithub)
        XCTAssertTrue(danger.supportsSuggestions)
        XCTAssertNotNil(danger.git)
        XCTAssertEqual(danger.github.api.configuration.accessToken, "7bd263f8e4becaa3d29b25d534fe6d5f3b555ccf".base64Encoded)
        XCTAssertEqual(danger.github.api.configuration.apiEndpoint, "https://base.url.io")
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

private extension String {
    var base64Encoded: String? {
        data(using: .utf8)?.base64EncodedString()
    }
}
