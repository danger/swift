@testable import Danger
import XCTest

final class DangerUtilsTests: XCTestCase {
    func testLinesForStringReturnsTheCorrectResult() {
        let dangerUtils = DangerUtils(fileMap: ["file1": fileContent])
        XCTAssertEqual(dangerUtils.lines(for: "Danger", inFile: "file1"), [1, 12, 15, 17, 35])
    }

    private var fileContent: String {
        return """
        Write your Dangerfiles in Swift.
        
        ### Requirements
        
        Latest version requires Swift 4.2
        
        - If you are using Swift 4.1 use v0.4.1
        - If you are using Swift 4.0, Use v0.3.6
        
        ### What it looks like today
        
        You can make a Dangerfile that looks through PR metadata, it's fully typed.
        
        ```swift
        import Danger
        
        let danger = Danger()
        let allSourceFiles = danger.git.modifiedFiles + danger.git.createdFiles
        
        let changelogChanged = allSourceFiles.contains("CHANGELOG.md")
        let sourceChanges = allSourceFiles.first(where: { $0.hasPrefix("Sources") })
        
        if !changelogChanged && sourceChanges != nil {
        warn("No CHANGELOG entry added.")
        }
        
        // You can use these functions to send feedback:
        message("Highlight something in the table")
        warn("Something pretty bad, but not important enough to fail the build")
        fail("Something that must be changed")
        
        markdown("Free-form markdown that goes under the table, so you can do whatever.")
        ```
        
        ### Using Danger Swift
        
        All of the docs are on the user-facing website: https://danger.systems/swift/
        """
    }
}
