import Foundation
import Version
import DangerShellExecutor

struct PackageGenerator {
    enum Errors: Error {
        case failedToUpdatePackages(String)
    }
    
    let folder: String
    let generatedFolder: String
    let packageListMaker: PackageListMaking
    let fileCreator: FileCreating
    private var masterPackageName: String { return "PACKAGES" }
    
    init(folder: String,
         generatedFolder: String,
         packageListMaker: PackageListMaking? = nil,
         fileCreator: FileCreating = FileCreator()) {
        self.folder = folder
        self.generatedFolder = generatedFolder
        self.fileCreator = fileCreator
        if let packageListMaker = packageListMaker {
            self.packageListMaker = packageListMaker
        } else {
            self.packageListMaker = PackageListMaker(folder: folder, fileManager: .default, dataReader: DataReader())
        }
    }
    
    func generateMasterPackageDescription(forSwiftToolsVersion toolsVersion: Version) throws {
        let header = makePackageDescriptionHeader(forSwiftToolsVersion: toolsVersion)
        let packages = packageListMaker.makePackageList()
        
        var description = "\(header)\n\n" +
            "import PackageDescription\n\n" +
            "let package = Package(\n" +
            "    name: \"\(masterPackageName)\",\n" +
            "    products: [.library(name: \"DangerDependencies\", type: .dynamic, targets: [\"\(masterPackageName)\"])],\n" +
        "    dependencies: [\n"
        
        for (index, package) in packages.enumerated() {
            if index > 0 {
                description += ",\n"
            }
            
            description.append("        \(package.dependencyString)")
        }
        
        description.append("\n    ],\n")
        description.append("    targets: [.target(name: \"\(masterPackageName)\", dependencies: [")
        
        if !packages.isEmpty {
            description.append("\"")
            description.append(packages.map { $0.name }.joined(separator: "\", \""))
            description.append("\"")
        }
        
        description.append("])],\n")
        
        var versionString = String(toolsVersion.major)
        
        if toolsVersion == Version(major: 4, minor: 2, patch: 0) {
            versionString.append(".\(toolsVersion.minor)")
        }
        
        description.append("    swiftLanguageVersions: [.version(\"\(versionString)\")]\n)")
        
        fileCreator.createFile(atPath: generatedFolder.appendingPath("Package.swift"), contents: description.data(using: .utf8))
    }
    
    func makePackageDescriptionHeader(forSwiftToolsVersion toolsVersion: Version) -> String {
        let swiftVersion = "\(toolsVersion.major).\(toolsVersion.minor)"
        let generationVersion = 1
        
        return "// swift-tools-version:\(swiftVersion)\n" +
        "// danger-dependency-generator-version:\(generationVersion)"
    }
}
