import Foundation
import Logger

func getDSLData(logger: Logger, _ runner: @escaping (Logger, Data) throws -> Void ) throws -> Void {
    let standardInput = FileHandle.standardInput
    let standardOutput = FileHandle.standardOutput

    let group = DispatchGroup()
    group.enter()

    print("start")

    // Send a poke to danger-js to resend the DSL, if we've somehow missed it
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
        print("OK?")
        logger.debug("Asking for the DSL as it's been 0.2s and Danger Swift hasn't seen it yet in the stdin")
        standardOutput.write("danger://send-dsl".data(using: .ascii)!)
    }


    // Append to a mutabled data till the STDIN is finished
    let allData = NSMutableData(length: 0)
    NotificationCenter.default.addObserver(forName: NSNotification.Name.NSFileHandleReadToEndOfFileCompletion, object: standardInput, queue: nil) { notification in
        print("1")
    }

    NotificationCenter.default.addObserver(forName: NSNotification.Name.NSFileHandleDataAvailable, object: standardInput, queue: nil) { notification in
        print("2")
    }

    NotificationCenter.default.addObserver(forName: NSNotification.Name.NSFileHandleConnectionAccepted, object: standardInput, queue: nil) { notification in
        print("OOKKK")
        let fh = notification.object as! FileHandle
        // Get the data from the FileHandle
        let data = fh.availableData
        // Only deal with the data if it actually exists
        if data.count > 1 {
            // Since we just got the notification from fh, we must tell it to notify us again when it gets more data
            fh.waitForDataInBackgroundAndNotify()
            // Convert the data into a string
            allData?.append(data)
        } else {
            // All data grabbed
            try! runner(logger, data)
            group.leave()
        }
    }

    // Async ask for the data
    logger.debug("Listening for the DSL via stdin")
    standardInput.readToEndOfFileInBackgroundAndNotify()
    let _ = group.wait(timeout:  .now() + 5)
}
