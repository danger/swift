import Foundation
import Version
import DangerShellExecutor

struct PackageGenerator {
    let packageListMaker: PackageListMaker
    
    enum Errors: Error {
        case failedToUpdatePackages(String)
    }
    
    let folder: String
    let generatedFolder: String
    private var masterPackageName: String { return "PACKAGES" }
    
    init(folder: String, generatedFolder: String) {
        self.folder = folder
        self.generatedFolder = generatedFolder
        packageListMaker = PackageListMaker(folder: folder, fileManager: .default)
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
        
        FileManager.default.createFile(atPath: generatedFolder.appendingPath("Package.swift"), contents: description.data(using: .utf8), attributes: [:])
    }
    
    func makePackageDescriptionHeader(forSwiftToolsVersion toolsVersion: Version) -> String {
        let swiftVersion = toolsVersion.description.trimmingCharacters(in: .whitespaces)
        let generationVersion = 1
        
        return "// swift-tools-version:\(swiftVersion)\n" +
        "// generation-version:\(generationVersion)"
    }
}
