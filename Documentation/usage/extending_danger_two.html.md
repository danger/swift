---
title: Extending Danger extended
subtitle: Plugin engineering
layout: guide_sw
order: 0
blurb: Get your plugin tested
---

### Writing Tests

Danger Swift makes it easy for you to write tests, it includes a second library for importing into your tests. This
library includes a set of functions to get a set-up version of the Danger runtime in your tests.

Edit your `Package.swift` to add a reference to the two Danger libraries:

```diff
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(
            name: "DangerNoCopyrights",
            dependencies: ["Danger"]),
        .testTarget(
            name: "DangerNoCopyrightsTests",
-           dependencies: ["DangerNoCopyrights"]),
+           dependencies: ["DangerNoCopyrights", "DangerFixtures"]),
    ]
)
```

You want to be able to inject in a different DSL to your function somehow, let's avoid exposing our testing functions to
your consumers, edit your `DangerNoCopyrights.swift`:

```diff
import Danger
import Foundation

/// Public facing
public func checkForCopyrightHeaders() -> Void {
+     let danger = Danger()
+     checkForCopyrightHeaders(danger: danger)
+ }
+
+ /// Private function for testing
+ func checkForCopyrightHeaders(danger: DangerDSL) -> Void {
    let swiftFilesWithCopyright = danger.git.createdFiles.filter {
        $0.fileType == .swift
            && danger.utils.readFile($0).contains("//  Created by")
    }

    if swiftFilesWithCopyright.count > 0 {
        let files = swiftFilesWithCopyright.joined(separator: ", ")
-        warn("Please don't include copyright headers, found them in: \(files)")
 +       danger.warn("Please don't include copyright headers, found them in: \(files)")
    }
}
```

This makes all the work happen behind the scenes, and importantly uses `danger.warn` which allows you to write tests
verifying your results:

```swift
import XCTest
@testable import DangerNoCopyrights
@testable import Danger
@testable import DangerFixtures

final class DangerNoCopyrightsTests: XCTestCase {
    func testWarnsWhenThereAreCreatedAtPrefixes() {
        // Arrange a custom Danger DSL to run against
        let danger = githubWithFilesDSL(created: ["file.swift"], fileMap: ["file.swift": "//  Created by Orta"])
        // Act against running our check
        checkForCopyrightHeaders(danger: danger)
        // Assert the number of warnings has increased
        XCTAssertEqual(globalResults.warnings.count, 1)
    }

    func testDoesNotWarnWhenNoCreatedAt() {
        let danger = githubWithFilesDSL(created: ["file.swift"], fileMap: ["file.swift": "{}"])
        checkForCopyrightHeaders(danger: danger)
        XCTAssertEqual(globalResults.warnings.count, 0)
    }

    static var allTests = [
        ("testWarnsWhenThereAreCreatedAtPrefixes", testWarnsWhenThereAreCreatedAtPrefixes),
        ("testDoesNotWarnWhenNoCreatedAt", testDoesNotWarnWhenNoCreatedAt)
    ]
}
```

There are a few fixtured sets of DSLs: `bitbucketFixtureDSL`, `githubEnterpriseFixtureDSL` and `githubFixtureDSL` in
addition to the customizable `githubWithFilesDSL`. You can reset the violations by running `resetDangerResults()`.
