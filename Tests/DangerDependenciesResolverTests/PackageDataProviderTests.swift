@testable import DangerDependenciesResolver
import Logger
import ShellRunner
import Version
import XCTest

final class PackageDataProviderTests: XCTestCase {
    var fileReader: StubbedDataReader!
    var packageDataProvider: PackageDataProvider!
    var shell: ShellRunnerMock!

    override func setUp() {
        super.setUp()
        fileReader = StubbedDataReader()

        shell = ShellRunnerMock()

        packageDataProvider = PackageDataProvider(
            logger: Logger(isVerbose: false, isSilent: false, printer: SpyPrinter()),
            fileReader: fileReader,
            shell: shell
        )
    }

    override func tearDown() {
        fileReader = nil
        packageDataProvider = nil
        shell = nil

        super.tearDown()
    }

    func testWhenThePackageIsLocalReturnsCorrectPackageName() throws {
        fileReader.stubbedReadText = { _ in
            self.packageText
        }
        let name = try packageDataProvider.nameOfPackage(at: URL(string: "/usr/franco/repo")!, temporaryFolder: "tmp")

        XCTAssertEqual(name, "danger-swift")
    }

    func testWhenThePackageIsRemoteReturnsCorrectPackageName() throws {
        fileReader.stubbedReadText = { _ in
            self.packageText
        }
        let name = try packageDataProvider.nameOfPackage(at: URL(string: "http://url.com/repo.git")!, temporaryFolder: "tmp")

        XCTAssertEqual(shell.receivedCommand, "git clone http://url.com/repo.git --single-branch --depth 1 tmp/Clone -q")
        XCTAssertEqual(name, "danger-swift")
    }

    func testLatestMajorVersionForPackageReturnsCorrectVersion() throws {
        shell.result = gitLsRemoteTestResponse

        let version = try packageDataProvider.latestMajorVersionForPackage(at: URL(string: "http://url.com/repo.git")!)

        XCTAssertEqual(shell.receivedCommand, "git ls-remote --tags http://url.com/repo.git")
        XCTAssertEqual(version, 2)
    }

    func testLatestMajorVersionForPackageThrowsAnErrorWhenInputIsInvalid() throws {
        shell.result = ""

        XCTAssertThrowsError(try packageDataProvider.latestMajorVersionForPackage(at: URL(string: "http://url.com/repo.git")!))
    }

    func testResolvePinnedPackagesReturnsCorrectPinnedPackages() throws {
        fileReader.stubbedReadData = { path in
            switch path {
            case "/usr/franco/Package.resolved":
                return Data(self.resolvedPackageText.utf8)
            default:
                XCTFail("Received unexpected path \(path)")
                return Data()
            }
        }

        let packages = try packageDataProvider.resolvePinnedPackages(generatedFolder: "/usr/franco")

        XCTAssertEqual(packages, [
            .init(name: "AEXML",
                  url: URL(string: "https://github.com/tadija/AEXML")!,
                  state: .init(version: "4.3.3")),
            .init(name: "Commandant",
                  url: URL(string: "https://github.com/Carthage/Commandant.git")!,
                  state: .init(version: "0.16.0")),
            .init(name: "Curry",
                  url: URL(string: "https://github.com/thoughtbot/Curry.git")!,
                  state: .init(version: "4.0.2")),
            .init(name: "JSONUtilities",
                  url: URL(string: "https://github.com/yonaskolb/JSONUtilities.git")!,
                  state: .init(version: "4.2.0")),
            .init(name: "Komondor",
                  url: URL(string: "https://github.com/shibapm/Komondor")!,
                  state: .init(version: "1.0.4")),
            .init(name: "OctoKit",
                  url: URL(string: "https://github.com/nerdishbynature/octokit.swift")!,
                  state: .init(version: "0.9.0")),
        ])
    }

    private var packageText: String {
        """
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

    private var gitLsRemoteTestResponse: String {
        """
        9ef6e482c3ab0d77e52b02e272a15b0e790a1202    HEAD
        a314c289277b5bf77b3d318bda52494daf99f2f0    refs/heads/actions_readme
        cb5da9bd4ec3701d0678eb8ef443b5e9939ab39d    refs/heads/bitbucket_inline_comment_optional_from
        84c589ce4c458f76a44279ecbd1fed36ada7dcba    refs/pull/1/head
        deee4b009abb1ff2b351fbc07f2a5f15e6805449    refs/pull/100/head
        78d6a0324f550565c3829412175bfb0790fc40ea    refs/tags/0.1.0
        d00f86bff7c2a2ea65be70053a6f2596697866da    refs/tags/0.1.1
        6b9d36719934ed9f28438761c7529c0e63001bf8    refs/tags/0.2.0
        b0252d87ece1e8503d87f698b0e01e8bcfceabf8    refs/tags/0.3.0
        199d0f48f3fbe6ae3d10c0131f25ff7202c6c809    refs/tags/0.3.1
        1fa28b1d4f8acf67734ffb065554761347e2b1a9    refs/tags/0.3.2
        d8c089e20dc38022afad29b741d59f60da0262d6    refs/tags/0.3.3
        8b2ea2da4431a193565760f4963c078d03f1e5d2    refs/tags/0.3.4
        ba06d58b6a1202fc1173174c8ffc4c8537af9990    refs/tags/0.3.5
        00ab2984490b706cf0763a14f90c52555a23eb92    refs/tags/2.0.0
        fbe2545277bd9f88fa64d1c2ff92fade140e0537    refs/tags/2.0.3
        c9a7bb9b97f7e6b48c5eab3705c1f54d283bbec4    refs/tags/2.0.4
        6c33b5dd6f876f374556b847f56383a1091ef22b    refs/tags/2.0.5
        de3743f263c00034999bd193054f88c4912dc017    refs/tags/2.0.6
        ddd5a70f9b394207cbf95ac28e366f0e579e641c    refs/tags/1.0.0
        89a20f7d9520f2c7f7c13f8deb77a422b404e36d    refs/tags/1.1.0
        73762cdd73b3434e3541c13b8d480bd17d0fbc63    refs/tags/1.2.0
        51a71181906eeff765344a6aced615178fa7bb77    refs/tags/1.2.1
        a2364b0aa6e9b7737d2a72fbf694c413294cd4f0    refs/tags/1.2.2
        981130300dd7b382e90876b578887e5cf2aec1c8    refs/tags/1.3.0
        33d35bf94f54155be505ffecfca745e4cc1cd0cc    refs/tags/1.6.5
        """
    }

    private var resolvedPackageText: String {
        """
        {
          "object": {
            "pins": [
              {
                "package": "AEXML",
                "repositoryURL": "https://github.com/tadija/AEXML",
                "state": {
                  "branch": null,
                  "revision": "54bb8ea6fb693dd3f92a89e5fcc19e199fdeedd0",
                  "version": "4.3.3"
                }
              },
              {
                "package": "Commandant",
                "repositoryURL": "https://github.com/Carthage/Commandant.git",
                "state": {
                  "branch": null,
                  "revision": "2cd0210f897fe46c6ce42f52ccfa72b3bbb621a0",
                  "version": "0.16.0"
                }
              },
              {
                "package": "Curry",
                "repositoryURL": "https://github.com/thoughtbot/Curry.git",
                "state": {
                  "branch": null,
                  "revision": "4331dd50bc1db007db664a23f32e6f3df93d4e1a",
                  "version": "4.0.2"
                }
              },
              {
                "package": "JSONUtilities",
                "repositoryURL": "https://github.com/yonaskolb/JSONUtilities.git",
                "state": {
                  "branch": null,
                  "revision": "128d2ffc22467f69569ef8ff971683e2393191a0",
                  "version": "4.2.0"
                }
              },
              {
                "package": "Komondor",
                "repositoryURL": "https://github.com/shibapm/Komondor",
                "state": {
                  "branch": null,
                  "revision": "3cd6d76887816ead5931ddbfb249c2935f518e17",
                  "version": "1.0.4"
                }
              },
              {
                "package": "OctoKit",
                "repositoryURL": "https://github.com/nerdishbynature/octokit.swift",
                "state": {
                  "branch": null,
                  "revision": "b63f2ec1b55f26c8e94159d81ad695aeb92f3d4e",
                  "version": "0.9.0"
                }
              }
            ]
          },
          "version": 1
        }
        """
    }
}

final class SpyPrinter: Printing {
    private(set) var printedMessages: [String] = []

    func print(_ message: String, terminator _: String) {
        printedMessages.append(message)
    }
}

final class ShellRunnerMock: ShellRunnerProtocol {
    var receivedCommand: String!
    var result = ""

    func execute(_ command: String, arguments: [String], environmentVariables _: [String: String], outputFile _: String?) -> String {
        receivedCommand = command + " " + arguments.joined(separator: " ")
        return result
    }

    func spawn(_ command: String, arguments: [String], environmentVariables _: [String: String], outputFile _: String?) throws -> String {
        receivedCommand = command + " " + arguments.joined(separator: " ")
        return result
    }
}

extension Version: ExpressibleByStringLiteral {
    public init(stringLiteral value: String) {
        self.init(value)!
    }
}
