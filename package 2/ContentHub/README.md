# ContentHub

Centralized Content Storage & Cross-Project Sharing System.

## Purpose

ContentHub provides a unified storage system for all generated documentation and configuration across multiple projects. It enables:

1. **Centralized Storage** - All projects store content in one location
2. **Cross-Project Search** - Search documentation across all projects
3. **ML Training Data** - Export content for machine learning
4. **Automatic Generation** - Content generated when packages are attached

## Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                      ContentHub                              │
│  ┌─────────────────────────────────────────────────────┐   │
│  │                   ContentStore                        │   │
│  │  ┌─────────┐  ┌─────────┐  ┌─────────┐             │   │
│  │  │Project A│  │Project B│  │Project C│  ...        │   │
│  │  └────┬────┘  └────┬────┘  └────┬────┘             │   │
│  │       │            │            │                    │   │
│  │  ┌────▼────────────▼────────────▼────┐             │   │
│  │  │         Unified Index              │             │   │
│  │  │  • Type Index                      │             │   │
│  │  │  • Tag Index                       │             │   │
│  │  │  • Project Index                   │             │   │
│  │  └───────────────────────────────────┘             │   │
│  └─────────────────────────────────────────────────────┘   │
│                           │                                  │
│  ┌────────────────────────▼────────────────────────────┐   │
│  │                    Outputs                           │   │
│  │  • Search Results    • ML Training Data             │   │
│  │  • Project Content   • Statistics                   │   │
│  └─────────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────────┘
```

## Content Types

### Documentation
- `readme` - README files
- `design` - Design documents
- `requirements` - Requirements specs
- `tasks` - Task lists
- `specs` - Technical specifications
- `changelog` - Version history
- `api` - API documentation

### Configuration
- `commands` - Command definitions (JSON)
- `workflows` - Workflow definitions (JSON)
- `actions` - Action definitions (JSON)
- `scripts` - Script definitions (JSON)
- `agents` - Agent definitions (JSON)

### Architecture
- `blueprint` - Architecture blueprints
- `dataModel` - Data model documentation
- `integration` - Integration specs

### Planning
- `roadmap` - Product roadmaps
- `milestone` - Milestone documentation
- `useCase` - Use case documentation

## Usage

```swift
import ContentHub

// Store content from a project
let content = GeneratedContent(
    projectId: "my-project",
    projectName: "MyApp",
    type: .readme,
    title: "README",
    content: "# MyApp\n\nAn awesome app.",
    generatedBy: "DocKit"
)
try await ContentHub.store(content)

// Search across all projects
let results = await ContentHub.search("authentication")
for result in results {
    print("\(result.content.projectName): \(result.content.title)")
}

// Get all content for a project
let projectContent = await ContentHub.getProjectContent(projectId: "my-project")

// Get ML training data
let trainingData = await ContentHub.getMLTrainingData(type: .readme)

// Register a project for auto-generation
let registration = ProjectRegistration(
    projectId: "my-project",
    projectName: "MyApp",
    projectPath: "/path/to/project",
    attachedKits: ["DocKit", "SearchKit"]
)
await ContentHub.registerProject(registration)

// Get hub statistics
let stats = await ContentHub.getStats()
print("Total content: \(stats.totalContent)")
print("Total projects: \(stats.totalProjects)")
```

## Storage Location

Content is stored at:
```
~/Library/Application Support/FlowKit/ContentHub/
├── content.json      # All generated content
└── projects.json     # Registered projects
```

## Integration with DocKit

ContentHub works seamlessly with DocKit's AutoDocEngine:

```swift
import DocKit
import ContentHub

// Generate all docs for a project
let project = ProjectContext(name: "MyApp", description: "An awesome app")
let report = await AutoDocEngine.shared.generateAll(for: project)

// Store each generated file in ContentHub
for file in report.generatedFiles {
    let content = GeneratedContent(
        projectId: project.id,
        projectName: project.name,
        type: mapFileType(file.type),
        title: file.fileName,
        content: file.content,
        generatedBy: "DocKit"
    )
    try await ContentHub.store(content)
}
```

## Tests

10 tests covering content types, storage, and search.
