import Foundation

public final class CliArgsParser {
    public init() {}

    public func parseCli(fromData data: Data) -> CliArgs? {
        if let dictionary = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any],
           let danger = dictionary["danger"] as? [String: Any],
           let settings = danger["settings"] as? [String: Any],
           let cliArgsDictionary = settings["cliArgs"] as? [String: Any]
        {
            return CliArgs(dictionary: cliArgsDictionary)
        }

        return nil
    }
}
