@testable import ShellRunner
import XCTest

class ShellRunnerTests: XCTestCase {
    var shell: ShellRunner!

    override func setUp() {
        super.setUp()
        shell = ShellRunner()
    }

    func testWithoutArguments() throws {
        let uptime = try shell.run("uptime")
        XCTAssertTrue(uptime.contains("load average"))
    }

    func testWithArguments() throws {
        let echo = try shell.run("echo", arguments: ["Hello world"])
        XCTAssertEqual(echo, "Hello world")
    }

    func testWithInlineArguments() throws {
        let echo = try shell.run("echo \"Hello world\"")
        XCTAssertEqual(echo, "Hello world")
    }

    func testThrowsError() {
        do {
            try shell.run("cd", arguments: ["this_directory_does_not_exist"])
            XCTFail("Expected expression to throw")
        } catch let error as ShellError {
            XCTAssertNotEqual(error.exitCode, 0)
            XCTAssertEqual(error.message, "/bin/sh: line 0: cd: this_directory_does_not_exist: No such file or directory")
            XCTAssertTrue(error.output.isEmpty)
        } catch {
            XCTFail("Invalid error type: \(error)")
        }
    }

    func testErrorDescription() {
        let error = ShellError(
            command: "fake",
            exitCode: 1337,
            message: "fake error message",
            output: "fake output"
        )

        XCTAssertEqual(
            "\(error)",
            """
            Shell command exited with failure
                Command: fake
                   Code: 1337
                Message: fake error message
                 Output: fake output
            """
        )
    }
}
