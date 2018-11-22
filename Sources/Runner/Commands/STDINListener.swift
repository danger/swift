import Foundation
import Logger

func getDSLData(logger: Logger, _ runner: @escaping (Logger, Data) throws -> Void ) throws -> Void {
    let standardInput = FileHandle.standardInput
    let standardOutput = FileHandle.standardOutput

    let group = DispatchGroup()
    group.enter()

    print("start")

    DispatchQueue.global(qos: .background).async {
        print("started")
        let input = FileHandle.standardInput
        var aStr : String!
        while true {
            let lengthDetails = input.readData(ofLength:4)
            let length = lengthDetails.withUnsafeBytes { (ptr: UnsafePointer<Int32>) -> Int32 in
                return ptr.pointee
            }
            let data = input.readData(ofLength:Int(length)) //input.availableData
            if (data.count > 0) {
                var aStr = String(data:data, encoding:String.Encoding.utf8)
                if (aStr != nil) {
                    DispatchQueue.main.async {
                        print("OK")
                    }
                }
            }
        }

    }



//
//    let timer = Timer.scheduledTimer(withTimeInterval: 42.0, repeats: false) { (timer) in
//        // do stuff 42 seconds later
//    }

    // Send a poke to danger-js to resend the DSL, if we've somehow missed it
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
        print("Asking for the DSL as it's been 0.2s and Danger Swift hasn't seen it yet in the stdin")
        standardOutput.write("danger://send-dsl".data(using: .ascii)!)
    }

    // Append to a mutabled data till the STDIN is finished
    let allData = NSMutableData(length: 0)

    NotificationCenter.default.addObserver(forName: FileHandle.readCompletionNotification, object: standardInput, queue: nil) { notification in
        print("0")
    }

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
//
//    let pipeReadHandle = standardInput.fileHandleForReading
//
//    //from documentation
//    //dup2() makes newfd (new file descriptor) be the copy of oldfd (old file descriptor), closing newfd first if necessary.
//
//    //here we are copying the STDOUT file descriptor into our output pipe's file descriptor
//    //this is so we can write the strings back to STDOUT, so it can show up on the xcode console
//    dup2(STDOUT_FILENO, outputPipe.fileHandleForWriting.fileDescriptor)
//
//    //In this case, the newFileDescriptor is the pipe's file descriptor and the old file descriptor is STDOUT_FILENO and STDERR_FILENO
//
//    dup2(inputPipe.fileHandleForWriting.fileDescriptor, STDOUT_FILENO)
//    dup2(inputPipe.fileHandleForWriting.fileDescriptor, STDERR_FILENO)

    //listen in to the readHandle notification
//    NotificationCenter.default.addObserver(self, selector: #selector(self.handlePipeNotification), name: FileHandle.readCompletionNotification, object: pipeReadHandle)

    //state that you want to be notified of any data coming across the pipe
//    pipeReadHandle.readInBackgroundAndNotify()


    // Async ask for the data
    logger.debug("Listening for the DSL via stdin")
//    standardInput.readInBackgroundAndNotify()
    let data = standardInput.readDataToEndOfFile
    print("got data")
    if(group.wait(timeout:  .now() + 5) == .timedOut) {
        print("Timed out")
    }

}
