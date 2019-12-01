@testable import DangerDependenciesResolver
import DangerShellExecutor
import Logger
import XCTest

final class PackageDataProviderTests: XCTestCase {
    var fileReader: StubbedDataReader!
    var packageDataProvider: PackageDataProvider!
    var executor: MockedExecutor!

    override func setUp() {
        super.setUp()
        fileReader = StubbedDataReader(stubbedReadText: { _ in
            self.packageText
        })

        executor = MockedExecutor()

        packageDataProvider = PackageDataProvider(
            temporaryFolder: "tmp",
            fileReader: fileReader,
            logger: Logger(isVerbose: false, isSilent: false, printer: SpyPrinter()),
            executor: executor
        )
    }

    override func tearDown() {
        fileReader = nil
        packageDataProvider = nil
        executor = nil

        super.tearDown()
    }

    func testWhenThePackageIsLocalReturnsCorrectPackageName() throws {
        let name = try packageDataProvider.nameOfPackage(at: URL(string: "/usr/franco/repo")!)

        XCTAssertEqual(name, "danger-swift")
    }

    func testWhenThePackageIsRemoteReturnsCorrectPackageName() throws {
        let name = try packageDataProvider.nameOfPackage(at: URL(string: "http://url.com/repo.git")!)

        XCTAssertEqual(executor.receivedCommand, "git clone http://url.com/repo.git --single-branch --depth 1 tmp/Clone -q")
        XCTAssertEqual(name, "danger-swift")
    }

    private var packageText: String {
        return """
        // swift-tools-version:4.2

        import PackageDescription

        let package = Package(
            name: "danger-swift",
            products: [
                .library(name: "Danger", type: .dynamic, targets: ["Danger"])
            ],
            dependencies: [
                .package(url: "https://github.com/shibapm/Logger", from: "0.1.0")
            ],
            targets: [
                .target(name: "Danger-Swift", dependencies: ["Danger", "Yams"])
            ]
        )
        """
    }
}

final class SpyPrinter: Printing {
    private(set) var printedMessages: [String] = []

    func print(_ message: String, terminator _: String) {
        printedMessages.append(message)
    }
}

final class MockedExecutor: ShellExecuting {
    var receivedCommand: String!
    var result = ""

    func execute(_ command: String, arguments: [String], environmentVariables _: [String: String], outputFile: String?) -> String {
        receivedCommand = command + " " + arguments.joined(separator: " ")
        return result
    }

    func spawn(_ command: String, arguments: [String], environmentVariables _: [String: String], outputFile: String?) throws -> String {
        receivedCommand = command + " " + arguments.joined(separator: " ")
        return result
    }
}
