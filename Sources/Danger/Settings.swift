struct Settings: Decodable {
    let github: GitHubSettings
}

struct GitHubSettings: Decodable {
    let accessToken: String
    let baseURL: String?
}
