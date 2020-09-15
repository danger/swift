@testable import Danger
import XCTest

final class DangerUtilsTests: XCTestCase {
    func testLinesForStringReturnsTheCorrectResult() {
        let dangerUtils = DangerUtils(fileMap: ["file1": fileContent])
        XCTAssertEqual(dangerUtils.lines(for: "Danger", inFile: "file1"), [1, 12, 15, 17, 35])
    }

    func testFileDiffWhenDiffIsValid() {
        let executor = FakeShellExecutor()
        executor.output = validDiff

        let dangerUtils = DangerUtils(fileMap: [:], shellExecutor: executor)
        let diff = dangerUtils.diff(forFile: "file", sourceBranch: "master")

        guard case let .success(fileDiff) = diff else {
            XCTFail("Expected success, got \(diff)")
            return
        }

        XCTAssertEqual(fileDiff, FileDiff(parsedHeader: .init(filePath: ".swiftpm/xcode/package.xcworkspace/contents.xcworkspacedata", change: .created), hunks: [
            .init(oldLineStart: 0, oldLineSpan: 0, newLineStart: 1, newLineSpan: 7, lines: [
                FileDiff.Line(text: "<?xml version=\"1.0\" encoding=\"UTF-8\"?>", changeType: .added),
                FileDiff.Line(text: "<Workspace", changeType: .added),
                FileDiff.Line(text: "   version = \"1.0\">", changeType: .added),
                FileDiff.Line(text: "   <FileRef", changeType: .added),
                FileDiff.Line(text: "      location = \"self:\">", changeType: .added),
                FileDiff.Line(text: "   </FileRef>", changeType: .added),
                FileDiff.Line(text: "</Workspace>", changeType: .added),
            ]),
        ]))
    }

    func testAwaitsFunctionResult() {
        var executed = false

        executed = DangerUtils(fileMap: [:]).sync { completion in
            DispatchQueue(label: "Test", qos: .userInteractive).async {
                completion(true)
            }
        }

        XCTAssertTrue(executed)
    }

    private var fileContent: String {
        """
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

    private var validDiff: String {
        """
        diff --git a/.swiftpm/xcode/package.xcworkspace/contents.xcworkspacedata b/.swiftpm/xcode/package.xcworkspace/contents.xcworkspacedata
        new file mode 100644
        index 0000000..919434a
        --- /dev/null
        +++ b/.swiftpm/xcode/package.xcworkspace/contents.xcworkspacedata
        @@ -0,0 +1,7 @@
        +<?xml version="1.0" encoding="UTF-8"?>
        +<Workspace
        +   version = "1.0">
        +   <FileRef
        +      location = "self:">
        +   </FileRef>
        +</Workspace>
        """
    }
}
