import Foundation

struct PackageListMaker {
    let folder: String
    let fileManager: FileManager
    
    func makePackageList() -> [Package] {
        return files(onFolder: folder).compactMap {
            try? (String(contentsOfFile: $0).data(using: .utf8) ?? Data()).decoded()
        }
    }
    
    private func files(onFolder folder: String) -> [String] {
        return (try? fileManager.contentsOfDirectory(atPath: folder).sorted().map(folder.appendingPath)) ?? []
    }
}
