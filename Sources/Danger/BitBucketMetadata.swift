public struct BitBucketMetadata: Decodable, Equatable {
    /// The PR's ID
    public var pullRequestID: String
    /// The complete repo slug including project slug.
    public var repoSlug: String
}
