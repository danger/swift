<!--

// Please add your own contribution below inside the Master section, no need to 
// set a version number, that happens during a deploy.
//
// These docs are aimed at users rather than danger developers, so please limit technical
// terminology in here.

-->

## Master

## 0.3.3

* Fixes for the CLI arg order from danger-js - sunshinejr

## 0.3.2

* Add milestone model to issue and pull request. - d-date
* Change date string type from `String` to `Date` using `iso8601` date decoding strategy. - d-date
* Adds the `Logger` struct together with the `--verbose` and `--silent` arguments - rockbruno
* Add support for GitHub's new review requests payload. - hirad

## 0.3.1

* Adds linker flag to link against Marathon dependencies. See https://github.com/JohnSundell/Marathon/pull/153. - ashfurrow

## 0.3.0

* Supports the command: `danger-swift edit` to generate an Xcodeproj which you can edit your Dangerfile in - orta
* Adds plugin infrastructure to `danger-swift` - orta

  There aren't any plugins yet, but there is infrastructure for them. By suffixing `package: [url]` to any import, you
  can directly import Swift PM package as a dependency, which is basically how plugins will work.

  So, one of these days:

  ```swift
  import SwiftLint // package: https://github.com/danger/DangerSwiftLint.git

  SwiftLint.lint(danger)
  ```

## 0.2.0

* Support the beta formatting of the JSON DSL ( it now is `{ "danger": { [DSL] }}`, instead of a root element) - orta

## 0.1.1

* Fix install paths for libDanger when using homebrew - orta

## 0.1.0

* First release via homebrew - eneko

## 0.0.2

* Supports a Dangerfile in both: "/Dangerfile.swift", "/danger/Dangerfile.swift" or "/Danger/Dangerfile.swift" to handle
  SPM rules on Swift files in the root - orta
* Adds a CHANGELOG, renames project to danger-swift - orta

## 0.0.1

* Initialish versions - orta, SD10
