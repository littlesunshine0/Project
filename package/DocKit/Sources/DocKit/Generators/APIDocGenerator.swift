//
//  APIDocGenerator.swift
//  DocKit
//
//  API documentation generation from code symbols
//

import Foundation

public struct APIDocGenerator {
    
    public static func generate(from symbols: [CodeSymbol]) -> String {
        var sections: [String] = []
        
        sections.append("# API Reference")
        sections.append("")
        
        // Group by type
        let grouped = Dictionary(grouping: symbols) { $0.type }
        
        // Classes
        if let classes = grouped[.class], !classes.isEmpty {
            sections.append("## Classes")
            sections.append("")
            for symbol in classes {
                sections.append(generateSymbolDoc(symbol))
            }
        }
        
        // Structs
        if let structs = grouped[.struct], !structs.isEmpty {
            sections.append("## Structs")
            sections.append("")
            for symbol in structs {
                sections.append(generateSymbolDoc(symbol))
            }
        }
        
        // Protocols
        if let protocols = grouped[.protocol], !protocols.isEmpty {
            sections.append("## Protocols")
            sections.append("")
            for symbol in protocols {
                sections.append(generateSymbolDoc(symbol))
            }
        }
        
        // Enums
        if let enums = grouped[.enum], !enums.isEmpty {
            sections.append("## Enums")
            sections.append("")
            for symbol in enums {
                sections.append(generateSymbolDoc(symbol))
            }
        }
        
        // Functions
        if let functions = grouped[.function], !functions.isEmpty {
            sections.append("## Functions")
            sections.append("")
            for symbol in functions {
                sections.append(generateSymbolDoc(symbol))
            }
        }
        
        return sections.joined(separator: "\n")
    }
    
    private static func generateSymbolDoc(_ symbol: CodeSymbol) -> String {
        var doc: [String] = []
        
        doc.append("### `\(symbol.name)`")
        doc.append("")
        
        if !symbol.documentation.isEmpty {
            doc.append(symbol.documentation)
            doc.append("")
        }
        
        doc.append("```swift")
        doc.append(symbol.signature)
        doc.append("```")
        doc.append("")
        
        if !symbol.parameters.isEmpty {
            doc.append("**Parameters:**")
            doc.append("")
            for param in symbol.parameters {
                doc.append("- `\(param.name)`: \(param.type) - \(param.description)")
            }
            doc.append("")
        }
        
        if let returnType = symbol.returnType {
            doc.append("**Returns:** `\(returnType)`")
            doc.append("")
        }
        
        return doc.joined(separator: "\n")
    }
}
