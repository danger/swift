@testable import DangerDependenciesResolver
import Foundation

final class StubbedDataReader: FileReading {
    var stubbedReadData: ((String) throws -> Data)!
    var stubbedReadText: ((String) throws -> String)!

    init(stubbedReadData: ((String) -> Data)? = nil, stubbedReadText: ((String) -> String)? = nil) {
        self.stubbedReadData = stubbedReadData
        self.stubbedReadText = stubbedReadText
    }

    func readData(atPath path: String) throws -> Data {
        try stubbedReadData(path)
    }

    func readText(atPath path: String) throws -> String {
        try stubbedReadText(path)
    }
}
