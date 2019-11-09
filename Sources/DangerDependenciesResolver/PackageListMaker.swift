import Foundation

protocol PackageListMaking {
    func makePackageList() -> [Package]
}

struct PackageListMaker: PackageListMaking {
    let folder: String
    let fileManager: FileManager
    let dataReader: DataReading
    
    func makePackageList() -> [Package] {
        return files(onFolder: folder).compactMap {
            try? dataReader.readData(atPath: $0).decoded()
        }
    }
    
    private func files(onFolder folder: String) -> [String] {
        return (try? fileManager.contentsOfDirectory(atPath: folder).sorted().map(folder.appendingPath)) ?? []
    }
}
