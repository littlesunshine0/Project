# FlowKit Package Operating System

A complete package operating system where every package looks the same to the system.

## Quick Start

```swift
import DataKit
import CommandKit
import WorkflowKit
import AgentKit

// Bootstrap
await bootstrapPackageSystem()

// Register packages
await CommandKitContract.shared.register()
await WorkflowKitContract.shared.register()
await AgentKitContract.shared.register()

// Run
try await runPackageSystem()

// Check stats
let stats = await getPackageSystemStats()
print("Packages: \(stats.packageCount)")
print("Commands: \(stats.commandCount)")
print("Actions: \(stats.actionCount)")
print("Agents: \(stats.agentCount)")
print("Workflows: \(stats.workflowCount)")
```

## Package Structure

Every package follows this structure:

```
PackageKit/
├── Package.swift
├── Sources/PackageKit/
│   ├── Resources/
│   │   ├── Package.manifest.json
│   │   ├── Package.capabilities.json
│   │   ├── Package.state.json
│   │   ├── Package.actions.json
│   │   ├── Package.ui.json
│   │   ├── Package.agents.json
│   │   └── Package.workflows.json
│   ├── PackageKitContract.swift
│   ├── Models/
│   ├── Services/
│   ├── Views/
│   └── ViewModels/
└── README.md
```

## Core Components

| Component | Purpose |
|-----------|---------|
| `PackageOrchestrator` | Central coordinator, auto-wires everything |
| `UIGenerator` | Auto-generates menus, views, toolbars |
| `MLIndexer` | Indexes for search, recommendations, predictions |
| `PackageGenerator` | Creates complete packages from minimal input |
| `EventBus` | Cross-package event system |

## Gold Standard Packages

- **CommandKit**: 21 actions, 6 agents, 10 workflows, 30+ commands
- **WorkflowKit**: 16 actions, 6 agents, 3 workflows
- **AgentKit**: 20 actions, 10 agents, 12 workflows

## Creating a New Package

```swift
// Generate all files
let files = PackageTemplate.generateAllFiles(
    id: "com.flowkit.mykit",
    name: "MyKit",
    category: .utility,
    description: "My custom package",
    nodes: ["MyNode"]
)

// files.jsonFiles - all JSON content
// files.contractSwift - Swift loader code
// files.readme - README content
```

## Architecture

See [ARCHITECTURE.md](ARCHITECTURE.md) for full documentation.

## Packages (38 total)

| Category | Packages |
|----------|----------|
| Core | CoreKit, DataKit, CommandKit |
| Automation | WorkflowKit, AgentKit |
| AI | AIKit, NLUKit, ChatKit |
| UI | DesignKit, NavigationKit |
| Data | FileKit, SearchKit, KnowledgeKit |
| Content | DocKit, LearnKit |
| Integration | NetworkKit, ExportKit |
| Social | CollaborationKit, FeedbackKit |
| Analytics | AnalyticsKit |
| Utility | NotificationKit, ErrorKit |
