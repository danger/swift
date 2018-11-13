//
//  CliArgs.swift
//  Danger
//
//  Created by Franco Meloni on 12/11/2018.
//

// Describes the possible arguments that could be used when calling the CLI
public struct CliArgs {
    // So you can have many danger runs in one code review
    public let id: String?
    
    // The base reference used by danger PR (e.g. not master)
    public let base: String?
    
    // For debugging
    public let verbose: String?
    
    // Used by danger-js o allow having a custom CI
    public let externalCiProvider: String?
    
    // textOnly
    public let textOnly: String?
    
    // A custom path for the dangerfile (can also be a remote reference)
    public let dangerfile: String?
    
    fileprivate enum CodingKeys: String {
        case id
        case base
        case verbose
        case externalCiProvider
        case textOnly
        case dangerfile
    }
    
    init(dictionary: [String:Any]) {
        self.id = dictionary[.id] as? String
        self.base = dictionary[.base] as? String
        self.verbose = dictionary[.verbose] as? String
        self.externalCiProvider = dictionary[.externalCiProvider] as? String
        self.textOnly = dictionary[.textOnly] as? String
        self.dangerfile = dictionary[.dangerfile] as? String
    }
}

private extension Dictionary where Key == String {
    subscript(_ codingKey: CliArgs.CodingKeys) -> Value? {
        return self[codingKey.rawValue]
    }
}
