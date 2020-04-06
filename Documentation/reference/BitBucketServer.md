# BitBucketServer

``` swift
public struct BitBucketServer: Decodable, Equatable
```

## Inheritance

`Decodable`, `Equatable`

## Properties

### `metadata`

The pull request and repository metadata

``` swift
let metadata: BitBucketMetadata
```

### `pullRequest`

The pull request metadata

``` swift
let pullRequest: PullRequest
```

### `commits`

The commits associated with the pull request

``` swift
let commits: [Commit]
```

### `comments`

The comments on the pull request

``` swift
let comments: [Comment]
```

### `activities`

The activities such as OPENING, CLOSING, MERGING or UPDATING a pull request

``` swift
let activities: [Activity]
```

### `id`

The activity's ID

``` swift
let id: Int
```

### `createdAt`

Date activity created as number of mili seconds since the unix epoch

``` swift
let createdAt: Int
```

### `user`

The user that triggered the activity.

``` swift
let user: User
```

### `action`

The action the activity describes (e.g. "COMMENTED").

``` swift
let action: String
```

### `commentAction`

In case the action was "COMMENTED" it will state the command specific action (e.g. "CREATED").

``` swift
let commentAction: String?
```

### `id`

The comment's id

``` swift
let id: Int
```

### `createdAt`

Date comment created as number of mili seconds since the unix epoch

``` swift
let createdAt: Int
```

### `user`

The comment's author

``` swift
let user: User
```

### `action`

The action the user did (e.g. "COMMENTED")

``` swift
let action: String
```

### `fromHash`

The SHA to which the comment was created

``` swift
let fromHash: String?
```

### `previousFromHash`

The previous SHA to which the comment was created

``` swift
let previousFromHash: String?
```

### `toHash`

The next SHA after the comment was created

``` swift
let toHash: String?
```

### `previousToHash`

The SHA to which the comment was created

``` swift
let previousToHash: String?
```

### `commentAction`

Action the user did (e.g. "ADDED") if it is a new task

``` swift
let commentAction: String?
```

### `comment`

Detailed data of the comment

``` swift
let comment: Detail?
```

### `id`

The comment's id

``` swift
let id: Int
```

### `version`

The comment's version

``` swift
let version: Int
```

### `text`

The comment content

``` swift
let text: String
```

### `author`

The author of the comment

``` swift
let author: User
```

### `createdAt`

Date comment created as number of mili seconds since the unix epoch

``` swift
let createdAt: Int
```

### `updatedAt`

Date comment updated as number of mili seconds since the unix epoch

``` swift
let updatedAt: Int
```

### `comments`

Replys to the comment

``` swift
let comments: [Detail]
```

### `properties`

Properties associated with the comment

``` swift
let properties: InnerProperties
```

### `tasks`

Tasks associated with the comment

``` swift
let tasks: [Task]
```

### `id`

The tasks ID

``` swift
let id: Int
```

### `createdAt`

Date activity created as number of mili seconds since the unix epoch

``` swift
let createdAt: Int
```

### `text`

The text of the task

``` swift
let text: String
```

### `state`

The state of the task (e.g. "OPEN")

``` swift
let state: String
```

### `author`

The author of the comment

``` swift
let author: User
```

### `repositoryId`

The ID of the repo

``` swift
let repositoryId: Int
```

### `issues`

Slugs of linkd Jira issues

``` swift
let issues: [String]?
```

### `id`

The SHA for the commit

``` swift
let id: String
```

### `displayId`

The shortened SHA for the commit

``` swift
let displayId: String
```

### `author`

The author of the commit, assumed to be the person who wrote the code.

``` swift
let author: User
```

### `authorTimestamp`

The UNIX timestamp for when the commit was authored

``` swift
let authorTimestamp: Int
```

### `committer`

The author of the commit, assumed to be the person who commited/merged the code into a project.

``` swift
let committer: User?
```

### `committerTimestamp`

When the commit was commited to the project

``` swift
let committerTimestamp: Int?
```

### `message`

The commit's message

``` swift
let message: String
```

### `parents`

The commit's parents

``` swift
let parents: [Parent]
```

### `id`

The SHA for the commit

``` swift
let id: String
```

### `displayId`

The shortened SHA for the commit

``` swift
let displayId: String
```

### `id`

The PR's ID

``` swift
let id: Int
```

### `version`

The API version

``` swift
let version: Int
```

### `title`

Title of the pull request.

``` swift
let title: String
```

### `description`

The description of the PR

``` swift
let description: String?
```

### `state`

The pull request's current status.

``` swift
let state: String
```

### `open`

Is PR open?

``` swift
let open: Bool
```

### `closed`

Is PR closed?

``` swift
let closed: Bool
```

### `createdAt`

Date PR created as number of mili seconds since the unix epoch

``` swift
let createdAt: Int
```

### `updatedAt`

Date PR updated as number of mili seconds since the unix epoch

``` swift
let updatedAt: Int?
```

### `fromRef`

The PR submittor's reference

``` swift
let fromRef: MergeRef
```

### `toRef`

The repo Danger is running on

``` swift
let toRef: MergeRef
```

### `isLocked`

Is the PR locked?

``` swift
let isLocked: Bool
```

### `author`

The creator of the PR

``` swift
let author: Participant
```

### `reviewers`

People requested as reviewers

``` swift
let reviewers: [Reviewer]
```

### `participants`

People who have participated in the PR

``` swift
let participants: [Participant]
```

### `user`

The BitBucket Server User

``` swift
let user: User
```

### `user`

The BitBucket Server User

``` swift
let user: User
```

### `approved`

The approval status

``` swift
let approved: Bool
```

### `lastReviewedCommit`

The commit SHA for the latest commit that was reviewed

``` swift
let lastReviewedCommit: String?
```

### `id`

The branch name

``` swift
let id: String
```

### `displayId`

The human readable branch name

``` swift
let displayId: String
```

### `latestCommit`

The SHA for the latest commit

``` swift
let latestCommit: String
```

### `repository`

Info of the associated repository

``` swift
let repository: Repo
```

### `name`

The repo name

``` swift
let name: String?
```

### `slug`

The slug for the repo

``` swift
let slug: String
```

### `scmId`

The type of SCM tool, probably "git"

``` swift
let scmId: String
```

### `isPublic`

Is the repo public?

``` swift
let isPublic: Bool
```

### `forkable`

Can someone fork thie repo?

``` swift
let forkable: Bool
```

### `project`

An abtraction for grouping repos

``` swift
let project: Project
```

### `id`

The project unique id

``` swift
let id: Int
```

### `key`

The project's human readable project key

``` swift
let key: String
```

### `name`

The name of the project

``` swift
let name: String
```

### `isPublic`

Is the project publicly available

``` swift
let isPublic: Bool
```

### `type`

``` swift
let type: String
```

### `id`

The unique user ID

``` swift
let id: Int?
```

### `name`

The name of the user

``` swift
let name: String
```

### `displayName`

The name to use when referencing the user

``` swift
let displayName: String?
```

### `emailAddress`

The email for the user

``` swift
let emailAddress: String?
```

### `active`

Is the account active

``` swift
let active: Bool?
```

### `slug`

The user's slug for URLs

``` swift
let slug: String?
```

### `type`

The type of a user, "NORMAL" being a typical user3

``` swift
let type: String?
```
