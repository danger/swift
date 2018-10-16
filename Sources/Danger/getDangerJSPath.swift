import Foundation
import ShellOut

public func getDangerJSPath() throws -> String {
    return try shellOut(to: "which danger").trimmingCharacters(in: .whitespaces)
}
