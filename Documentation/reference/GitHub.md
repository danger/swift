# GitHub

The GitHub metadata for your pull request.

``` swift
public struct GitHub: Decodable
```

## Inheritance

`Decodable`

## Enumeration Cases

### `open`

``` swift
case open
```

### `closed`

``` swift
case closed
```

### `merged`

``` swift
case merged
```

### `locked`

``` swift
case locked
```

### `user`

``` swift
case user
```

### `organization`

``` swift
case organization
```

### `bot`

``` swift
case bot
```

### `approved`

``` swift
case approved
```

### `requestedChanges`

``` swift
case requestedChanges
```

### `comment`

``` swift
case comment
```

### `pending`

``` swift
case pending
```

### `dismissed`

``` swift
case dismissed
```

### `open`

``` swift
case open
```

### `closed`

``` swift
case closed
```

### `locked`

``` swift
case locked
```

### `open`

``` swift
case open
```

### `closed`

``` swift
case closed
```

### `all`

``` swift
case all
```

## Initializers

### `init(from:)`

``` swift
public init(from decoder: Decoder) throws
```

## Properties

### `issue`

``` swift
let issue: Issue
```

### `pullRequest`

``` swift
let pullRequest: PullRequest
```

### `commits`

``` swift
let commits: [Commit]
```

### `reviews`

``` swift
let reviews: [Review]
```

### `requestedReviewers`

``` swift
let requestedReviewers: RequestedReviewers
```

### `api`

``` swift
var api: Octokit!
```

### `number`

The number of the pull request.

``` swift
let number: Int
```

### `title`

The title of the pull request.

``` swift
let title: String
```

### `body`

The markdown body message of the pull request.

``` swift
let body: String?
```

### `user`

The user who submitted the pull request.

``` swift
let user: User
```

### `assignee`

The user who is assigned to the pull request.

``` swift
let assignee: User?
```

### `assignees`

The users who are assigned to the pull request.

``` swift
let assignees: [User]?
```

### `createdAt`

The ISO8601 date string for when the pull request was created.

``` swift
let createdAt: Date
```

### `updatedAt`

The ISO8601 date string for when the pull request was updated.

``` swift
let updatedAt: Date
```

### `closedAt`

The ISO8601 date string for when the pull request was closed.

``` swift
let closedAt: Date?
```

### `mergedAt`

The ISO8601 date string for when the pull request was merged.

``` swift
let mergedAt: Date?
```

### `head`

The merge reference for the *other* repo.

``` swift
let head: MergeRef
```

### `base`

The merge reference for *this* repo.

``` swift
let base: MergeRef
```

### `state`

The state for the pull request: open, closed, locked, merged.

``` swift
let state: PullRequestState
```

### `isLocked`

A boolean indicating if the pull request has been locked to contributors only.

``` swift
let isLocked: Bool
```

### `isMerged`

A boolean indicating if the pull request has been merged.

``` swift
let isMerged: Bool?
```

### `commitCount`

The number of commits in the pull request.

``` swift
let commitCount: Int?
```

### `commentCount`

The number of comments in the pull request.

``` swift
let commentCount: Int?
```

### `reviewCommentCount`

The number of review-specific comments in the pull request.

``` swift
let reviewCommentCount: Int?
```

### `additions`

The number of added lines in the pull request.

``` swift
let additions: Int?
```

### `deletions`

The number of deleted lines in the pull request.

``` swift
let deletions: Int?
```

### `changedFiles`

The number of files changed in the pull request.

``` swift
let changedFiles: Int?
```

### `milestone`

The milestone of the pull request

``` swift
let milestone: Milestone?
```

### `htmlUrl`

The link back to this PR as user-facing

``` swift
let htmlUrl: String
```

### `id`

The UUID for the user organization.

``` swift
let id: Int
```

### `login`

The handle for the user or organization.

``` swift
let login: String
```

### `userType`

The type of user: user, organization, or bot.

``` swift
let userType: UserType
```

### `id`

The UUID for the team.

``` swift
let id: Int
```

### `name`

The team name

``` swift
let name: String
```

### `users`

The list of users of whom a review has been requested.

``` swift
let users: [User]
```

### `teams`

The list of teams of whom a review has been requested.

``` swift
let teams: [Team]
```

### `label`

The human display name for the merge reference, e.g. "artsy:master".

``` swift
let label: String
```

### `ref`

The reference point for the merge, e.g. "master"

``` swift
let ref: String
```

### `sha`

The reference point for the merge, e.g. "704dc55988c6996f69b6873c2424be7d1de67bbe"

``` swift
let sha: String
```

### `user`

The user that owns the merge reference e.g. "artsy"

``` swift
let user: User
```

### `repo`

The repo from which the reference comes from

``` swift
let repo: Repo
```

### `id`

Generic UUID.

``` swift
let id: Int
```

### `name`

The name of the repo, e.g. "danger-swift".

``` swift
let name: String
```

### `fullName`

The full name of the owner + repo, e.g. "Danger/danger-swift"

``` swift
let fullName: String
```

### `owner`

The owner of the repo.

``` swift
let owner: User
```

### `isPrivate`

A boolean stating whether the repo is publicly accessible.

``` swift
let isPrivate: Bool
```

### `description`

A textual description of the repo.

``` swift
let description: String?
```

### `isFork`

A boolean stating whether the repo is a fork.

``` swift
let isFork: Bool
```

### `htmlURL`

The root web URL for the repo, e.g. https://github.com/artsy/emission

``` swift
let htmlURL: String
```

### `body`

The body of the review (if a review was made).

``` swift
let body: String?
```

### `commitId`

The commit ID the review was made on (if a review was made).

``` swift
let commitId: String?
```

### `id`

The id for the review (if a review was made).

``` swift
let id: Int?
```

### `state`

The state of the review (if a review was made).

``` swift
let state: State?
```

### `submittedAt`

The date when the review was submitted

``` swift
let submittedAt: Date
```

### `user`

The user who has completed the review or has been requested to review.

``` swift
let user: User
```

### `sha`

The SHA for the commit.

``` swift
let sha: String
```

### `commit`

The raw commit metadata.

``` swift
let commit: Git.Commit
```

### `url`

The URL for the commit on GitHub.

``` swift
let url: String
```

### `author`

The GitHub user who wrote the code.

``` swift
let author: User?
```

### `committer`

The GitHub user who shipped the code.

``` swift
let committer: User?
```

### `id`

The id number of this label.

``` swift
let id: Int
```

### `url`

The URL that links to this label.

``` swift
let url: String
```

### `name`

The name of the label.

``` swift
let name: String
```

### `color`

The color associated with this label.

``` swift
let color: String
```

### `id`

The id number of the issue

``` swift
let id: Int
```

### `number`

The number of the issue.

``` swift
let number: Int
```

### `title`

The title of the issue.

``` swift
let title: String
```

### `user`

The user who created the issue.

``` swift
let user: User
```

### `state`

The state for the issue: open, closed, locked.

``` swift
let state: State
```

### `isLocked`

A boolean indicating if the issue has been locked to contributors only.

``` swift
let isLocked: Bool
```

### `body`

The markdown body message of the issue.

``` swift
let body: String?
```

### `commentCount`

The comment number of comments for the issue.

``` swift
let commentCount: Int
```

### `assignee`

The user who is assigned to the issue.

``` swift
let assignee: User?
```

### `assignees`

The users who are assigned to the issue.

``` swift
let assignees: [User]
```

### `milestone`

The milestone of this issue

``` swift
let milestone: Milestone?
```

### `createdAt`

The ISO8601 date string for when the issue was created.

``` swift
let createdAt: Date
```

### `updatedAt`

The ISO8601 date string for when the issue was updated.

``` swift
let updatedAt: Date
```

### `closedAt`

The ISO8601 date string for when the issue was closed.

``` swift
let closedAt: Date?
```

### `labels`

The labels associated with this issue.

``` swift
let labels: [Label]
```

### `id`

The id number of this milestone

``` swift
let id: Int
```

### `number`

The number of this milestone

``` swift
let number: Int
```

### `state`

The state of this milestone: open, closed, all

``` swift
let state: State
```

### `title`

The title of this milestone

``` swift
let title: String
```

### `description`

The description of this milestone.

``` swift
let description: String?
```

### `creator`

The user who created this milestone.

``` swift
let creator: User
```

### `openIssues`

The number of open issues in this milestone

``` swift
let openIssues: Int
```

### `closedIssues`

The number of closed issues in this milestone

``` swift
let closedIssues: Int
```

### `createdAt`

The ISO8601 date string for when this milestone was created.

``` swift
let createdAt: Date
```

### `updatedAt`

The ISO8601 date string for when this milestone was updated.

``` swift
let updatedAt: Date
```

### `closedAt`

The ISO8601 date string for when this milestone was closed.

``` swift
let closedAt: Date?
```

### `dueOn`

The ISO8601 date string for the due of this milestone.

``` swift
let dueOn: Date?
```
