import Foundation
import Logger

var foundDSL = false

/// Grabs the DSL from Danger JS asynchronously, and then calls
/// the runner function.
///
/// - Parameters:
///   - logger: the normal logger implmementations
///   - runner: the func that expects the data from stdin
///
func getDSLData(logger: Logger, _ runner: @escaping  (Logger, Data) throws -> Void ) throws -> Void {

    // Send a poke to danger-js to resend the DSL, if we've somehow missed it
    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
        if foundDSL { return }

        logger.debug("Asking for the DSL as it's been 1s and Danger Swift hasn't seen it yet in the stdin")

        let standardOutput = FileHandle.standardOutput
        standardOutput.write("danger://send-dsl\n".data(using: .ascii)!)
    }

    // When the global STDIN
    NotificationCenter.default.addObserver(forName: NSNotification.Name.NSFileHandleReadToEndOfFileCompletion, object: nil, queue: nil) { notification in

        // The notification contains the full STDIN which is the DSL
        foundDSL = true
        let data = notification.userInfo![NSFileHandleNotificationDataItem] as! Data

        logger.debug("Got the DSL from stdin:")
        logger.debug(String(data: data as Data, encoding: .utf8)!)

        // All data grabbed
        CFRunLoopStop(CFRunLoopGetCurrent());
        try! runner(logger, data)
    }

    // Start async listening to the STDIN
    logger.debug("Listening for the DSL via stdin")
    FileHandle.standardInput.readToEndOfFileInBackgroundAndNotify()

    // Start up a runloop to listen for the STDIN in background
    RunLoop.current.run()
}
