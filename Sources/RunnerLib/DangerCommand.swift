//
//  DangerCommand.swift
//  RunnerLib
//
//  Created by Franco Meloni on 23/11/2018.
//

public enum DangerCommand: String, CaseIterable {
    case ci
    case local
    case pr
    case edit
    case runner
    case help
    
    var commandDescription: String {
        switch self {
        case .ci:
            return "Use this on CI"
        case .edit:
            return "Creates a temporary Xcode project for working on a Dangerfile"
        case .local:
            return "Use this to run danger against your local changes from master"
        case .pr:
            return "Use this to build your Dangerfile"
        case .runner:
            return "Use this to trigger the dangerfile evaluation"
        case .help:
            return "Show the commands list"
        }
    }
    
    var parameterName: String? {
        switch self {
        case .pr:
            return "prURL"
        case .ci, .edit, .local, .runner, .help:
            return nil
        }
    }
    
    public static var commandsListText: String {
        return allCases.reduce("") { (result, command) -> String in
            return result + command.rawValue + "\t" + command.commandDescription + "\n"
        }
    }
}
