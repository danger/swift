import XCTest
@testable import Danger

final class BitBucketServerTests: XCTestCase {
    static var allTests = [
        ("test_BitBucketServerUser_decode", test_BitBucketServerUser_decoder),
        ("test_BitBucketServerProject_decode", test_BitBucketServerProject_decoder),
        ("test_BitBucketServerRepo_decode", test_BitBucketServerRepo_decoder),
        ("testLinuxTestSuiteIncludesAllTests", testLinuxTestSuiteIncludesAllTests)
    ]
    
    private var decoder: JSONDecoder!
    
    override func setUp() {
        decoder = JSONDecoder()
    }
    
    override func tearDown() {
        decoder = nil
    }
    
    func test_BitBucketServerUser_decoder() throws {
        guard let data = BitBucketServerUserJSON.data(using: .utf8) else {
            XCTFail("Could not generate data")
            return
        }
        
        let correctUser = BitBucketServerUser(id: 1, name: "tum-id", displayName: "Firstname Lastname", emailAddress: "user.name@tum.de", active: true, slug: "tum-id", type: "NORMAL")
        
        let testUser: BitBucketServerUser = try JSONDecoder().decode(BitBucketServerUser.self, from: data)
        
        XCTAssertEqual(testUser, correctUser)
    }
    
    func test_BitBucketServerProject_decoder() throws {
        guard let data = BitBucketServerProjectJSON.data(using: .utf8) else {
            XCTFail("Could not generate data")
            return
        }
        
        let correctProject = BitBucketServerProject(id: 1666, key: "IOSEXAMPLE", name: "iOS Example Projects", isPublic: false, type: "NORMAL")
        
        let testProject: BitBucketServerProject = try JSONDecoder().decode(BitBucketServerProject.self, from: data)
        
        XCTAssertEqual(testProject, correctProject)
    }
    
    func test_BitBucketServerRepo_decoder() throws {
        guard let data = BitBucketServerRepoJSON.data(using: .utf8) else {
            XCTFail("Could not generate data")
            return
        }
        
        let correctProject = BitBucketServerProject(id: 1666, key: "IOSEXAMPLE", name: "iOS Example Projects", isPublic: false, type: "NORMAL")
        
        let correctRepo = BitBucketServerRepo(name: "Example Client", slug: "example-client", scmId: "git", isPublic: false, forkable: true, project: correctProject)
        
        let testRepo: BitBucketServerRepo = try JSONDecoder().decode(BitBucketServerRepo.self, from: data)
        
        XCTAssertEqual(testRepo, correctRepo)
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
