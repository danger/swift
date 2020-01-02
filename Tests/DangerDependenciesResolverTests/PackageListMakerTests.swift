@testable import DangerDependenciesResolver
import XCTest

final class PackageListMakerTests: XCTestCase {
    func testParsesValidPackages() {
        let expectedResult = Package(name: "test", url: URL(string: "about:blank")!, majorVersion: 5)
        let expectedResult2 = Package(name: "test", url: URL(string: "about:blank")!, majorVersion: 5)
        var dataReader = StubbedDataReader()
        dataReader.stubbedReadData = { path in
            switch path {
            case "/user/franco/Package1.swift":
                return try! expectedResult.encoded()
            case "/user/franco/Package2.swift":
                return try! expectedResult.encoded()
            case "/user/franco/File.swift":
                return Data()
            default:
                XCTFail("Received invalid path \(path)")
                return Data()
            }
        }
        let fileManager = StubbedFileManager()
        fileManager.stubbedContent = ["Package1.swift", "File.swift", "Package2.swift"]
        let packageListMaker = PackageListMaker(folder: "/user/franco", fileManager: fileManager, dataReader: dataReader)

        let packages = packageListMaker.makePackageList()

        XCTAssertEqual(packages, [expectedResult, expectedResult2])
    }
}

final class StubbedFileManager: FileManager {
    var stubbedContent: [String] = []

    override func contentsOfDirectory(atPath _: String) throws -> [String] {
        stubbedContent
    }
}
