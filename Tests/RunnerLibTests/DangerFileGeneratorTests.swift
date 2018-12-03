//
//  DangerFileGeneratorTests.swift
//  DangerTests
//
//  Created by Franco Meloni on 01/11/2018.
//

import Foundation
import Logger
@testable import RunnerLib
import XCTest
import SnapshotTesting

final class DangerFileGeneratorTests: XCTestCase {
    private let logger = Logger()
    private var createdFiles: [String] = []
    private var generator: DangerFileGenerator!

    private let generatedFilePath = "GeneratedTestDangerfile.swift"
    private let file1Path = "GeneratedTestFile1.swift"
    private let file2Path = "GeneratedTestFile2.swift"
    private let file3Path = "GeneratedTestFile3.swift"

    override func setUp() {
        super.setUp()
        createdFiles = [generatedFilePath]
        generator = DangerFileGenerator()
    }

    override func tearDown() {
        createdFiles.forEach { try? FileManager.default.removeItem(atPath: $0) }
        super.tearDown()
    }

    func testItGeneratesTheCorrectFileWhenThereAreNoImports() throws {
        try generator.generateDangerFile(fromContent: contentWithoutImports, fileName: generatedFilePath, logger: logger)

        XCTAssert(generatedContent == contentWithoutImports)
    }

    func testItGeneratesTheCorrectFileWhenThereIsASingleImport() throws {
        try? file1Content.write(toFile: file1Path, atomically: true, encoding: .utf8)

        createdFiles.append(file1Path)

        try generator.generateDangerFile(fromContent: contentWithOneImport, fileName: generatedFilePath, logger: logger)

        XCTAssert(generatedContent == file1Content + "\n" + contentWithoutImports)
    }

    func testItGeneratesTheCorrectFileWhenThereIsAreMultipleImports() throws {
        try? file1Content.write(toFile: file1Path, atomically: true, encoding: .utf8)
        try? file2Content.write(toFile: file2Path, atomically: true, encoding: .utf8)
        try? file3Content.write(toFile: file3Path, atomically: true, encoding: .utf8)

        createdFiles.append(file1Path)
        createdFiles.append(file2Path)
        createdFiles.append(file3Path)

        try generator.generateDangerFile(fromContent: contentWithMultipleImports, fileName: generatedFilePath, logger: logger)

        let expectedResult = file2Content + "\n\n" + file3Content + "\n" + file1Content + "\n" + contentWithoutImports


        XCTAssert(generatedContent == expectedResult)
    }

    func testItGeneratesTheCorrectFileWhenOneOfTheImportedFilesIsMissing() throws {
        try? file1Content.write(toFile: file1Path, atomically: true, encoding: .utf8)
        try? file2Content.write(toFile: file2Path, atomically: true, encoding: .utf8)

        createdFiles.append(file1Path)
        createdFiles.append(file2Path)

        try generator.generateDangerFile(fromContent: contentWithMultipleImports, fileName: generatedFilePath, logger: logger)

        let expectedResult = file2Content + "\n\n" + "// fileImport: " + file3Path + "\n" + file1Content + "\n" + contentWithoutImports
        assertSnapshot(matching: expectedResult, as: .lines)

//        XCTAssert(generatedContent == expectedResult)
    }
}

extension DangerFileGeneratorTests {
    private var contentWithoutImports: String {
        return """
        message("Text")
        message("Another Text")
        """
    }

    private var contentWithOneImport: String {
        return "// fileImport: " + file1Path + "\n" + contentWithoutImports
    }

    private var contentWithMultipleImports: String {
        return "// fileImport: " + file2Path + "\n\n" +
            "// fileImport: " + file3Path + "\n" + contentWithOneImport
    }

    private var file1Content: String {
        return """
        file1Content
        secondLine
        """
    }

    private var file2Content: String {
        return """
        file2Content
        """
    }

    private var file3Content: String {
        return """
        file3Content
        secondLine
        really really really really really really really really really really really really really really really really really really really really really really long text
        """
    }

    private var generatedContent: String {
        return try! String(contentsOfFile: generatedFilePath)
    }
}
