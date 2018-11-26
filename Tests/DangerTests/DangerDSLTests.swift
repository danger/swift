@testable import Danger
import XCTest

final class DangerDSLTests: XCTestCase {
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
        XCTAssertTrue(danger.runningOnGithub)
        XCTAssertTrue(danger.supportsSuggestions)
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
        XCTAssertTrue(danger.runningOnGithub)
        XCTAssertTrue(danger.supportsSuggestions)
        XCTAssertNotNil(danger.git)
        XCTAssert(danger.github.api.configuration.accessToken == "7bd263f8e4becaa3d29b25d534fe6d5f3b555ccf")
        XCTAssert(danger.github.api.configuration.apiEndpoint == "https://base.url.io")
    }
}
