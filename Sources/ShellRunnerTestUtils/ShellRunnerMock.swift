import ShellRunner

public final class ShellRunnerMock: ShellRunnerProtocol {
    public enum Call: Equatable {
        case run(RunCallParameters)
    }

    public var calls: [Call] = []

    public init() {}

    public var runReturnValue = ""
    public var runReturnValueClosure: ((RunCallParameters) -> String)?
    public func run(_ command: String, arguments: [String], environmentVariables: [String: String], outputFile: String?) throws -> String {
        let parameters = RunCallParameters(command, arguments, environmentVariables, outputFile)
        calls.append(.run(parameters))
        return runReturnValueClosure?(parameters) ?? runReturnValue
    }

    public struct RunCallParameters: Equatable {
        public let command: String
        public let arguments: [String]
        public let environmentVariables: [String: String]
        public let outputFile: String?

        public init(
            _ command: String,
            _ arguments: [String] = [],
            _ environmentVariables: [String: String] = [:],
            _ outputFile: String? = nil
        ) {
            self.command = command
            self.arguments = arguments
            self.environmentVariables = environmentVariables
            self.outputFile = outputFile
        }
    }
}

public extension ShellRunnerMock.Call {
    var runCallParameters: ShellRunnerMock.RunCallParameters? {
        guard case let .run(parameters) = self else {
            return nil
        }
        return parameters
    }
}
