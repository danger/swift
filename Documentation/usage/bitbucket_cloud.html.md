---
title: Danger + BitBucket Cloud
subtitle: Dangerous bits
layout: guide_sw
order: 4
blurb: An overview of using Danger with BitBucket Cloud, and some examples
---

To use Danger Swift with BitBucket Cloud: you'll need to create a new account for Danger to use, then set the following
environment variables on your CI:

You could use either username with password or OAuth key with OAuth secret.

For username and password, you need to set.

- `DANGER_BITBUCKETCLOUD_USERNAME` = The username for the account used to comment, as shown on
  https://bitbucket.org/account/
- `DANGER_BITBUCKETCLOUD_PASSWORD` = The password for the account used to comment, you could use
  [App passwords](https://confluence.atlassian.com/bitbucket/app-passwords-828781300.html#Apppasswords-Aboutapppasswords)
  with Read Pull Requests and Read Account Permissions.

For OAuth key and OAuth secret, you can get them from.

- Open [BitBucket Cloud Website](https://bitbucket.org)
- Navigate to Settings > OAuth > Add consumer
- Put `https://bitbucket.org/site/oauth2/authorize` for `Callback URL`, and enable Read Pull requests, and Read Account
  Permission.

- `DANGER_BITBUCKETCLOUD_OAUTH_KEY` = The consumer key for the account used to comment, as show as `Key` on the website.
- `DANGER_BITBUCKETCLOUD_OAUTH_SECRET` = The consumer secret for the account used to comment, as show as `Secret` on the
  website.

Then in your Dangerfiles you will have a fully fleshed out `danger.bitbucketCloud` object to work with. For example:

```ts
if danger.bitbucketCloud.pr.title.contains("WIP") {
  warn("PR is considered WIP")
}
```

The DSL is expansive, you can see all the details inside the [Danger Swift Reference][ref], but the TLDR is:

```ts
danger.bitbucketCloud

  /** The pull request and repository metadata */
  metadata: RepoMetaData
  /** The PR metadata */
  pr: BitBucketCloudPRDSL
  /** The commits associated with the pull request */
  commits: [BitBucketCloudCommit]
  /** The comments on the pull request */
  comments: [BitBucketCloudPRComment]
  /** The activities such as OPENING, COMMENTING, CLOSING, MERGING or UPDATING a pull request */
  activities: [BitBucketCloudPRActivity]
```
