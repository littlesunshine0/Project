# IdeaKit - Project Operating System

A capability-centric project synthesis system where packages represent capabilities, not documents.

> **A project is a composition of reusable reasoning capabilities that transform intent into outcomes under constraints.**

## The 8 Universal Capabilities

Every project — regardless of domain — has these logical parts:

| # | Capability | Core Question | Artifacts |
|---|------------|---------------|-----------|
| 1 | **Intent** | Why does this project exist? | purpose.md, success_criteria.md, non_goals.md |
| 2 | **Context** | What are the constraints? | constraints.md, assumptions.md, dependencies.md |
| 3 | **Structure** | How is it organized? | architecture.md, modules.md, boundaries.md |
| 4 | **Work** | What tasks must be done? | tasks.md, milestones.md, roadmap.json |
| 5 | **Decisions** | Why these choices? | decisions.md, tradeoffs.md |
| 6 | **Risk** | What could fail? | risks.md, mitigations.md |
| 7 | **Feedback** | How do we improve? | feedback.md, lessons_learned.md |
| 8 | **Outcome** | What does success look like? | acceptance_criteria.md, validation.md |

These are **invariant across all projects**: software, research, writing, business, personal goals.

```swift
// Access universal capabilities
let capabilities = IdeaKit.universalCapabilities  // All 8 capabilities

// Execute a specific capability
let intent = IntentCapability()
try await intent.execute(graph: graph, context: context)
```

## Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│                        Project Kernel                           │
│  Orchestrates package execution and manages project lifecycle   │
└─────────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│                       Artifact Graph                            │
│  Shared communication layer - packages read/write artifacts     │
└─────────────────────────────────────────────────────────────────┘
                              │
        ┌─────────────────────┼─────────────────────┐
        ▼                     ▼                     ▼
┌───────────────┐   ┌───────────────┐   ┌───────────────┐
│ IntentPackage │ → │  SpecPackage  │ → │ArchPackage    │
│               │   │               │   │               │
│ Produces:     │   │ Produces:     │   │ Produces:     │
│ IntentArtifact│   │ Requirements  │   │ Architecture  │
│ Assumptions   │   │ Scope         │   │ Artifact      │
└───────────────┘   └───────────────┘   └───────────────┘
```

## Key Concepts

### 1. Packages as Capabilities

Each package represents a **capability**, not a document:

| Old Model (Files)    | New Model (Packages)     |
|---------------------|--------------------------|
| requirements.md     | SpecPackage              |
| architecture.md     | ArchitecturePackage      |
| tasks.md            | PlanningPackage          |
| risks.md            | RiskPackage              |

### 2. Shared Artifact Graph

Packages don't talk to each other directly. They communicate through artifacts:

```
IntentArtifact → RequirementsArtifact → ArchitectureArtifact → TaskArtifact
```

### 3. Project = Composition

A project assembles packages, not generates files:

```swift
let context = try await IdeaKit.create("MyApp", idea: "A todo app", packages: [
    IntentPackage(),
    SpecPackage(),
    CustomArchitecturePackage()  // Swap in your own!
])
```

## Kernel Packages

| Package | Purpose | Produces |
|---------|---------|----------|
| IntentPackage | Idea → Structured Intent | IntentArtifact, AssumptionArtifact |
| SpecPackage | Requirements & Scope | RequirementsArtifact, ScopeArtifact |
| ArchitecturePackage | Architecture Recommendations | ArchitectureArtifact |
| PlanningPackage | Tasks & Milestones | TaskArtifact |
| RiskPackage | Risk Analysis | RiskArtifact |
| DocsPackage | Documentation Intelligence | DocsIndex |

## Usage

### Quick Start

```swift
import IdeaKit

// Create a project with all kernel packages
let context = try await IdeaKit.create(
    "MyApp",
    idea: "A todo app for developers to track tasks and deadlines"
)

// Access artifacts
let intent: IntentArtifact? = await IdeaKit.artifactGraph.get(ofType: IntentArtifact.self)
print(intent?.problemStatement)
```


### Custom Package Selection

```swift
// Use only specific packages
let context = try await IdeaKit.create(
    "MyLibrary",
    idea: "A Swift package for parsing JSON",
    packages: [
        IntentPackage(),
        SpecPackage(),
        // Skip architecture, use custom planning
        CustomPlanningPackage()
    ]
)
```

### Creating Custom Packages

```swift
struct CustomArchitecturePackage: CapabilityPackage {
    static let packageId = "custom_architecture"
    static let name = "Custom Architecture Package"
    static let description = "My custom architecture generator"
    static let produces = ["ArchitectureArtifact"]
    static let consumes = ["IntentArtifact"]
    static let isKernel = false
    
    func execute(graph: ArtifactGraph, context: ProjectContext) async throws {
        // Read upstream artifacts
        guard let intent: IntentArtifact = await graph.get(ofType: IntentArtifact.self) else {
            throw PackageError.missingArtifact("IntentArtifact")
        }
        
        // Generate your custom architecture
        let architecture = generateCustomArchitecture(from: intent)
        
        // Register in graph
        await graph.register(architecture, producedBy: Self.packageId)
        
        // Save rendered output
        try context.save(artifact: architecture.toMarkdown(), as: "architecture.md")
    }
}
```

## File Structure

```
IdeaKit/
├── Sources/IdeaKit/
│   ├── IdeaKit.swift              # Main entry point
│   ├── Core/
│   │   ├── Artifact.swift         # Artifact protocol & types
│   │   ├── ArtifactGraph.swift    # Shared communication layer
│   │   ├── Package.swift          # Package protocol
│   │   ├── ProjectContext.swift   # Project state
│   │   ├── ProjectKernel.swift    # Orchestration
│   │   ├── ProjectTool.swift      # Legacy tool protocol
│   │   └── Artifacts.swift        # Legacy artifact types
│   ├── Packages/
│   │   ├── IntentPackage.swift
│   │   ├── SpecPackage.swift
│   │   ├── ArchitecturePackage.swift
│   │   ├── PlanningPackage.swift
│   │   ├── RiskPackage.swift
│   │   └── DocsPackage.swift
│   └── Tools/                     # Legacy tools (still available)
│       ├── ProjectIntentAnalyzer.swift
│       ├── SpecGenerator.swift
│       └── ...
└── Tests/IdeaKitTests/
    └── IdeaKitTests.swift
```

## Why This Architecture?

### Benefits

1. **Reuse across projects**: Same packages, different compositions
2. **Loose coupling**: Packages communicate through artifacts, not directly
3. **Easy swapping**: Replace `ArchitecturePackage` with `CleanArchitecturePackage`
4. **Safe experimentation**: Try new packages without breaking existing ones
5. **Versioning**: Each package versioned independently
6. **Learning**: Patterns can be recognized across projects

### The Mental Model

```
Old: "Every project generates a bunch of one-off files"
New: "Every project assembles a set of reusable logic packages"
```

Files become **outputs**, not the system.

## License

MIT
