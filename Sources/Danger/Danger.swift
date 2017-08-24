#if os(Linux)
    import Glibc
#else
    import Darwin.C
#endif

public final class Danger {
    public init() {
        dumpResultsAtExit(self, path:"somewhere")
    }


}

private func dumpResultsAtExit(_ runner: Danger, path: String) {
    func dump() {
        print("Sending results back to Danger")
    }

    atexit(dump)
}
