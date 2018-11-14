import XCTest
@testable import Danger

final class FileTests: XCTestCase {
    
    static var allTests = [
        ("test_fileType_forHFile", test_fileType_forHFile),
        ("test_fileType_forJSON", test_fileType_forJSON),
        ("test_fileType_forM", test_fileType_forM),
        ("test_fileType_forMarkdown", test_fileType_forMarkdown),
        ("test_fileType_forMM", test_fileType_forMM),
        ("test_fileType_forPbxproj", test_fileType_forPbxproj),
        ("test_fileType_forPlist", test_fileType_forPlist),
        ("test_fileType_forStoryboard", test_fileType_forStoryboard),
        ("test_fileType_forSwift", test_fileType_forSwift),
        ("test_fileType_forXCScheme", test_fileType_forXCScheme),
        ("test_fileType_forYAML", test_fileType_forYAML),
        ("test_fileType_forYML", test_fileType_forYML),
        ("testLinuxTestSuiteIncludesAllTests", testLinuxTestSuiteIncludesAllTests)
    ]
    
    func test_fileType_forHFile() {
        let file: File = "bridging-header.h"
        let unknownFile: File = "bridging-header.hm"
        
        let expectedType: FileType = .h
        
        XCTAssertEqual(file.fileType, expectedType)
        XCTAssertNil(unknownFile.fileType)
    }
    
    func test_fileType_forJSON() {
        let file: File = "test_data.json"
        let unknownFile: File = "test_data.jsonn"
        
        let expectedType: FileType = .json
        
        XCTAssertEqual(file.fileType, expectedType)
        XCTAssertNil(unknownFile.fileType)
    }
    
    func test_fileType_forM() {
        let file: File = "ViewController.m"
        let unknownFile: File = "ViewController.mk"
        
        let expectedType: FileType = .m
        
        XCTAssertEqual(file.fileType, expectedType)
        XCTAssertNil(unknownFile.fileType)
    }

    func test_fileType_forMarkdown() {
        let file: File = "README.md"
        let unknownFile: File = "README.mda"
        
        let expectedType: FileType = .markdown
        
        XCTAssertEqual(file.fileType, expectedType)
        XCTAssertNil(unknownFile.fileType)
    }
    
    func test_fileType_forMM() {
        let file: File = "CoreLib.mm"
        let unknownFile: File = "CoreLib.mmm"
        
        let expectedType: FileType = .mm
        
        XCTAssertEqual(file.fileType, expectedType)
        XCTAssertNil(unknownFile.fileType)
    }

    func test_fileType_forPbxproj() {
        let file: File = "project.pbxproj"
        let unknownFile: File = "project.pbxproject"
        
        let expectedType: FileType = .pbxproj
        
        XCTAssertEqual(file.fileType, expectedType)
        XCTAssertNil(unknownFile.fileType)
    }
    
    func test_fileType_forPlist() {
        let file: File = "info.plist"
        let unknownFile: File = "info.plists"
        
        let expectedType: FileType = .plist
        
        XCTAssertEqual(file.fileType, expectedType)
        XCTAssertNil(unknownFile.fileType)
    }
    
    func test_fileType_forStoryboard() {
        let file: File = "ViewController.storyboard"
        let unknownFile: File = "ViewController.storyboards"
        
        let expectedType: FileType = .storyboard
        
        XCTAssertEqual(file.fileType, expectedType)
        XCTAssertNil(unknownFile.fileType)
    }
    
    func test_fileType_forSwift() {
        let file: File = "ViewController.swift"
        let unknownFile: File = "ViewController.swiftz"
        
        let expectedType: FileType = .swift
        
        XCTAssertEqual(file.fileType, expectedType)
        XCTAssertNil(unknownFile.fileType)
    }
    
    func test_fileType_forXCScheme() {
        let file: File = "project.xcscheme"
        let unknownFile: File = "project.xcschemes"
        
        let expectedType: FileType = .xcscheme
        
        XCTAssertEqual(file.fileType, expectedType)
        XCTAssertNil(unknownFile.fileType)
    }
    
    func test_fileType_forYAML() {
        let file: File = "config.yaml"
        let unknownFile: File = "config.yamll"
        
        let expectedType: FileType = .yaml
        
        XCTAssertEqual(file.fileType, expectedType)
        XCTAssertNil(unknownFile.fileType)
    }
    
    func test_fileType_forYML() {
        let file: File = ".swiftlint.yml"
        let unknownFile: File = ".swiftlint.ymll"
        
        let expectedType: FileType = .yml
        
        XCTAssertEqual(file.fileType, expectedType)
        XCTAssertNil(unknownFile.fileType)
    }
    
    func testLinuxTestSuiteIncludesAllTests() {
        #if !os(Linux)
        let thisClass = type(of: self)
        let linuxCount = thisClass.allTests.count
        let darwinCount = thisClass.defaultTestSuite.tests.count
        XCTAssertEqual(linuxCount, darwinCount, "\(darwinCount - linuxCount) tests are missing from allTests")
        #endif
    }
}
