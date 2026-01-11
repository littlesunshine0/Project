//
//  SyntaxKit.swift
//  SyntaxKit - Syntax Highlighting & Code Analysis
//

import Foundation

// MARK: - Token

public struct Token: Identifiable, Sendable {
    public let id: String
    public let type: TokenType
    public let value: String
    public let range: Range<Int>
    public let line: Int
    public let column: Int
    
    public init(type: TokenType, value: String, range: Range<Int>, line: Int, column: Int) {
        self.id = UUID().uuidString
        self.type = type
        self.value = value
        self.range = range
        self.line = line
        self.column = column
    }
}

public enum TokenType: String, Sendable, CaseIterable {
    case keyword, identifier, string, number, comment
    case `operator`, punctuation, type, function, variable
    case property, parameter, label, attribute, directive
    case whitespace, newline, unknown
}

// MARK: - Language

public struct Language: Identifiable, Sendable {
    public let id: String
    public let name: String
    public let extensions: [String]
    public let keywords: Set<String>
    public let commentStart: String
    public let commentEnd: String?
    public let lineComment: String
    
    public init(id: String, name: String, extensions: [String], keywords: Set<String>,
                commentStart: String = "/*", commentEnd: String? = "*/", lineComment: String = "//") {
        self.id = id
        self.name = name
        self.extensions = extensions
        self.keywords = keywords
        self.commentStart = commentStart
        self.commentEnd = commentEnd
        self.lineComment = lineComment
    }
}

// MARK: - Highlighted Line

public struct HighlightedLine: Sendable {
    public let lineNumber: Int
    public let tokens: [Token]
    public let text: String
}

// MARK: - Syntax Highlighter

public actor SyntaxHighlighter {
    public static let shared = SyntaxHighlighter()
    
    private var languages: [String: Language] = [:]
    
    private init() {
        // Initialize default languages synchronously
        let swift = Language(
            id: "swift", name: "Swift", extensions: [".swift"],
            keywords: ["func", "var", "let", "class", "struct", "enum", "protocol", "import",
                      "if", "else", "for", "while", "return", "guard", "switch", "case",
                      "public", "private", "internal", "static", "async", "await", "actor"]
        )
        languages[swift.id] = swift
        
        let python = Language(
            id: "python", name: "Python", extensions: [".py"],
            keywords: ["def", "class", "import", "from", "if", "else", "elif", "for", "while",
                      "return", "try", "except", "with", "as", "lambda", "yield", "async", "await"],
            commentStart: "\"\"\"", commentEnd: "\"\"\"", lineComment: "#"
        )
        languages[python.id] = python
        
        let javascript = Language(
            id: "javascript", name: "JavaScript", extensions: [".js", ".jsx", ".ts", ".tsx"],
            keywords: ["function", "const", "let", "var", "class", "import", "export", "if", "else",
                      "for", "while", "return", "async", "await", "try", "catch", "throw"]
        )
        languages[javascript.id] = javascript
    }
    
    private func registerDefaultLanguagesAsync() {
        let swift = Language(
            id: "swift", name: "Swift", extensions: [".swift"],
            keywords: ["func", "var", "let", "class", "struct", "enum", "protocol", "import",
                      "if", "else", "for", "while", "return", "guard", "switch", "case",
                      "public", "private", "internal", "static", "async", "await", "actor"]
        )
        languages[swift.id] = swift
        
        let python = Language(
            id: "python", name: "Python", extensions: [".py"],
            keywords: ["def", "class", "import", "from", "if", "else", "elif", "for", "while",
                      "return", "try", "except", "with", "as", "lambda", "yield", "async", "await"],
            commentStart: "\"\"\"", commentEnd: "\"\"\"", lineComment: "#"
        )
        languages[python.id] = python
        
        let javascript = Language(
            id: "javascript", name: "JavaScript", extensions: [".js", ".jsx", ".ts", ".tsx"],
            keywords: ["function", "const", "let", "var", "class", "import", "export", "if", "else",
                      "for", "while", "return", "async", "await", "try", "catch", "throw"]
        )
        languages[javascript.id] = javascript
    }
    
    public func registerLanguage(_ language: Language) {
        languages[language.id] = language
    }
    
    public func getLanguage(_ id: String) -> Language? {
        languages[id]
    }
    
    public func detectLanguage(filename: String) -> Language? {
        let ext = "." + (filename.split(separator: ".").last.map(String.init) ?? "")
        return languages.values.first { $0.extensions.contains(ext) }
    }
    
    public func tokenize(_ code: String, language: String) -> [Token] {
        guard let lang = languages[language] else { return [] }
        
        var tokens: [Token] = []
        var line = 1
        var column = 1
        var index = 0
        
        let words = code.split(separator: " ", omittingEmptySubsequences: false)
        for word in words {
            let str = String(word)
            let type: TokenType = lang.keywords.contains(str) ? .keyword : .identifier
            let range = index..<(index + str.count)
            tokens.append(Token(type: type, value: str, range: range, line: line, column: column))
            index += str.count + 1
            column += str.count + 1
        }
        
        return tokens
    }
    
    public func highlight(_ code: String, language: String) -> [HighlightedLine] {
        let lines = code.components(separatedBy: "\n")
        return lines.enumerated().map { index, text in
            let tokens = tokenize(text, language: language)
            return HighlightedLine(lineNumber: index + 1, tokens: tokens, text: text)
        }
    }
    
    public var supportedLanguages: [Language] {
        Array(languages.values)
    }
    
    public var stats: SyntaxStats {
        SyntaxStats(languageCount: languages.count)
    }
}

public struct SyntaxStats: Sendable {
    public let languageCount: Int
}
