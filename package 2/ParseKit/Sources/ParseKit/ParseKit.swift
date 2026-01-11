//
//  ParseKit.swift
//  ParseKit
//
//  Universal File Parsing System
//

import Foundation

/// ParseKit - Universal File Parsing System
public struct ParseKit {
    public static let version = "1.0.0"
    public static let identifier = "com.flowkit.parsekit"
    
    public init() {}
    
    /// Parse any file by path
    public static func parse(path: String) async throws -> ParsedFile {
        try await UniversalParser.shared.parse(path: path)
    }
    
    /// Detect file type from path
    public static func detectType(path: String) -> FileType {
        UniversalParser.shared.detectType(url: URL(fileURLWithPath: path))
    }
    
    /// Parse content with explicit type
    public static func parse(content: String, as type: FileType) async throws -> ParsedFile {
        try await UniversalParser.shared.parse(content: content, as: type)
    }
}

// MARK: - File Type

public enum FileType: String, CaseIterable, Sendable {
    case plist, framework, bundle, xcconfig, xcodeproj, xcworkspace, swiftPackage
    case appBundle, plugin, swift, python, ruby, shell, markdown, yaml, json, xml, html, css, javascript, unknown
    
    public var displayName: String { rawValue.capitalized }
}

// MARK: - Parsed File

public struct ParsedFile: Sendable {
    public let type: FileType
    public let path: String
    public let metadata: [String: String]
    public let content: String?
    public let structure: FileStructure?
    public let symbols: [ParsedSymbol]
    
    public init(type: FileType, path: String, metadata: [String: String] = [:], content: String? = nil, structure: FileStructure? = nil, symbols: [ParsedSymbol] = []) {
        self.type = type
        self.path = path
        self.metadata = metadata
        self.content = content
        self.structure = structure
        self.symbols = symbols
    }
}

public struct FileStructure: Sendable {
    public let entries: [FileEntry]
    public let totalSize: Int64
    public let fileCount: Int
    
    public init(entries: [FileEntry], totalSize: Int64, fileCount: Int) {
        self.entries = entries
        self.totalSize = totalSize
        self.fileCount = fileCount
    }
}

public struct FileEntry: Sendable {
    public let name: String
    public let path: String
    public let entryType: EntryType
    public let size: Int64
    
    public enum EntryType: String, Sendable { case file, directory, executable, resource, header, library }
    
    public init(name: String, path: String, entryType: EntryType, size: Int64) {
        self.name = name
        self.path = path
        self.entryType = entryType
        self.size = size
    }
}

public struct ParsedSymbol: Identifiable, Sendable {
    public let id: UUID
    public let name: String
    public let type: String
    public let line: Int
    public let signature: String
    
    public init(id: UUID = UUID(), name: String, type: String, line: Int = 0, signature: String = "") {
        self.id = id
        self.name = name
        self.type = type
        self.line = line
        self.signature = signature
    }
}

// MARK: - Universal Parser

public actor UniversalParser {
    public static let shared = UniversalParser()
    
    private init() {}
    
    public func parse(path: String) async throws -> ParsedFile {
        let url = URL(fileURLWithPath: path)
        let type = detectType(url: url)
        
        switch type {
        case .plist: return try parsePlist(at: url)
        case .json: return try parseJSON(at: url)
        case .yaml: return try parseYAML(at: url)
        case .swift, .python, .ruby, .javascript: return try parseSource(at: url, type: type)
        case .markdown: return try parseMarkdown(at: url)
        case .swiftPackage: return try parseSwiftPackage(at: url)
        case .xcodeproj: return try parseXcodeProject(at: url)
        default: return try parseGeneric(at: url, type: type)
        }
    }
    
    public func parse(content: String, as type: FileType) async throws -> ParsedFile {
        ParsedFile(type: type, path: "", content: content)
    }
    
    public nonisolated func detectType(url: URL) -> FileType {
        let ext = url.pathExtension.lowercased()
        let name = url.lastPathComponent.lowercased()
        
        if name == "package.swift" { return .swiftPackage }
        
        switch ext {
        case "plist": return .plist
        case "framework": return .framework
        case "bundle": return .bundle
        case "app": return .appBundle
        case "xcconfig": return .xcconfig
        case "xcodeproj": return .xcodeproj
        case "xcworkspace": return .xcworkspace
        case "swift": return .swift
        case "py": return .python
        case "rb": return .ruby
        case "sh", "bash", "zsh": return .shell
        case "md", "markdown": return .markdown
        case "yaml", "yml": return .yaml
        case "json": return .json
        case "xml": return .xml
        case "html", "htm": return .html
        case "css": return .css
        case "js": return .javascript
        default: return .unknown
        }
    }
    
    private func parsePlist(at url: URL) throws -> ParsedFile {
        let data = try Data(contentsOf: url)
        var format: PropertyListSerialization.PropertyListFormat = .xml
        let plist = try PropertyListSerialization.propertyList(from: data, options: [], format: &format)
        
        var metadata: [String: String] = ["format": format == .xml ? "XML" : "Binary"]
        
        if let dict = plist as? [String: Any] {
            if let bundleId = dict["CFBundleIdentifier"] as? String { metadata["bundleIdentifier"] = bundleId }
            if let version = dict["CFBundleShortVersionString"] as? String { metadata["version"] = version }
            if let name = dict["CFBundleName"] as? String { metadata["name"] = name }
        }
        
        return ParsedFile(type: .plist, path: url.path, metadata: metadata)
    }
    
    private func parseJSON(at url: URL) throws -> ParsedFile {
        let data = try Data(contentsOf: url)
        let json = try JSONSerialization.jsonObject(with: data)
        
        var metadata: [String: String] = ["fileSize": "\(data.count)"]
        if let dict = json as? [String: Any] { metadata["keyCount"] = "\(dict.keys.count)" }
        
        return ParsedFile(type: .json, path: url.path, metadata: metadata, content: String(data: data, encoding: .utf8))
    }
    
    private func parseYAML(at url: URL) throws -> ParsedFile {
        let content = try String(contentsOf: url, encoding: .utf8)
        let lines = content.components(separatedBy: .newlines)
        let keyCount = lines.filter { $0.contains(":") && !$0.hasPrefix(" ") }.count
        
        return ParsedFile(type: .yaml, path: url.path, metadata: ["keyCount": "\(keyCount)", "lineCount": "\(lines.count)"], content: content)
    }
    
    private func parseSource(at url: URL, type: FileType) throws -> ParsedFile {
        let content = try String(contentsOf: url, encoding: .utf8)
        let lines = content.components(separatedBy: .newlines)
        
        var symbols: [ParsedSymbol] = []
        var metadata: [String: String] = ["lineCount": "\(lines.count)", "characterCount": "\(content.count)"]
        
        // Extract symbols based on language
        let patterns: [(String, String)] = type == .swift ? [
            (#"(?:public\s+)?class\s+(\w+)"#, "class"),
            (#"(?:public\s+)?struct\s+(\w+)"#, "struct"),
            (#"(?:public\s+)?func\s+(\w+)"#, "function")
        ] : type == .python ? [
            (#"class\s+(\w+)"#, "class"),
            (#"def\s+(\w+)"#, "function")
        ] : []
        
        for (pattern, symbolType) in patterns {
            if let regex = try? NSRegularExpression(pattern: pattern) {
                let matches = regex.matches(in: content, range: NSRange(content.startIndex..., in: content))
                for match in matches {
                    if let range = Range(match.range(at: 1), in: content) {
                        symbols.append(ParsedSymbol(name: String(content[range]), type: symbolType))
                    }
                }
            }
        }
        
        metadata["symbolCount"] = "\(symbols.count)"
        return ParsedFile(type: type, path: url.path, metadata: metadata, content: content, symbols: symbols)
    }
    
    private func parseMarkdown(at url: URL) throws -> ParsedFile {
        let content = try String(contentsOf: url, encoding: .utf8)
        let lines = content.components(separatedBy: .newlines)
        let headings = lines.filter { $0.hasPrefix("#") }.count
        let codeBlocks = content.components(separatedBy: "```").count / 2
        
        return ParsedFile(type: .markdown, path: url.path, metadata: ["headings": "\(headings)", "codeBlocks": "\(codeBlocks)"], content: content)
    }
    
    private func parseSwiftPackage(at url: URL) throws -> ParsedFile {
        let content = try String(contentsOf: url, encoding: .utf8)
        var metadata: [String: String] = [:]
        
        // Extract name
        if let regex = try? NSRegularExpression(pattern: #"name:\s*"([^"]+)""#),
           let match = regex.firstMatch(in: content, range: NSRange(content.startIndex..., in: content)),
           let range = Range(match.range(at: 1), in: content) {
            metadata["name"] = String(content[range])
        }
        
        // Count targets
        let targetCount = content.components(separatedBy: ".target(").count - 1
        metadata["targetCount"] = "\(targetCount)"
        
        return ParsedFile(type: .swiftPackage, path: url.path, metadata: metadata, content: content)
    }
    
    private func parseXcodeProject(at url: URL) throws -> ParsedFile {
        let pbxprojPath = url.appendingPathComponent("project.pbxproj")
        guard FileManager.default.fileExists(atPath: pbxprojPath.path) else {
            return ParsedFile(type: .xcodeproj, path: url.path, metadata: ["error": "project.pbxproj not found"])
        }
        
        let content = try String(contentsOf: pbxprojPath, encoding: .utf8)
        let fileRefCount = content.components(separatedBy: "PBXFileReference").count - 1
        
        return ParsedFile(type: .xcodeproj, path: url.path, metadata: ["fileReferenceCount": "\(fileRefCount)"])
    }
    
    private func parseGeneric(at url: URL, type: FileType) throws -> ParsedFile {
        let attrs = try FileManager.default.attributesOfItem(atPath: url.path)
        let size = attrs[.size] as? Int64 ?? 0
        
        return ParsedFile(type: type, path: url.path, metadata: ["size": "\(size)"])
    }
}
