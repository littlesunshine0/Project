//
//  DocKit.swift
//  DocKit
//
//  Documentation Generation System
//  Generate READMEs, API docs, changelogs for any project
//

import Foundation

/// DocKit - Professional Documentation Generation System
public struct DocKit {
    public static let version = "1.0.0"
    public static let identifier = "com.flowkit.dockit"
    
    public init() {}
    
    /// Generate README for a project
    public static func generateREADME(for project: ProjectInfo) -> String {
        READMEGenerator.generate(for: project)
    }
    
    /// Generate API documentation
    public static func generateAPIDocs(from symbols: [CodeSymbol]) -> String {
        APIDocGenerator.generate(from: symbols)
    }
    
    /// Generate changelog from commits
    public static func generateChangelog(from commits: [CommitInfo]) -> String {
        ChangelogGenerator.generate(from: commits)
    }
    
    /// Parse documentation from various formats
    public static func parse(_ content: String, format: DocumentFormat) async throws -> StructuredDocument {
        try await DocumentParser.parse(content, format: format)
    }
}

// MARK: - Document Format

public enum DocumentFormat: String, CaseIterable, Codable, Sendable {
    case markdown, html, openapi, yaml, json, swift, plaintext
    
    public var icon: String {
        switch self {
        case .markdown: return "doc.richtext"
        case .html: return "chevron.left.forwardslash.chevron.right"
        case .openapi: return "network"
        case .yaml: return "doc.text"
        case .json: return "curlybraces"
        case .swift: return "swift"
        case .plaintext: return "doc"
        }
    }
    
    public var fileExtension: String {
        switch self {
        case .markdown: return "md"
        case .html: return "html"
        case .openapi: return "yaml"
        case .yaml: return "yaml"
        case .json: return "json"
        case .swift: return "swift"
        case .plaintext: return "txt"
        }
    }
}

// MARK: - Doc Category

public enum DocCategory: String, Codable, CaseIterable, Sendable {
    case readme = "README"
    case api = "API"
    case changelog = "Changelog"
    case tutorial = "Tutorial"
    case reference = "Reference"
    case spec = "Specification"
    case guide = "Guide"
    case architecture = "Architecture"
    
    public var icon: String {
        switch self {
        case .readme: return "doc.text"
        case .api: return "network"
        case .changelog: return "clock.arrow.circlepath"
        case .tutorial: return "book"
        case .reference: return "books.vertical"
        case .spec: return "doc.badge.gearshape"
        case .guide: return "map"
        case .architecture: return "building.2"
        }
    }
}

// MARK: - Doc Section

public enum DocSection: String, CaseIterable, Sendable {
    case all = "All Documents"
    case recent = "Recent"
    case search = "Search"
    case templates = "Templates"
    case generated = "Generated"
    
    public var icon: String {
        switch self {
        case .all: return "doc.on.doc"
        case .recent: return "clock"
        case .search: return "magnifyingglass"
        case .templates: return "doc.badge.plus"
        case .generated: return "wand.and.stars"
        }
    }
}

// MARK: - Project Info

public struct ProjectInfo: Sendable {
    public let name: String
    public let description: String
    public let version: String
    public let author: String?
    public let license: String?
    public let features: [String]
    public let installation: String?
    public let usage: String?
    public let dependencies: [String]
    
    public init(name: String, description: String, version: String = "1.0.0", author: String? = nil, license: String? = nil, features: [String] = [], installation: String? = nil, usage: String? = nil, dependencies: [String] = []) {
        self.name = name
        self.description = description
        self.version = version
        self.author = author
        self.license = license
        self.features = features
        self.installation = installation
        self.usage = usage
        self.dependencies = dependencies
    }
}

// MARK: - Code Symbol

public struct CodeSymbol: Identifiable, Sendable {
    public let id: UUID
    public let name: String
    public let type: SymbolType
    public let signature: String
    public let documentation: String
    public let parameters: [ParameterInfo]
    public let returnType: String?
    public let accessLevel: String
    
    public init(id: UUID = UUID(), name: String, type: SymbolType, signature: String, documentation: String = "", parameters: [ParameterInfo] = [], returnType: String? = nil, accessLevel: String = "public") {
        self.id = id
        self.name = name
        self.type = type
        self.signature = signature
        self.documentation = documentation
        self.parameters = parameters
        self.returnType = returnType
        self.accessLevel = accessLevel
    }
    
    public enum SymbolType: String, Sendable {
        case `class`, `struct`, `enum`, `protocol`, function, property, `typealias`
    }
    
    public struct ParameterInfo: Sendable {
        public let name: String
        public let type: String
        public let description: String
        
        public init(name: String, type: String, description: String = "") {
            self.name = name
            self.type = type
            self.description = description
        }
    }
}

// MARK: - Commit Info

public struct CommitInfo: Sendable {
    public let hash: String
    public let message: String
    public let author: String
    public let date: Date
    public let type: CommitType
    
    public init(hash: String, message: String, author: String, date: Date, type: CommitType = .other) {
        self.hash = hash
        self.message = message
        self.author = author
        self.date = date
        self.type = type
    }
    
    public enum CommitType: String, CaseIterable, Sendable {
        case feature, fix, docs, style, refactor, test, chore, breaking, other
        
        public static func from(_ message: String) -> CommitType {
            let lower = message.lowercased()
            if lower.hasPrefix("feat") { return .feature }
            if lower.hasPrefix("fix") { return .fix }
            if lower.hasPrefix("docs") { return .docs }
            if lower.hasPrefix("style") { return .style }
            if lower.hasPrefix("refactor") { return .refactor }
            if lower.hasPrefix("test") { return .test }
            if lower.hasPrefix("chore") { return .chore }
            if lower.contains("breaking") { return .breaking }
            return .other
        }
    }
}

// MARK: - Structured Document

public struct StructuredDocument: Sendable {
    public let sections: [DocumentSection]
    public let codeExamples: [CodeExample]
    public let apiReferences: [APIReference]
    
    public init(sections: [DocumentSection] = [], codeExamples: [CodeExample] = [], apiReferences: [APIReference] = []) {
        self.sections = sections
        self.codeExamples = codeExamples
        self.apiReferences = apiReferences
    }
}

public struct DocumentSection: Codable, Sendable {
    public let title: String
    public let content: String
    public let level: Int
    public let tags: [String]?
    
    public init(title: String, content: String, level: Int = 1, tags: [String]? = nil) {
        self.title = title
        self.content = content
        self.level = level
        self.tags = tags
    }
}

public struct CodeExample: Sendable {
    public let language: String
    public let code: String
    public let description: String?
    
    public init(language: String, code: String, description: String? = nil) {
        self.language = language
        self.code = code
        self.description = description
    }
}

public struct APIReference: Sendable {
    public let name: String
    public let type: String
    public let description: String
    public let parameters: [String]?
    
    public init(name: String, type: String, description: String, parameters: [String]? = nil) {
        self.name = name
        self.type = type
        self.description = description
        self.parameters = parameters
    }
}
