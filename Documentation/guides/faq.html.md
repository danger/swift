---
title: FAQ
subtitle: Frequently Asked Questions
layout: guide_sw
order: 3
blurb: Common questions that come up in our GitHub issues.
---

## Danger Swift takes a real long time to run

First off, make sure you have build caching turned on for:

- `./build` - for Swift PM, and compilation
- `~/.danger-swift` - for Danger Swift's Dangerfile and dependency compilation

Danger Swift has to compile code etc, which you want to be doing incrementally.

Second, getting and using plugins does more work than you'd think. There is one key reason here:

- As of Swift 4.2, including any dependency will clone every related dependency. Think of it as "I include Danger in my 
  dependency tree, and suddenly I have to clone ~12 repos (~6 unrelated to danger) on every build." 
  
  This is currently the Swift PM dependency resolver being naive, and should get fixed in the future, build caching
  will work around it.  We've got some code in Danger to try speed that up though.

## Can I use the same Dangerfile across many repos?

Ish, it's currently quite complex to set up, but work is on-going on [Danger/Peril][peril]. This is a hosted version of
Danger which does not need to run on CI. Using Peril you can use TypeScript Dangerfiles to reply to basically any GitHub 
webhook.

## I only want to run Danger for internal contributors

Let's say you run Danger on the same CI service that deploys your code. If that's open source, you don't want to be
letting anyone pull out your private env vars. The work around for this is to not simply call Danger on every test run:

```sh
'[ ! -z $DANGER_GITHUB_API_TOKEN ] && swift run danger-swift ci || echo "Skipping Danger for External Contributor"'
```

Or the same for BitBucket. This ensures that Danger only runs when you have the environment variables set up to run.
This is how Danger works for a lot of the open source mobile projects in Artsy.

## Danger is not posting to GitHub PRs, but everything looks fine?

Try logging in to the GitHub account that should be writing the messages, it's possible that your account has triggered
the bot detection algorithm. This means that messages are sent correctly, but do not show up for anyone except the
sender. This makes it more or less impossible to detect from Danger's side.

## I'm not sure what Danger is doing

If you run danger with `DEBUG="*"` prefixed, you'll get a lot of information about what's happening under the hood. E.g:

```sh
DEBUG="*" [swift run] danger-swift pr https://github.com/danger/swift/pull/95
```

or on the CI:

```sh
DEBUG="*" [swift run] danger-swift ci
```

This will print out a _lot_ of information.

## Circle CI doesn't run my build consistently

Yeah... We're struggling with that one. It's something we keep taking stabs at improving, so [keep an eye on the
issues][circle_issues]. Ideally this issue will get resolved and we'll get it [fixed for free][circle_pr].

What happens is that Circle triggers a CI build before the PR has been set up, and so Danger cannot get information
about the corresponding repo and PR. Danger on Circle with use the Circle API to try and hook itself up to the right PR,
so if you have `yarn danger ci` later on in the process, you'll have a better chance of them hooking up.

This can be worked around by sending PRs from forks.

[circle_issues]: https://github.com/danger/danger-js/search?q=circle&state=open&type=Issues&utf8=✓
[circle_pr]: https://discuss.circleci.com/t/pull-requests-not-triggering-build/1213

## I want to help influence Danger's direction

We'd recommend first becoming acquainted with the [VISION.md][] inside Danger, this is the long-term plan. Then there
are two ways to start contributing today:

- Opinions are extra welcome on issues marked as [Open For Discussion][open].

- Well defined work items like features or fixes are marked as [You Can Do This][you-can-do-this].

We keep comments in the public domain, there is a Slack, but it's very rarely used. If you're interested in joining, you
can DM [orta][].

[77]: https://github.com/danger/danger-js/issues/77
[529]: https://github.com/danger/danger-js/issues/529
[vision.md]: https://github.com/danger/swift/blob/master/VISION.md
[open]: https://github.com/danger/swift/issues?q=is%3Aissue+is%3Aopen+label%3A%22Open+for+Discussion%22
[you-can-do-this]: https://github.com/danger/swift/issues?q=is%3Aissue+is%3Aopen+label%3A%22You+Can+Do+This%22
[orta]: https://twitter.com/orta/
[peril]: https://github.com/danger/peril
