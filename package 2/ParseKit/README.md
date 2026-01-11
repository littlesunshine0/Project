# ParseKit

Universal File Parsing System for Swift projects.

## Features

- **Universal Parsing** - Parse any file type automatically
- **Type Detection** - Automatic file type detection
- **Symbol Extraction** - Extract code symbols from source files
- **Metadata Extraction** - Extract metadata from plists, JSON, YAML

## Supported File Types

- Swift, Python, Ruby, JavaScript
- JSON, YAML, XML, Plist
- Markdown, HTML
- Xcode projects, Swift packages
- Frameworks, bundles, app bundles

## Usage

```swift
import ParseKit

// Parse any file
let parsed = try await ParseKit.parse(path: "/path/to/file.swift")
print(parsed.type)      // .swift
print(parsed.symbols)   // Extracted symbols
print(parsed.metadata)  // File metadata

// Detect file type
let type = ParseKit.detectType(path: "/path/to/Package.swift")
// Returns: .swiftPackage

// Parse content directly
let result = try await ParseKit.parse(content: jsonString, as: .json)
```

## Components

- `UniversalParser` - Main parsing engine (actor)
- `ParsedFile` - Parsed file result
- `ParsedSymbol` - Extracted code symbol
- `FileStructure` - Directory structure info

## Tests

6 tests covering file type detection and parsing.
