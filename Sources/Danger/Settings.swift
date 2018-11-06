//
//  Settings.swift
//  Danger
//
//  Created by Franco Meloni on 06/11/2018.
//

struct Settings: Decodable {
    let github: GitHubSettings
}

struct GitHubSettings: Decodable {
    let accessToken: String
    let baseURL: String?
}
