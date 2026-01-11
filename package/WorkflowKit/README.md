# WorkflowKit

A professional workflow orchestration and execution system for Swift applications.

## Overview

WorkflowKit provides a complete solution for defining, matching, and executing workflows with support for:

- **Step-based execution** with commands, prompts, conditionals, and parallel execution
- **Workflow orchestration** with pause/resume capabilities
- **Pattern extraction** from documentation
- **Error recovery** and retry logic
- **Execution history** tracking

## Installation

Add WorkflowKit to your `Package.swift`:

```swift
dependencies: [
    .package(path: "../WorkflowKit")
]
```

## Quick Start

### Creating a Workflow

```swift
import WorkflowKit

let workflow = Workflow(
    name: "Build iOS App",
    description: "Builds and tests an iOS application",
    steps: [
        .command(Command(script: "swift build", description: "Build project")),
        .command(Command(script: "swift test", description: "Run tests")),
        .prompt(Prompt(message: "Deploy to TestFlight?", inputType: .boolean))
    ],
    category: .development,
    tags: ["ios", "build", "xcode"]
)
```

### Executing a Workflow

```swift
let orchestrator = WorkflowOrchestrator()

let result = try await orchestrator.executeWorkflow(workflow)

switch result {
case .success(let results):
    print("Workflow completed with \(results.count) steps")
case .partial(let results):
    print("Workflow partially completed")
case .failure(let error):
    print("Workflow failed: \(error)")
}
```

### Extracting Workflows from Documentation

```swift
let extractor = WorkflowExtractor()

let document = StructuredDocument(
    title: "Setup Guide",
    sections: [
        DocumentSection(
            title: "Installation Steps",
            content: """
            1. Clone the repository
            2. Run `swift build`
            3. Run `swift test`
            """
        )
    ]
)

let workflows = await extractor.extract(from: document)
```

## Architecture

```
WorkflowKit/
├── Models/
│   ├── Workflow.swift          # Core workflow model
│   ├── Command.swift           # Command and prompt models
│   ├── WorkflowExecution.swift # Execution state and results
│   └── WorkflowError.swift     # Error types
├── Services/
│   ├── WorkflowOrchestrator.swift  # Execution engine
│   ├── CommandExecutor.swift       # Shell command execution
│   └── WorkflowExtractor.swift     # Documentation parsing
└── WorkflowKit.swift           # Public API
```

## Features

### Workflow Steps

- **Command**: Execute shell commands with timeout
- **Prompt**: Request user input
- **Conditional**: Branch based on conditions
- **Parallel**: Execute steps concurrently
- **Subworkflow**: Nest workflows

### Workflow Categories

WorkflowKit supports 22+ categories including:
- Development, Testing, Deployment
- Documentation, Build, Git
- API, Database, Security
- Performance, AI/ML, and more

## License

MIT License
