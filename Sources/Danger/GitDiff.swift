import Foundation

public struct FileDiff: Equatable, CustomStringConvertible {
    private let parsedHeader: ParsedHeader
    private let hunks: [FileDiff.Hunk]

    init(parsedHeader: ParsedHeader, hunks: [FileDiff.Hunk]) {
        self.parsedHeader = parsedHeader
        self.hunks = hunks
    }

    public var filePath: String {
        parsedHeader.filePath
    }

    public var changes: Changes {
        switch parsedHeader.change {
        case .created:
            .created(addedLines: hunks.flatMap { hunk in hunk.lines.map(\.text) })
        case .deleted:
            .deleted(deletedLines: hunks.flatMap { hunk in hunk.lines.map(\.text) })
        case .modified:
            .modified(hunks: hunks)
        case let .renamed(oldPath: oldPath):
            .renamed(oldPath: oldPath, hunks: hunks)
        }
    }

    public var description: String {
        hunks.map(\.description).joined(separator: "\n")
    }
}

extension FileDiff {
    struct ParsedHeader: Equatable {
        let filePath: String
        let change: ChangeType
    }
}

extension FileDiff.ParsedHeader {
    enum ChangeType: Equatable {
        case created
        case deleted
        case renamed(oldPath: String)
        case modified
    }
}

public extension FileDiff {
    enum Changes: Equatable {
        case created(addedLines: [String])
        case deleted(deletedLines: [String])
        case modified(hunks: [Hunk])
        case renamed(oldPath: String, hunks: [Hunk])
    }

    struct Hunk: Equatable, CustomStringConvertible {
        public let oldLineStart: Int
        public let oldLineSpan: Int
        public let newLineStart: Int
        public let newLineSpan: Int
        public let lines: [Line]
        public var description: String {
            "@@ -\(oldLineStart),\(oldLineSpan) +\(newLineStart),\(newLineSpan) @@" +
                lines.map(\.description).joined(separator: "\n")
        }
    }

    struct Line: Equatable, CustomStringConvertible {
        let text: String
        let changeType: ChangeType
        public var description: String {
            switch changeType {
            case .added:
                "+" + text
            case .removed:
                "-" + text
            case .unchanged:
                " " + text
            }
        }
    }
}

extension FileDiff.Line {
    enum ChangeType: Equatable {
        case added
        case removed
        case unchanged
    }
}

extension StringProtocol {
    func deletingPrefix(_ prefix: String) -> String {
        guard hasPrefix(prefix) else { return String(self) }
        return String(dropFirst(prefix.count))
    }
}

struct DiffParser {
    func parse(_ diff: String) -> [FileDiff] {
        diff.components(separatedBy: "diff --git ").compactMap { fileDiff in
            let headerAndHunks = fileDiff.components(separatedBy: "@@")
            guard let header = headerAndHunks.first,
                  !header.isEmpty
            else {
                return nil
            }

            return FileDiff(parsedHeader: parseHeader(header), hunks: parseHunks(Array(headerAndHunks.dropFirst())))
        }
    }

    private func parseHeader(_ header: String) -> FileDiff.ParsedHeader {
        let lines = header.components(separatedBy: "\n")

        let filePath = lines.first?.split(separator: " ").first(where: { $0.starts(with: "b/") })?
            .deletingPrefix("b/") ?? ""

        let change: FileDiff.ParsedHeader.ChangeType = if lines.contains(where: { $0.hasPrefix("deleted file mode ") }) {
            .deleted
        } else if lines.contains(where: { $0.hasPrefix("new file mode") }) {
            .created
        } else if let modifiedLineIndex = lines.firstIndex(where: { $0.hasPrefix("rename from ") }) {
            .renamed(oldPath: lines[modifiedLineIndex].deletingPrefix("rename from "))
        } else {
            .modified
        }

        return FileDiff.ParsedHeader(filePath: filePath, change: change)
    }

    private func parseHunks(_ hunks: [String]) -> [FileDiff.Hunk] {
        (0 ..< hunks.count / 2).compactMap { index -> FileDiff.Hunk? in
            let changesSpan = hunks[index * 2]
            let changes = hunks[index * 2 + 1]
            let lines = changes.components(separatedBy: "\n").dropFirst().filter { !$0.isEmpty }.map(parseLine)
            let parsedChanges = parseChangesSpan(changesSpan)

            return FileDiff.Hunk(oldLineStart: parsedChanges.oldLineStart,
                                 oldLineSpan: parsedChanges.oldLineSpan,
                                 newLineStart: parsedChanges.newLineStart,
                                 newLineSpan: parsedChanges.newLineSpan,
                                 lines: lines)
        }
    }

    private func parseLine(_ line: String) -> FileDiff.Line {
        let text = String(line.dropFirst())
        if line.hasPrefix("+") {
            return FileDiff.Line(text: String(line.dropFirst()), changeType: .added)
        } else if line.hasPrefix("-") {
            return FileDiff.Line(text: String(line.dropFirst()), changeType: .removed)
        } else {
            return FileDiff.Line(text: text, changeType: .unchanged)
        }
    }

    private func parseChangesSpan(_ changesSpan: String) -> HunkSpan {
        let dividedSpan = changesSpan.split(separator: " ").map { $0.dropFirst().components(separatedBy: ",") }
        if dividedSpan.count == 2,
           dividedSpan[0].count == 2,
           dividedSpan[1].count == 2,
           let oldLineStart = Int(dividedSpan[0][0]),
           let oldLineSpan = Int(dividedSpan[0][1]),
           let newLineStart = Int(dividedSpan[1][0]),
           let newLineSpan = Int(dividedSpan[1][1])
        {
            return HunkSpan(oldLineStart: oldLineStart,
                            oldLineSpan: oldLineSpan,
                            newLineStart: newLineStart,
                            newLineSpan: newLineSpan)
        } else {
            return HunkSpan(oldLineStart: 0, oldLineSpan: 0, newLineStart: 0, newLineSpan: 0)
        }
    }
}

private extension DiffParser {
    struct HunkSpan {
        let oldLineStart: Int
        let oldLineSpan: Int
        let newLineStart: Int
        let newLineSpan: Int
    }
}
