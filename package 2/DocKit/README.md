# DocKit

Professional Documentation Generation System for Swift projects.

## Features

- **README Generation** - Auto-generate comprehensive README files
- **API Documentation** - Generate API docs from code symbols
- **Changelog Generation** - Create changelogs from commit history
- **Document Parsing** - Parse markdown, HTML, OpenAPI, YAML, JSON

## Usage

```swift
import DocKit

// Generate README
let project = ProjectInfo(
    name: "MyApp",
    description: "An awesome app",
    version: "1.0.0",
    features: ["Feature 1", "Feature 2"]
)
let readme = DocKit.generateREADME(for: project)

// Generate API docs
let symbols = [CodeSymbol(name: "MyClass", type: .class, signature: "class MyClass")]
let apiDocs = DocKit.generateAPIDocs(from: symbols)

// Generate changelog
let commits = [CommitInfo(hash: "abc123", message: "feat: Add feature", author: "dev", date: Date())]
let changelog = DocKit.generateChangelog(from: commits)

// Parse documents
let doc = try await DocKit.parse(markdownContent, format: .markdown)
```

## Components

- `READMEGenerator` - README file generation
- `APIDocGenerator` - API documentation generation
- `ChangelogGenerator` - Changelog generation from commits
- `DocumentParser` - Multi-format document parsing

## Tests

8 tests covering all major functionality.
