//
//  CliArgsParser.swift
//  Danger
//
//  Created by Franco Meloni on 12/11/2018.
//

import Foundation

public final class CliArgsParser {
    public init() {}
    
    public func parseCli(fromData data: Data) -> CliArgs? {
        if let dictionary = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? NSDictionary,
            let cliArgsDictionary = dictionary?.value(forKeyPath: "danger.settings.cliArgs") as? [String:Any] {
            return CliArgs(dictionary: cliArgsDictionary)
        }
        
        return nil
    }
}
