@testable import DangerDependenciesResolver
import Foundation

struct StubbedDataReader: FileReading {
    var stubbedReadData: ((String) -> Data)!
    var stubbedReadText: ((String) -> String)!

    init(stubbedReadData: ((String) -> Data)? = nil, stubbedReadText: ((String) -> String)? = nil) {
        self.stubbedReadData = stubbedReadData
        self.stubbedReadText = stubbedReadText
    }

    func readData(atPath path: String) throws -> Data {
        return stubbedReadData(path)
    }

    func readText(atPath path: String) throws -> String {
        return stubbedReadText(path)
    }
}
