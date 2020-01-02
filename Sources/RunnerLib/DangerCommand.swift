public enum DangerCommand: String, CaseIterable {
    case ci
    case local
    case pr
    case edit
    case runner

    var commandDescription: String {
        switch self {
        case .ci:
            return "Use this on CI"
        case .edit:
            return "Creates a temporary Xcode project for working on a Dangerfile"
        case .local:
            return "Use this to run danger against your local changes from master"
        case .pr:
            return "Run danger-swift locally against a PR"
        case .runner:
            return "Use this to trigger the Dangerfile evaluation"
        }
    }

    public static var commandsListText: String {
        allCases.reduce("") { (result, command) -> String in
            result + command.rawValue + "\t" + command.commandDescription + "\n"
        }
    }
}
