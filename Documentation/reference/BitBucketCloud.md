# BitBucketCloud

``` swift
public struct BitBucketCloud: Decodable
```

## Inheritance

`Decodable`

## Enumeration Cases

### `declined`

``` swift
case declined
```

### `merged`

``` swift
case merged
```

### `open`

``` swift
case open
```

### `suspended`

``` swift
case suspended
```

### `reviewer`

``` swift
case reviewer
```

### `participant`

``` swift
case participant
```

## Properties

### `activities`

The activities such as OPENING, CLOSING, MERGING or UPDATING a pull request

``` swift
let activities: [Activity]
```

### `comments`

The comments on the pull request

``` swift
let comments: [Comment]
```

### `commits`

The commits associated with the pull request

``` swift
let commits: [Commit]
```

### `metadata`

The pull request and repository metadata

``` swift
let metadata: BitBucketMetadata
```

### `pr`

The PR metadata

``` swift
let pr: PullRequest
```

### `approved`

Did they approve of the PR?

``` swift
let approved: Bool
```

### `role`

How did they contribute

``` swift
let role: Role
```

### `user`

The user who participated in this PR

``` swift
let user: User
```

### `author`

The creator of the PR

``` swift
let author: User
```

### `createdOn`

Date when PR was created

``` swift
let createdOn: Date
```

### `description`

The text describing the PR

``` swift
let description: String
```

### `destination`

The PR's destination

``` swift
let destination: MergeRef
```

### `id`

PR's ID

``` swift
let id: Int
```

### `participants`

People who have participated in the PR

``` swift
let participants: [Participant]
```

### `reviewers`

People requested as reviewers

``` swift
let reviewers: [User]
```

### `source`

The PR's source, The repo Danger is running on

``` swift
let source: MergeRef
```

### `state`

The pull request's current status.

``` swift
let state: State
```

### `title`

Title of the pull request

``` swift
let title: String
```

### `updatedOn`

Date of last update

``` swift
let updatedOn: Date
```

### `branchName`

``` swift
var branchName: String
```

### `commitHash`

Hash of the last commit

``` swift
var commitHash: String
```

### `repository`

``` swift
let repository: Repo
```

### `fullName`

``` swift
let fullName: String
```

### `name`

``` swift
let name: String
```

### `uuid`

The uuid of the repository

``` swift
let uuid: String
```

### `accountId`

The acount id of the user

``` swift
let accountId: String
```

### `displayName`

The display name of user

``` swift
let displayName: String
```

### `nickname`

The nick name of the user

``` swift
let nickname: String
```

### `uuid`

The uuid of the user

``` swift
let uuid: String
```

### `author`

The author of the commit, assumed to be the person who wrote the code.

``` swift
let author: Author
```

### `date`

When the commit was commited to the project

``` swift
let date: Date
```

### `hash`

The SHA for the commit

``` swift
let hash: String
```

### `message`

The commit's message

``` swift
let message: String
```

### `from`

``` swift
let from: Int?
```

### `to`

``` swift
let to: Int?
```

### `path`

``` swift
let path: String?
```

### `content`

Content of the comment

``` swift
let content: Content
```

### `createdOn`

When the comment was created

``` swift
let createdOn: Date
```

### `deleted`

Was the comment deleted?

``` swift
let deleted: Bool
```

### `id`

``` swift
let id: Int
```

### `inline`

``` swift
let inline: Inline?
```

### `type`

``` swift
let type: String
```

### `updatedOn`

When the comment was updated

``` swift
let updatedOn: Date
```

### `user`

The user that created the comment

``` swift
let user: User
```

### `html`

``` swift
let html: String
```

### `markup`

``` swift
let markup: String
```

### `raw`

``` swift
let raw: String
```

### `comment`

``` swift
let comment: Comment?
```
