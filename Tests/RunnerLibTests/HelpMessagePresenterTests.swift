import Logger
import RunnerLib
import XCTest

final class HelpMessagePresenterTests: XCTestCase {
    func testIsShowsTheCommandListWhenThereIsNoCommand() {
        let spyPrinter = SpyPrinter()
        HelpMessagePresenter.showHelpMessage(command: nil, logger: Logger(isVerbose: false, isSilent: false, printer: spyPrinter))

        XCTAssert(spyPrinter.printedMessages.contains(DangerCommand.commandsListText))
    }
}

private final class SpyPrinter: Printing {
    private(set) var printedMessages: [String] = []

    func print(_ message: String, terminator _: String) {
        printedMessages.append(message)
    }
}
