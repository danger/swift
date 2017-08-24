import Foundation

#if os(Linux)
    import Glibc
#else
    import Darwin.C
#endif


print("Hi Runner")
