//
//  DocumentParser.swift
//  DocKit
//
//  Universal document parsing
//

import Foundation

public struct DocumentParser {
    
    public static func parse(_ content: String, format: DocumentFormat) async throws -> StructuredDocument {
        switch format {
        case .markdown:
            return try await parseMarkdown(content)
        case .html:
            return try await parseHTML(content)
        case .openapi:
            return try await parseOpenAPI(content)
        case .yaml:
            return try await parseYAML(content)
        case .json:
            return try await parseJSON(content)
        case .swift:
            return try await parseSwift(content)
        case .plaintext:
            return StructuredDocument(sections: [DocumentSection(title: "Content", content: content)])
        }
    }
    
    // MARK: - Markdown Parser
    
    private static func parseMarkdown(_ content: String) async throws -> StructuredDocument {
        var sections: [DocumentSection] = []
        var codeExamples: [CodeExample] = []
        
        let lines = content.components(separatedBy: .newlines)
        var currentSection: (title: String, content: [String], level: Int)?
        var inCodeBlock = false
        var codeLanguage = "plaintext"
        var codeLines: [String] = []
        
        for line in lines {
            // Code block handling
            if line.trimmingCharacters(in: .whitespaces).hasPrefix("```") {
                if inCodeBlock {
                    codeExamples.append(CodeExample(language: codeLanguage, code: codeLines.joined(separator: "\n")))
                    codeLines = []
                    inCodeBlock = false
                } else {
                    inCodeBlock = true
                    codeLanguage = String(line.trimmingCharacters(in: .whitespaces).dropFirst(3)).trimmingCharacters(in: .whitespaces)
                    if codeLanguage.isEmpty { codeLanguage = "plaintext" }
                }
                continue
            }
            
            if inCodeBlock {
                codeLines.append(line)
                continue
            }
            
            // Heading detection
            if let heading = parseHeading(line) {
                if let section = currentSection {
                    sections.append(DocumentSection(title: section.title, content: section.content.joined(separator: "\n").trimmingCharacters(in: .whitespacesAndNewlines), level: section.level))
                }
                currentSection = (title: heading.title, content: [], level: heading.level)
            } else if !line.trimmingCharacters(in: .whitespaces).isEmpty {
                if currentSection != nil {
                    currentSection?.content.append(line)
                } else {
                    currentSection = (title: "Introduction", content: [line], level: 1)
                }
            }
        }
        
        if let section = currentSection {
            sections.append(DocumentSection(title: section.title, content: section.content.joined(separator: "\n").trimmingCharacters(in: .whitespacesAndNewlines), level: section.level))
        }
        
        return StructuredDocument(sections: sections, codeExamples: codeExamples)
    }
    
    private static func parseHeading(_ line: String) -> (title: String, level: Int)? {
        let trimmed = line.trimmingCharacters(in: .whitespaces)
        var level = 0
        for char in trimmed {
            if char == "#" { level += 1 } else { break }
        }
        guard level >= 1 && level <= 6 else { return nil }
        let title = String(trimmed.dropFirst(level)).trimmingCharacters(in: .whitespaces).trimmingCharacters(in: CharacterSet(charactersIn: "#"))
        guard !title.isEmpty else { return nil }
        return (title: title, level: level)
    }
    
    // MARK: - HTML Parser
    
    private static func parseHTML(_ content: String) async throws -> StructuredDocument {
        var sections: [DocumentSection] = []
        
        let headingPattern = "<h([1-6])[^>]*>([^<]+)</h[1-6]>"
        guard let regex = try? NSRegularExpression(pattern: headingPattern, options: [.caseInsensitive]) else {
            return StructuredDocument(sections: [DocumentSection(title: "Content", content: stripHTML(content))])
        }
        
        let nsString = content as NSString
        let matches = regex.matches(in: content, range: NSRange(location: 0, length: nsString.length))
        
        for (index, match) in matches.enumerated() {
            if match.numberOfRanges >= 3 {
                let level = Int(nsString.substring(with: match.range(at: 1))) ?? 1
                let title = nsString.substring(with: match.range(at: 2)).trimmingCharacters(in: .whitespacesAndNewlines)
                
                let startIndex = match.range.location + match.range.length
                let endIndex = index < matches.count - 1 ? matches[index + 1].range.location : nsString.length
                let contentRange = NSRange(location: startIndex, length: endIndex - startIndex)
                let sectionContent = stripHTML(nsString.substring(with: contentRange))
                
                sections.append(DocumentSection(title: title, content: sectionContent, level: level))
            }
        }
        
        if sections.isEmpty {
            sections.append(DocumentSection(title: "Content", content: stripHTML(content)))
        }
        
        return StructuredDocument(sections: sections)
    }
    
    private static func stripHTML(_ html: String) -> String {
        var text = html
        text = text.replacingOccurrences(of: "<script[^>]*>[\\s\\S]*?</script>", with: "", options: .regularExpression)
        text = text.replacingOccurrences(of: "<style[^>]*>[\\s\\S]*?</style>", with: "", options: .regularExpression)
        text = text.replacingOccurrences(of: "<[^>]+>", with: " ", options: .regularExpression)
        text = text.replacingOccurrences(of: "&amp;", with: "&")
        text = text.replacingOccurrences(of: "&lt;", with: "<")
        text = text.replacingOccurrences(of: "&gt;", with: ">")
        text = text.replacingOccurrences(of: "&nbsp;", with: " ")
        text = text.replacingOccurrences(of: "\\s+", with: " ", options: .regularExpression)
        return text.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    // MARK: - OpenAPI Parser
    
    private static func parseOpenAPI(_ content: String) async throws -> StructuredDocument {
        guard let data = content.data(using: .utf8),
              let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any] else {
            return try await parseYAML(content)
        }
        
        var sections: [DocumentSection] = []
        var apiRefs: [APIReference] = []
        
        if let info = json["info"] as? [String: Any] {
            let title = info["title"] as? String ?? "API"
            let description = info["description"] as? String ?? ""
            sections.append(DocumentSection(title: title, content: description, level: 1, tags: ["api", "openapi"]))
        }
        
        if let paths = json["paths"] as? [String: Any] {
            for (path, pathItem) in paths {
                guard let methods = pathItem as? [String: Any] else { continue }
                for (method, operation) in methods {
                    guard let op = operation as? [String: Any] else { continue }
                    let summary = op["summary"] as? String ?? ""
                    let description = op["description"] as? String ?? ""
                    
                    sections.append(DocumentSection(title: "\(method.uppercased()) \(path)", content: "\(summary)\n\n\(description)", level: 3, tags: ["endpoint", method]))
                    apiRefs.append(APIReference(name: "\(method.uppercased()) \(path)", type: "endpoint", description: summary))
                }
            }
        }
        
        return StructuredDocument(sections: sections, apiReferences: apiRefs)
    }
    
    // MARK: - YAML Parser
    
    private static func parseYAML(_ content: String) async throws -> StructuredDocument {
        var sections: [DocumentSection] = []
        var currentSection: (title: String, content: [String])?
        
        for line in content.components(separatedBy: .newlines) {
            if line.hasSuffix(":") && !line.hasPrefix(" ") && !line.hasPrefix("\t") {
                if let section = currentSection {
                    sections.append(DocumentSection(title: section.title, content: section.content.joined(separator: "\n")))
                }
                currentSection = (title: String(line.dropLast()), content: [])
            } else if !line.trimmingCharacters(in: .whitespaces).isEmpty {
                currentSection?.content.append(line)
            }
        }
        
        if let section = currentSection {
            sections.append(DocumentSection(title: section.title, content: section.content.joined(separator: "\n")))
        }
        
        return StructuredDocument(sections: sections)
    }
    
    // MARK: - JSON Parser
    
    private static func parseJSON(_ content: String) async throws -> StructuredDocument {
        guard let data = content.data(using: .utf8),
              let json = try? JSONSerialization.jsonObject(with: data) else {
            return StructuredDocument(sections: [DocumentSection(title: "JSON", content: content)])
        }
        
        var sections: [DocumentSection] = []
        
        if let dict = json as? [String: Any] {
            for (key, value) in dict {
                let valueStr = String(describing: value)
                sections.append(DocumentSection(title: key, content: valueStr, level: 2))
            }
        }
        
        return StructuredDocument(sections: sections)
    }
    
    // MARK: - Swift Parser
    
    private static func parseSwift(_ content: String) async throws -> StructuredDocument {
        var sections: [DocumentSection] = []
        var apiRefs: [APIReference] = []
        
        // Extract imports
        let importPattern = #"import\s+(\w+)"#
        if let regex = try? NSRegularExpression(pattern: importPattern) {
            let matches = regex.matches(in: content, range: NSRange(content.startIndex..., in: content))
            let imports = matches.compactMap { match -> String? in
                guard let range = Range(match.range(at: 1), in: content) else { return nil }
                return String(content[range])
            }
            if !imports.isEmpty {
                sections.append(DocumentSection(title: "Imports", content: imports.joined(separator: ", "), level: 2))
            }
        }
        
        // Extract types
        let typePatterns: [(String, String)] = [
            (#"(?:public\s+)?class\s+(\w+)"#, "class"),
            (#"(?:public\s+)?struct\s+(\w+)"#, "struct"),
            (#"(?:public\s+)?enum\s+(\w+)"#, "enum"),
            (#"(?:public\s+)?protocol\s+(\w+)"#, "protocol")
        ]
        
        for (pattern, type) in typePatterns {
            if let regex = try? NSRegularExpression(pattern: pattern) {
                let matches = regex.matches(in: content, range: NSRange(content.startIndex..., in: content))
                for match in matches {
                    if let range = Range(match.range(at: 1), in: content) {
                        let name = String(content[range])
                        apiRefs.append(APIReference(name: name, type: type, description: ""))
                    }
                }
            }
        }
        
        // Extract functions
        let funcPattern = #"(?:public\s+)?func\s+(\w+)\s*\(([^)]*)\)"#
        if let regex = try? NSRegularExpression(pattern: funcPattern) {
            let matches = regex.matches(in: content, range: NSRange(content.startIndex..., in: content))
            for match in matches {
                if let nameRange = Range(match.range(at: 1), in: content) {
                    let name = String(content[nameRange])
                    var params: [String] = []
                    if let paramsRange = Range(match.range(at: 2), in: content) {
                        params = String(content[paramsRange]).components(separatedBy: ",").map { $0.trimmingCharacters(in: .whitespaces) }.filter { !$0.isEmpty }
                    }
                    apiRefs.append(APIReference(name: name, type: "function", description: "", parameters: params.isEmpty ? nil : params))
                }
            }
        }
        
        if !apiRefs.isEmpty {
            sections.append(DocumentSection(title: "API", content: "\(apiRefs.count) symbols found", level: 2))
        }
        
        return StructuredDocument(sections: sections, apiReferences: apiRefs)
    }
}
