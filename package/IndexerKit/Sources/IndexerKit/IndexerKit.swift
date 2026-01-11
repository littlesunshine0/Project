//
//  IndexerKit.swift
//  IndexerKit
//
//  Code and document indexing, asset scanning
//

import Foundation

public struct IndexerKit {
    public static let version = "1.0.0"
    public static let identifier = "com.flowkit.indexerkit"
    public init() {}
}

// MARK: - Code Indexer

public actor CodeIndexer {
    public static let shared = CodeIndexer()
    
    private var fileIndex: [String: IndexedFile] = [:]
    private var symbolIndex: [String: Set<String>] = [:]  // symbol -> file paths
    private var importIndex: [String: Set<String>] = [:]  // import -> file paths
    
    private init() {}
    
    public func index(file path: String, content: String, language: String) -> IndexedFile {
        let symbols = extractSymbols(content, language: language)
        let imports = extractImports(content, language: language)
        
        let indexed = IndexedFile(
            path: path,
            language: language,
            symbols: symbols,
            imports: imports,
            lineCount: content.components(separatedBy: .newlines).count,
            size: content.utf8.count
        )
        
        fileIndex[path] = indexed
        
        // Update symbol index
        for symbol in symbols {
            symbolIndex[symbol.name, default: []].insert(path)
        }
        
        // Update import index
        for imp in imports {
            importIndex[imp, default: []].insert(path)
        }
        
        return indexed
    }
    
    public func findSymbol(_ name: String) -> [String] {
        Array(symbolIndex[name] ?? [])
    }
    
    public func findImport(_ module: String) -> [String] {
        Array(importIndex[module] ?? [])
    }
    
    public func getFile(_ path: String) -> IndexedFile? { fileIndex[path] }
    
    public func getAllFiles() -> [IndexedFile] { Array(fileIndex.values) }
    
    public func removeFile(_ path: String) {
        guard let file = fileIndex.removeValue(forKey: path) else { return }
        for symbol in file.symbols { symbolIndex[symbol.name]?.remove(path) }
        for imp in file.imports { importIndex[imp]?.remove(path) }
    }
    
    private func extractSymbols(_ content: String, language: String) -> [IndexedSymbol] {
        var symbols: [IndexedSymbol] = []
        let lines = content.components(separatedBy: .newlines)
        
        for (index, line) in lines.enumerated() {
            let trimmed = line.trimmingCharacters(in: .whitespaces)
            
            if trimmed.hasPrefix("func ") || trimmed.hasPrefix("public func ") || trimmed.hasPrefix("private func ") {
                let name = extractName(from: trimmed, after: "func ")
                symbols.append(IndexedSymbol(name: name, kind: .function, line: index + 1))
            } else if trimmed.hasPrefix("class ") || trimmed.hasPrefix("public class ") {
                let name = extractName(from: trimmed, after: "class ")
                symbols.append(IndexedSymbol(name: name, kind: .class, line: index + 1))
            } else if trimmed.hasPrefix("struct ") || trimmed.hasPrefix("public struct ") {
                let name = extractName(from: trimmed, after: "struct ")
                symbols.append(IndexedSymbol(name: name, kind: .struct, line: index + 1))
            } else if trimmed.hasPrefix("enum ") || trimmed.hasPrefix("public enum ") {
                let name = extractName(from: trimmed, after: "enum ")
                symbols.append(IndexedSymbol(name: name, kind: .enum, line: index + 1))
            }
        }
        
        return symbols
    }
    
    private func extractName(from line: String, after keyword: String) -> String {
        guard let range = line.range(of: keyword) else { return "unknown" }
        let after = String(line[range.upperBound...])
        return after.components(separatedBy: CharacterSet.alphanumerics.inverted).first ?? "unknown"
    }
    
    private func extractImports(_ content: String, language: String) -> [String] {
        var imports: [String] = []
        let lines = content.components(separatedBy: .newlines)
        
        for line in lines {
            let trimmed = line.trimmingCharacters(in: .whitespaces)
            if trimmed.hasPrefix("import ") {
                let module = trimmed.replacingOccurrences(of: "import ", with: "").trimmingCharacters(in: .whitespaces)
                imports.append(module)
            }
        }
        
        return imports
    }
    
    public var stats: IndexerStats {
        IndexerStats(
            fileCount: fileIndex.count,
            symbolCount: symbolIndex.count,
            importCount: importIndex.count,
            totalLines: fileIndex.values.reduce(0) { $0 + $1.lineCount }
        )
    }
}

// MARK: - Document Indexer

public actor DocumentIndexer {
    public static let shared = DocumentIndexer()
    
    private var documents: [String: IndexedDocument] = [:]
    private var wordIndex: [String: Set<String>] = [:]
    private var tagIndex: [String: Set<String>] = [:]
    
    private init() {}
    
    public func index(document path: String, content: String, title: String, tags: [String] = []) -> IndexedDocument {
        let words = tokenize(content)
        let wordCount = words.count
        
        let indexed = IndexedDocument(
            path: path,
            title: title,
            tags: tags,
            wordCount: wordCount,
            preview: String(content.prefix(200))
        )
        
        documents[path] = indexed
        
        // Word index
        for word in Set(words) {
            wordIndex[word, default: []].insert(path)
        }
        
        // Tag index
        for tag in tags {
            tagIndex[tag.lowercased(), default: []].insert(path)
        }
        
        return indexed
    }
    
    public func search(_ query: String) -> [IndexedDocument] {
        let words = tokenize(query)
        var matchingPaths: Set<String>?
        
        for word in words {
            if let paths = wordIndex[word] {
                matchingPaths = matchingPaths == nil ? paths : matchingPaths?.intersection(paths)
            }
        }
        
        return (matchingPaths ?? []).compactMap { documents[$0] }
    }
    
    public func findByTag(_ tag: String) -> [IndexedDocument] {
        (tagIndex[tag.lowercased()] ?? []).compactMap { documents[$0] }
    }
    
    public func getDocument(_ path: String) -> IndexedDocument? { documents[path] }
    
    private func tokenize(_ text: String) -> [String] {
        text.lowercased().components(separatedBy: CharacterSet.alphanumerics.inverted).filter { $0.count > 2 }
    }
    
    public var stats: DocumentIndexerStats {
        DocumentIndexerStats(
            documentCount: documents.count,
            uniqueWords: wordIndex.count,
            tagCount: tagIndex.count
        )
    }
}

// MARK: - Asset Scanner

public actor AssetScanner {
    public static let shared = AssetScanner()
    
    private var assets: [String: ScannedAsset] = [:]
    private var typeIndex: [AssetType: Set<String>] = [:]
    
    private init() {}
    
    public func scan(path: String, type: AssetType, size: Int64, metadata: [String: String] = [:]) -> ScannedAsset {
        let asset = ScannedAsset(path: path, type: type, size: size, metadata: metadata)
        assets[path] = asset
        typeIndex[type, default: []].insert(path)
        return asset
    }
    
    public func getAsset(_ path: String) -> ScannedAsset? { assets[path] }
    
    public func getByType(_ type: AssetType) -> [ScannedAsset] {
        (typeIndex[type] ?? []).compactMap { assets[$0] }
    }
    
    public func getAllAssets() -> [ScannedAsset] { Array(assets.values) }
    
    public var stats: AssetScannerStats {
        AssetScannerStats(
            totalAssets: assets.count,
            totalSize: assets.values.reduce(0) { $0 + $1.size },
            typeBreakdown: Dictionary(uniqueKeysWithValues: typeIndex.map { ($0.key, $0.value.count) })
        )
    }
}

// MARK: - Models

public struct IndexedFile: Sendable {
    public let path: String
    public let language: String
    public let symbols: [IndexedSymbol]
    public let imports: [String]
    public let lineCount: Int
    public let size: Int
    public let indexedAt: Date
    
    public init(path: String, language: String, symbols: [IndexedSymbol], imports: [String], lineCount: Int, size: Int, indexedAt: Date = Date()) {
        self.path = path
        self.language = language
        self.symbols = symbols
        self.imports = imports
        self.lineCount = lineCount
        self.size = size
        self.indexedAt = indexedAt
    }
}

public struct IndexedSymbol: Sendable {
    public let name: String
    public let kind: SymbolKind
    public let line: Int
}

public enum SymbolKind: String, Sendable, CaseIterable {
    case function, `class`, `struct`, `enum`, variable, constant, property, method
}

public struct IndexedDocument: Sendable {
    public let path: String
    public let title: String
    public let tags: [String]
    public let wordCount: Int
    public let preview: String
    public let indexedAt: Date
    
    public init(path: String, title: String, tags: [String], wordCount: Int, preview: String, indexedAt: Date = Date()) {
        self.path = path
        self.title = title
        self.tags = tags
        self.wordCount = wordCount
        self.preview = preview
        self.indexedAt = indexedAt
    }
}

public struct ScannedAsset: Sendable {
    public let path: String
    public let type: AssetType
    public let size: Int64
    public let metadata: [String: String]
    public let scannedAt: Date
    
    public init(path: String, type: AssetType, size: Int64, metadata: [String: String] = [:], scannedAt: Date = Date()) {
        self.path = path
        self.type = type
        self.size = size
        self.metadata = metadata
        self.scannedAt = scannedAt
    }
}

public enum AssetType: String, Sendable, CaseIterable {
    case image, video, audio, document, font, data, archive, other
}

public struct IndexerStats: Sendable {
    public let fileCount: Int
    public let symbolCount: Int
    public let importCount: Int
    public let totalLines: Int
}

public struct DocumentIndexerStats: Sendable {
    public let documentCount: Int
    public let uniqueWords: Int
    public let tagCount: Int
}

public struct AssetScannerStats: Sendable {
    public let totalAssets: Int
    public let totalSize: Int64
    public let typeBreakdown: [AssetType: Int]
}
