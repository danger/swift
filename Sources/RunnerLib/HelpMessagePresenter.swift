import Logger

public final class HelpMessagePresenter {
    public static func showHelpMessage(command: DangerCommand?, logger: Logger) {
        if command == nil {
            showCommandsList(logger: logger)
        }
    }

    private static func showCommandsList(logger: Logger) {
        logger.logInfo("danger-swift [command]")
        logger.logInfo("")
        logger.logInfo("Commands:")
        logger.logInfo(DangerCommand.commandsListText, separator: "", terminator: "")
    }
}
