@testable import Danger
import XCTest

// swiftlint:disable type_body_length function_body_length line_length
final class GitDiffTests: XCTestCase {
    func testParsesDiff() {
        let diffParser = DiffParser()

        XCTAssertEqual(diffParser.parse(testDiff),
                       [
                           FileDiff(parsedHeader: .init(
                               filePath: ".swiftpm/xcode/package.xcworkspace/contents.xcworkspacedata",
                               change: .created
                           ),
                           hunks: [
                               .init(oldLineStart: 0, oldLineSpan: 0, newLineStart: 1, newLineSpan: 7, lines: [
                                   FileDiff.Line(text: "<?xml version=\"1.0\" encoding=\"UTF-8\"?>", changeType: .added),
                                   FileDiff.Line(text: "<Workspace", changeType: .added),
                                   FileDiff.Line(text: "   version = \"1.0\">", changeType: .added),
                                   FileDiff.Line(text: "   <FileRef", changeType: .added),
                                   FileDiff.Line(text: "      location = \"self:\">", changeType: .added),
                                   FileDiff.Line(text: "   </FileRef>", changeType: .added),
                                   FileDiff.Line(text: "</Workspace>", changeType: .added),
                               ]),
                           ]),
                           FileDiff(parsedHeader: .init(
                               filePath: ".swiftpm/xcode/package.xcworkspace/xcuserdata/franco.xcuserdatad/UserInterfaceState.xcuserstate",
                               change: .created
                           ),
                           hunks: []),
                           FileDiff(parsedHeader: .init(filePath: "Gemfile", change: .deleted), hunks: [
                               .init(oldLineStart: 1, oldLineSpan: 7, newLineStart: 0, newLineSpan: 0, lines: [
                                   FileDiff.Line(text: "# frozen_string_literal: true", changeType: .removed),
                                   FileDiff.Line(text: "", changeType: .removed),
                                   FileDiff.Line(text: "source \"https://rubygems.org\"", changeType: .removed),
                                   FileDiff.Line(text: "", changeType: .removed),
                                   FileDiff.Line(text: "git_source(:github) {|repo_name| \"https://github.com/#{repo_name}\" }", changeType: .removed),
                                   FileDiff.Line(text: "", changeType: .removed),
                                   FileDiff.Line(text: "gem \"xcpretty-json-formatter\"", changeType: .removed),
                               ]),
                           ]),
                           FileDiff(parsedHeader: .init(
                               filePath: "Sources/DangerSwiftCoverage/Models/Report.swift",
                               change: .modified
                           ),
                           hunks: [
                               .init(oldLineStart: 20, oldLineSpan: 7, newLineStart: 20, newLineSpan: 8, lines: [
                                   FileDiff.Line(text: "extension ReportSection {", changeType: .unchanged),
                                   FileDiff.Line(text: "    init(fromSPM spm: SPMCoverage, fileManager: FileManager) {",
                                                 changeType: .unchanged),
                                   FileDiff.Line(text: "        titleText = nil", changeType: .unchanged),
                                   FileDiff.Line(text: "        items = spm.data.flatMap { $0.files.map { ReportFile(fileName: $0.filename.deletingPrefix(fileManager.currentDirectoryPath + \"/\"), coverage: $0.summary.percent) } }",
                                                 changeType: .removed),
                                   FileDiff.Line(text: "        items = spm.data.flatMap { $0.files.map { ReportFile(fileName: $0.filename.deletingPrefix(fileManager.currentDirectoryPath + \"/\"), coverage: $0.summary.percent)",
                                                 changeType: .added),
                                   FileDiff.Line(text: "        } }", changeType: .added),
                                   FileDiff.Line(text: "    }", changeType: .unchanged),
                                   FileDiff.Line(text: "}", changeType: .unchanged),
                                   FileDiff.Line(text: "", changeType: .unchanged),
                               ]),
                           ]),
                           FileDiff(parsedHeader: .init(
                               filePath: "Sources/DangerSwiftCoverage/SPM/SPMCoverageParser.swift",
                               change: .modified
                           ),
                           hunks: [
                               .init(oldLineStart: 1, oldLineSpan: 8, newLineStart: 1, newLineSpan: 11, lines: [
                                   FileDiff.Line(text: "import Foundation", changeType: .unchanged),
                                   FileDiff.Line(text: "", changeType: .unchanged),
                                   FileDiff.Line(text: "", changeType: .added),
                                   FileDiff.Line(text: "", changeType: .added),
                                   FileDiff.Line(text: "", changeType: .added),
                                   FileDiff.Line(text: "", changeType: .added),
                                   FileDiff.Line(text: "protocol SPMCoverageParsing {", changeType: .unchanged),
                                   FileDiff.Line(text: "    static func coverage(spmCoverageFolder: String, files: [String]) throws -> Report",
                                                 changeType: .removed),
                                   FileDiff.Line(text: "}", changeType: .removed),
                                   FileDiff.Line(text: "    static func coverage(spmCoverageFolder: String, files: [String]) throws -> Re",
                                                 changeType: .added),
                                   FileDiff.Line(text: "", changeType: .unchanged),
                                   FileDiff.Line(text: "enum SPMCoverageParser: SPMCoverageParsing {", changeType: .unchanged),
                                   FileDiff.Line(text: "    enum Errors: Error {", changeType: .unchanged),
                               ]),
                               .init(oldLineStart: 22, oldLineSpan: 6, newLineStart: 25, newLineSpan: 10, lines: [
                                   FileDiff.Line(text: "        let coverage = try JSONDecoder().decode(SPMCoverage.self, from: data)", changeType: .unchanged),
                                   FileDiff.Line(text: "        let filteredCoverage = coverage.filteringFiles(notOn: files)", changeType: .unchanged),
                                   FileDiff.Line(text: "", changeType: .unchanged),
                                   FileDiff.Line(text: "        return Report(messages: [], sections: [ReportSection(fromSPM: filteredCoverage, fileManager: fileManager)])", changeType: .removed),
                                   FileDiff.Line(text: "        if filteredCoverage.data.contains(where: { !$0.files.isEmpty }) {", changeType: .added),
                                   FileDiff.Line(text: "            return Report(messages: [], sections: [ReportSection(fromSPM: filteredCoverage, fileManager: fileManager)])", changeType: .added),
                                   FileDiff.Line(text: "        } else {", changeType: .added),
                                   FileDiff.Line(text: "            return Report(messages: [], sections: [])", changeType: .added),
                                   FileDiff.Line(text: "        }", changeType: .added),
                                   FileDiff.Line(text: "    }", changeType: .unchanged),
                                   FileDiff.Line(text: "}", changeType: .unchanged),
                               ]),
                           ]),
                           FileDiff(parsedHeader: .init(
                               filePath: "Sources/DangerSwiftCoverage/ShellOutExecutor1.swift",
                               change: .renamed(oldPath: "Sources/DangerSwiftCoverage/ShellOutExecutor.swift")
                           ),
                           hunks: [
                               .init(oldLineStart: 3, oldLineSpan: 6, newLineStart: 3, newLineSpan: 8, lines: [
                                   FileDiff.Line(text: "", changeType: .unchanged),
                                   FileDiff.Line(text: "protocol ShellOutExecuting {", changeType: .unchanged),
                                   FileDiff.Line(text: "    func execute(command: String) throws -> Data", changeType: .unchanged),
                                   FileDiff.Line(text: "", changeType: .added),
                                   FileDiff.Line(text: "", changeType: .added),
                                   FileDiff.Line(text: "}", changeType: .unchanged),
                                   FileDiff.Line(text: "", changeType: .unchanged),
                                   FileDiff.Line(text: "struct ShellOutExecutor: ShellOutExecuting {", changeType: .unchanged),
                               ]),
                           ]),
                       ])
    }

    func testChangeTypeForCreated() {
        XCTAssertEqual(DiffParser().parse(testDiff)[0].changes, .created(addedLines: [
            #"<?xml version="1.0" encoding="UTF-8"?>"#,
            "<Workspace",
            #"   version = "1.0">"#,
            "   <FileRef",
            #"      location = "self:">"#,
            "   </FileRef>",
            "</Workspace>",
        ]))
    }

    func testChangeTypeForDeleted() {
        XCTAssertEqual(DiffParser().parse(testDiff)[2].changes, .deleted(deletedLines: [
            "# frozen_string_literal: true",
            "",
            #"source "https://rubygems.org""#,
            "",
            #"git_source(:github) {|repo_name| "https://github.com/#{repo_name}" }"#,
            "",
            #"gem "xcpretty-json-formatter""#,
        ]))
    }

    func testChangeTypeForModified() {
        XCTAssertEqual(DiffParser().parse(testDiff)[3].changes, .modified(hunks: [
            .init(oldLineStart: 20, oldLineSpan: 7, newLineStart: 20, newLineSpan: 8, lines: [
                FileDiff.Line(text: "extension ReportSection {", changeType: .unchanged),
                FileDiff.Line(text: "    init(fromSPM spm: SPMCoverage, fileManager: FileManager) {", changeType: .unchanged),
                FileDiff.Line(text: "        titleText = nil", changeType: .unchanged),
                FileDiff.Line(text: "        items = spm.data.flatMap { $0.files.map { ReportFile(fileName: $0.filename.deletingPrefix(fileManager.currentDirectoryPath + \"/\"), coverage: $0.summary.percent) } }", changeType: .removed),
                FileDiff.Line(text: "        items = spm.data.flatMap { $0.files.map { ReportFile(fileName: $0.filename.deletingPrefix(fileManager.currentDirectoryPath + \"/\"), coverage: $0.summary.percent)", changeType: .added),
                FileDiff.Line(text: "        } }", changeType: .added),
                FileDiff.Line(text: "    }", changeType: .unchanged),
                FileDiff.Line(text: "}", changeType: .unchanged),
                FileDiff.Line(text: "", changeType: .unchanged),
            ]),
        ]))
    }

    func testChangeTypeForRenamed() {
        XCTAssertEqual(DiffParser().parse(testDiff)[5].changes, .renamed(oldPath: "Sources/DangerSwiftCoverage/ShellOutExecutor.swift", hunks: [
            .init(oldLineStart: 3, oldLineSpan: 6, newLineStart: 3, newLineSpan: 8, lines: [
                FileDiff.Line(text: "", changeType: .unchanged),
                FileDiff.Line(text: "protocol ShellOutExecuting {", changeType: .unchanged),
                FileDiff.Line(text: "    func execute(command: String) throws -> Data", changeType: .unchanged),
                FileDiff.Line(text: "", changeType: .added),
                FileDiff.Line(text: "", changeType: .added),
                FileDiff.Line(text: "}", changeType: .unchanged),
                FileDiff.Line(text: "", changeType: .unchanged),
                FileDiff.Line(text: "struct ShellOutExecutor: ShellOutExecuting {", changeType: .unchanged),
            ]),
        ]))
    }

    // swiftlint:disable all
    var testDiff: String {
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
        diff --git a/.swiftpm/xcode/package.xcworkspace/xcuserdata/franco.xcuserdatad/UserInterfaceState.xcuserstate b/.swiftpm/xcode/package.xcworkspace/xcuserdata/franco.xcuserdatad/UserInterfaceState.xcuserstate
        new file mode 100644
        index 0000000..70bdf2c
        Binary files /dev/null and b/.swiftpm/xcode/package.xcworkspace/xcuserdata/franco.xcuserdatad/UserInterfaceState.xcuserstate differ
        diff --git a/Gemfile b/Gemfile
        deleted file mode 100644
        index d7ba66f..0000000
        --- a/Gemfile
        +++ /dev/null
        @@ -1,7 +0,0 @@
        -# frozen_string_literal: true
        -
        -source "https://rubygems.org"
        -
        -git_source(:github) {|repo_name| "https://github.com/#{repo_name}" }
        -
        -gem "xcpretty-json-formatter"
        diff --git a/Sources/DangerSwiftCoverage/Models/Report.swift b/Sources/DangerSwiftCoverage/Models/Report.swift
        index 4866851..23ea2be 100644
        --- a/Sources/DangerSwiftCoverage/Models/Report.swift
        +++ b/Sources/DangerSwiftCoverage/Models/Report.swift
        @@ -20,7 +20,8 @@ extension ReportSection {
         extension ReportSection {
             init(fromSPM spm: SPMCoverage, fileManager: FileManager) {
                 titleText = nil
        -        items = spm.data.flatMap { $0.files.map { ReportFile(fileName: $0.filename.deletingPrefix(fileManager.currentDirectoryPath + "/"), coverage: $0.summary.percent) } }
        +        items = spm.data.flatMap { $0.files.map { ReportFile(fileName: $0.filename.deletingPrefix(fileManager.currentDirectoryPath + "/"), coverage: $0.summary.percent)
        +        } }
             }
         }
         
        diff --git a/Sources/DangerSwiftCoverage/SPM/SPMCoverageParser.swift b/Sources/DangerSwiftCoverage/SPM/SPMCoverageParser.swift
        index 7b22444..1e7d9ff 100644
        --- a/Sources/DangerSwiftCoverage/SPM/SPMCoverageParser.swift
        +++ b/Sources/DangerSwiftCoverage/SPM/SPMCoverageParser.swift
        @@ -1,8 +1,11 @@
         import Foundation
         
        +
        +
        +
        +
         protocol SPMCoverageParsing {
        -    static func coverage(spmCoverageFolder: String, files: [String]) throws -> Report
        -}
        +    static func coverage(spmCoverageFolder: String, files: [String]) throws -> Re
         
         enum SPMCoverageParser: SPMCoverageParsing {
             enum Errors: Error {
        @@ -22,6 +25,10 @@ enum SPMCoverageParser: SPMCoverageParsing {
                 let coverage = try JSONDecoder().decode(SPMCoverage.self, from: data)
                 let filteredCoverage = coverage.filteringFiles(notOn: files)
         
        -        return Report(messages: [], sections: [ReportSection(fromSPM: filteredCoverage, fileManager: fileManager)])
        +        if filteredCoverage.data.contains(where: { !$0.files.isEmpty }) {
        +            return Report(messages: [], sections: [ReportSection(fromSPM: filteredCoverage, fileManager: fileManager)])
        +        } else {
        +            return Report(messages: [], sections: [])
        +        }
             }
         }
        diff --git a/Sources/DangerSwiftCoverage/ShellOutExecutor.swift b/Sources/DangerSwiftCoverage/ShellOutExecutor1.swift
        similarity index 99%
        rename from Sources/DangerSwiftCoverage/ShellOutExecutor.swift
        rename to Sources/DangerSwiftCoverage/ShellOutExecutor1.swift
        index 2716c0f..eaa54b1 100644
        --- a/Sources/DangerSwiftCoverage/ShellOutExecutor.swift
        +++ b/Sources/DangerSwiftCoverage/ShellOutExecutor1.swift
        @@ -3,6 +3,8 @@ import Foundation
         
         protocol ShellOutExecuting {
             func execute(command: String) throws -> Data
        +
        +
         }
         
         struct ShellOutExecutor: ShellOutExecuting {
        """
    }
}
