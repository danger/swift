import Foundation

protocol FileReading {
    func readData(atPath: String) throws -> Data
    func readText(atPath: String) throws -> String
}

struct FileReader: FileReading {
    func readData(atPath path: String) throws -> Data {
        try Data(contentsOf: URL(fileURLWithPath: path))
    }

    func readText(atPath path: String) throws -> String {
        try String(contentsOfFile: path)
    }
}
