import Foundation

/// The git specific metadata for a pull request.
public struct Git: Decodable, Equatable {
    enum CodingKeys: String, CodingKey {
        case modifiedFiles = "modified_files"
        case createdFiles = "created_files"
        case deletedFiles = "deleted_files"
    }

    /// Modified filepaths relative to the git root.
    public let modifiedFiles: [File]

    /// Newly created filepaths relative to the git root.
    public let createdFiles: [File]

    /// Removed filepaths relative to the git root.
    public let deletedFiles: [File]
}

/// A platform agnostic reference to a git commit.
public struct GitCommit: Decodable, Equatable {
    /// The SHA for the commit.
    public let sha: String?

    /// Who wrote the commit.
    public let author: GitCommitAuthor

    /// Who shipped the code.
    public let committer: GitCommitAuthor

    /// The message for the commit.
    public let message: String

    /// SHAs for the commit's parents.
    public let parents: [String]?

    /// The URL for the commit.
    public let url: String
}

/// The author of a commit.
public struct GitCommitAuthor: Decodable, Equatable {
    /// The display name for the author.
    public let name: String

    /// The email for the author.
    public let email: String

    /// The ISO8601 date string for the commit.
    public let date: String
}
