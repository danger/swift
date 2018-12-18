---
title: Architecture
subtitle: How is Danger Swift architected
layout: guide_sw
order: 1
blurb: How do Danger Swift and JS interact?
---

## How does Danger Swift work?

Danger provides an evaluation system for creating per-application rules. Basically, it is running arbitrary Swift with
some extra PR metadata added in at runtime.

Pulling this off though, is a bit of a thing.

## Setup

Danger Swift is powered by Danger JS. Think of it as a Swift sandwich: `[Danger JS] -> [Danger Swift] -> [Danger JS]`.
Danger JS first gets all the CI and Platform metadata, then passes that to Danger Swift, which returns the results of
your Swift rules back to Danger JS.

```
+-----------------------------------+          +----------------------+          +--------------------+
|                                   |          |                      |          |                    |
| ## Danger JS                      |          | ## Danger Swift      |          | ## Danger JS       |
|                                   |          |                      |          |                    |
|  Get GitHub/BitBucket/etc Details |  +---->  |  Setup plugins       |  +---->  |  Update GitHub/etc |
|                                   |          |                      |          |                    |
|  Transform into JSON              |          |  Evaluate Dangerfile |          |                    |
|                                   |          |                      |          |                    |
+-----------------------------------+          +----------------------+          +--------------------+
```

**Step 1: CI**. Danger JS needs to figure out what CI we're running on. You can see them all [in
`source/ci_source/providers`][provs]. These use ENV VARs to figure out which CI `danger ci` is running on and validate
whether it is a pull request.

**Step 2: Platform**. Next, Danger JS needs to know which platform the code review is happening in. Today it's just
GitHub and BitBucket Server, but maybe GitLab is around the corner.

**Step 3: JSON DSL**. All the metadata from the above two steps are transformed into a JSON file, which is passed into
Danger Swift.

**Step 4: Swift Plugin Setup**. Danger has to prepare your code to be compiled, so any plugins need to be set up before
evaluation.

**Step 5: Evaluation**. Most of the Danger Swift setup occurs when you run, `let danger = Danger()` in your
`Dangerfile.swift` - it's nearly all smart JSON parsing into real Swift-y objects. The dangerfile uses `markdown`,
`warning`, `fail` or `message` to pass results to a singleton.

**Step 6: Passing Results**. The results from the evaluation are turned into JSON, and then passed back to Danger JS.

**Step 6: Feedback**. Danger JS reads the results, then chooses whether to create/delete/edit any messages in the code
review site.

[provs]: https://github.com/danger/danger-js/tree/master/source/ci_source/providers
[dangerdsl]: https://github.com/danger/danger-js/blob/master/sourformace/dsl/DangerDSL.ts
[runner]: https://github.com/danger/danger-js/blob/master/source/commands/danger-runner.ts
[in_runner]: https://github.com/danger/danger-js/blob/master/source/runner/runners/inline.ts
