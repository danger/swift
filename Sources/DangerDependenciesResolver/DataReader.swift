import Foundation

protocol DataReading {
    func readData(atPath: String) throws -> Data
}

struct DataReader: DataReading {
    func readData(atPath path: String) throws -> Data {
        return try Data(contentsOf: URL(fileURLWithPath: path))
    }
}
