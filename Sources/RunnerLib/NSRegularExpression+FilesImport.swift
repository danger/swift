//
//  NSRegularExpression+FilesImport.swift
//  Danger
//
//  Created by Franco Meloni on 01/11/2018.
//

import Foundation

extension NSRegularExpression {
    private static let fileImportPattern = "\\/\\/[\\ ]?fileImport:\\ (.*)"

    static let filesImportRegex = try! NSRegularExpression(pattern: fileImportPattern, options: .allowCommentsAndWhitespace)
}
