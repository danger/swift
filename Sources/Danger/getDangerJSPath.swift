import Foundation
import ShellOut

public func getDangerCommandPath(_ command: String, logger: Logger) throws -> String {
    logger.debug("Finding out where the danger executable is")
    return try shellOut(to: "which danger-" + command).trimmingCharacters(in: .whitespaces)
}
