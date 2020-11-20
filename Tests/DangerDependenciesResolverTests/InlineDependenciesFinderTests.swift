@testable import DangerDependenciesResolver
import Foundation
import XCTest

final class InlineDependenciesFinderTests: XCTestCase {
    func testFindsDependencies() throws {
        let fileReader = StubbedDataReader(stubbedReadText: { _ -> String in
            self.script
        })
        let dependenciesFinder = InlineDependenciesFinder(fileReader: fileReader,
                                                          config: ScriptManager.Config(prefix: "package: ", file: "", major: "~> "))

        let result = try dependenciesFinder.resolveInlineDependencies(fromPath: "path")

        XCTAssertEqual(result, [
            InlineDependenciesFinder.InlineDependency(url: URL(string: "http://danger.systems")!, major: nil),
            InlineDependenciesFinder.InlineDependency(url: URL(string: "http://danger.systems/swift")!, major: 2),
        ])
    }

    func testReturnsAnErrorWhenDependencyIsInvalid() throws {
        let fileReader = StubbedDataReader(stubbedReadText: { _ -> String in
            self.scriptWithInvalidURL
        })
        let dependenciesFinder = InlineDependenciesFinder(fileReader: fileReader,
                                                          config: ScriptManager.Config(prefix: "package: ", file: "", major: "~> "))

        XCTAssertThrowsError(try dependenciesFinder.resolveInlineDependencies(fromPath: "path"))
    }

    func testReturnsAnEmptyDependenciesListWhenDependenciesDoNotHavePackagePrefix() throws {
        let fileReader = StubbedDataReader(stubbedReadText: { _ -> String in
            self.scriptWithoutPackagePrefix
        })
        let dependenciesFinder = InlineDependenciesFinder(fileReader: fileReader,
                                                          config: ScriptManager.Config(prefix: "package: ", file: "", major: "~> "))

        let result = try dependenciesFinder.resolveInlineDependencies(fromPath: "path")

        XCTAssertEqual(result, [])
    }

    private var script: String {
        """
        import LibA
        import LibB // package: http://danger.systems
        import LibC // package: http://danger.systems/swift ~> 2
        """
    }

    private var scriptWithInvalidURL: String {
        """
        import LibA
        import LibB // package: invalid url
        """
    }

    private var scriptWithoutPackagePrefix: String {
        """
        import LibA
        import LibB
        """
    }
}
