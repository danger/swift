#if os(Linux)
    import Glibc
#else
    import Darwin.C
#endif

protocol DangerRule {
    var message: String { get }
}

struct WarningRule: DangerRule {
    let message: String

    init(_ message: String) {
        self.message = message
    }
}

struct FailureRule: DangerRule {
    let message: String

    init(_ message: String) {
        self.message = message
    }
}

struct MarkdownRule: DangerRule {
    let message: String

    init(_ message: String) {
        self.message = message
    }
}

final class Danger {
    static var shared = Danger()
    var rules = [DangerRule]()

    private init() {
        dumpResultsAtExit(self, path: "somewhere")
    }

    func add(_ rule: DangerRule) {
        rules.append(rule)
    }
}

public func warn(_ message: String) {
    Danger.shared.add(WarningRule(message))
}

public func fail(_ message: String) {
    Danger.shared.add(FailureRule(message))
}

public func markdown(_ message: String) {
    Danger.shared.add(MarkdownRule(message))
}

private var dumpInfo: (danger: Danger, path: String)?
private func dumpResultsAtExit(_ runner: Danger, path: String) {
    func dump() {
        guard let dumpInfo = dumpInfo else { return }
        print("Sending results back to Danger")
        for rule in dumpInfo.danger.rules {
            print("\(type(of: rule)): \"\(rule.message)\"")
        }
    }
    dumpInfo = (runner, path)
    atexit(dump)
}
