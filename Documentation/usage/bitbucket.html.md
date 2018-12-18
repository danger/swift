---
title: Danger + BitBucket Server
subtitle: Dangerous bits
layout: guide_sw
order: 4
blurb: An overview of using Danger with BitBucket Server, and some examples
---

To use Danger JS with BitBucket Server: you'll need to create a new account for Danger to use, then set the following
environment variables on your CI:

- `DANGER_BITBUCKETSERVER_HOST` = The root URL for your server, e.g. `https://bitbucket.mycompany.com`.
- `DANGER_BITBUCKETSERVER_USERNAME` = The username for the account used to comment.

Also you need to set password or
[personal access token](https://confluence.atlassian.com/bitbucketserver/personal-access-tokens-939515499.html) by
environment variables:

- `DANGER_BITBUCKETSERVER_PASSWORD` = The password for the account used to comment.
- `DANGER_BITBUCKETSERVER_TOKEN` = The personal access token for the account used to comment.

Then in your Dangerfiles you will have a fully fleshed out `danger.bitbucketServer` object to work with. For example:

```swift
import Danger
import Foundation

let danger = Danger()

let isAssignedToMe = danger.bitbucketServer.pullRequest.reviewers.map { $0.name }.contains("orta")
if isAssignedToMe {
    fail("You should probably assign someone else")
}
```

The DSL is expansive, you can see all the details inside the [Danger Swift Reference][ref], but the TLDR is:

```ts
danger.bitbucketServer.

  /** The pull request and repository metadata */
  metadata: RepoMetaData
  /** The PR metadata */
  pullRequest: BitBucketServerPR
  /** The commits associated with the pull request */
  commits: [BitBucketServerCommit]
  /** The comments on the pull request */
  comments: [BitBucketServerPRActivity]
  /** The activities such as OPENING, CLOSING, MERGING or UPDATING a pull request */
  activities: [BitBucketServerPRActivity]
```

Here are some example rules using the DSL:

```swift
import Danger
import Foundation

let danger = Danger()
let bbs = danger.bitbucketServer!

// Make a warning if there are changes to a Package.swift but that a
// user called murphdog hasn't yet weighed in that the changes are fine.
let hasPackageChanges = danger.git.modifiedFiles.contains("Package.swift")
let hasMurphDogApproval = bbs.comments.first { $0.user.slug == "murphdog" }
if (hasPackageChanges && (hasMurphDogApproval == nil)) {
    warn("This PR has `package.json` changes, but @murphdog hasn't approved them yet.")
}

// Enforce team "fun"
let hasGIF = bbs.pullRequest.description?.contains(".gif")
if (hasGIF ?? false) {
    fail("This PR needs a GIF.")
}
```

Plus any other example you can find that uses GitHub, will probably work in BitBucket Server, with a bit of DSL
translation.

In addition, it is possible to specify a proxy to be used for the requests using environmental variables. This is useful
for debugging:

```ts
export NODE_TLS_REJECT_UNAUTHORIZED=0 # Avoid certificate error

export http_proxy=http://127.0.0.1:8080
or
export https_proxy=https://127.0.0.1:8080
```
