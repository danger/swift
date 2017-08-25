import Foundation

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

private final class DangerRunner {
    static var shared = DangerRunner()

    let dsl: DSL
    var rules = [DangerRule]()

    private init() {

        let dslJSONArg: String? = CommandLine.arguments[1]
//        var outputJSON = CommandLine.arguments[2]

        guard let dslJSONPath = dslJSONArg else {
            print("could not find DSL JSON arg")
            exit(1)
        }

        guard let dslJSONContents = FileManager.default.contents(atPath: dslJSONPath) else {
            print("could not find DSL JSON at path: \(dslJSONPath)")
            exit(1)
        }

        do {
            let decoder = JSONDecoder()
            dsl = try decoder.decode(DSL.self, from: dslJSONContents)

        } catch let error {
            print("Failed to parse JSON:")
            print(error)
            exit(1)
        }

        dumpResultsAtExit(self, path: "somewhere")
    }

    func add(_ rule: DangerRule) {
        rules.append(rule)
    }
}

public func Danger() -> DangerDSL {
    return DangerRunner.shared.dsl.danger
}

public func warn(_ message: String) {
    DangerRunner.shared.add(WarningRule(message))
}

public func fail(_ message: String) {
    DangerRunner.shared.add(FailureRule(message))
}

public func markdown(_ message: String) {
    DangerRunner.shared.add(MarkdownRule(message))
}

private var dumpInfo: (danger: DangerRunner, path: String)?
private func dumpResultsAtExit(_ runner: DangerRunner, path: String) {
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
