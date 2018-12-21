import Foundation
import Logger
import ShellOut

public func getDangerCommandPath(logger: Logger) throws -> String {
    logger.debug("Finding out where the danger executable is")
    return try shellOut(to: "which danger").trimmingCharacters(in: .whitespaces)
}
