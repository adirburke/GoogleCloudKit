//
//  String+ext.swift
//  DiscoveryCodeGen
//
//  Created by Adir Burke on 15/1/20.
//

import Foundation


private let swiftKeywords: Set<String> = [
    "Any",
    "as",
    "associatedtype",
    "break",
    "case",
    "catch",
    "class",
    "completionHandler",
    "continue",
    "default",
    "defer",
    "deinit",
    "do",
    "else",
    "enum",
    "extension",
    "fallthrough",
    "false",
    "fileprivate",
    "for",
    "func",
    "guard",
    "if",
    "import",
    "in",
    "init",
    "inout",
    "internal",
    "is",
    "let",
    "nil",
    "open",
    "operator",
    "private",
    "protocol",
    "public",
    "repeat",
    "rethrows",
    "return",
    "Self",
    "self",
    "static",
    "struct",
    "subscript",
    "super",
    "switch",
    "throw",
    "throws",
    "true",
    "try",
    "typealias",
    "var",
    "where",
    "while",
    "channel",
    "object",
]


extension String {
    public mutating func addLine() {
        self += "\n"
    }
    
    public mutating func addLine(_ line: String) {
      self += line + "\n"
    }
    public mutating func addLine(_ line: String, with indent: Int) {
      self += String(repeating: " ", count: indent * 3) + line + "\n"
    }
    
    public func capitalized() -> String {
        return prefix(1).capitalized + dropFirst()
    }
    
    public func lowercaseFirst() -> String {
        return prefix(1).lowercased() + dropFirst()
    }
    
    public func makeSwiftSafe() -> String {
        return isSwiftKeyword || startsWithNumber
        ? "_" + self
        : self
    }

    private var isSwiftKeyword: Bool {
        return swiftKeywords.contains(self.lowercased())
    }

    private var startsWithNumber: Bool {
        guard let digitRange = rangeOfCharacter(from: .decimalDigits) else { return false }
        return digitRange.lowerBound == startIndex
    }
    
}
