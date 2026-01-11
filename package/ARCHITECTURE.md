# FlowKit Package Operating System

## Core Insight

**Every package looks the same to the system, even if it behaves differently internally.**

This means:
- Same file contracts
- Same capability declarations
- Same automation hooks
- Same state + UI affordances
- Same ML surfaces

Once that's true, you can:
- Attach a package → everything just works
- Auto-generate docs, menus, workflows, agents
- Let ML reason across all packages uniformly

---

## Package Contract (Required Files)

Every package MUST have these canonical files:

```
PackageRoot/
├── Package.swift                    # Swift Package Manager
├── Sources/
│   └── PackageName/
│       ├── Resources/
│       │   ├── Package.manifest.json      # Identity + metadata
│       │   ├── Package.capabilities.json  # What this package can do
│       │   ├── Package.state.json         # State model
│       │   ├── Package.actions.json       # Actions the system can invoke
│       │   ├── Package.ui.json            # Declarative UI + UX hooks
│       │   ├── Package.agents.json        # AI agents
│       │   └── Package.workflows.json     # Automation workflows
│       ├── PackageNameContract.swift      # Contract loader
│       └── ... (other source files)
└── README.md
```

---

## JSON Schemas

### 1. Package.manifest.json
Identity and metadata.

```json
{
  "id": "com.flowkit.commandkit",
  "name": "CommandKit",
  "version": "1.0.0",
  "category": "core",
  "platforms": ["macOS", "iOS", "visionOS"],
  "dependencies": ["DataKit", "CoreKit"]
}
```

**Used by:** KitOrchestrator, Marketplace, UI menus, ML classification

### 2. Package.capabilities.json
What this package can do.

```json
{
  "nodes": ["Command", "Template", "Macro"],
  "actions": ["command.create", "command.execute", "command.delete"],
  "agents": ["CommandSuggester", "HistoryTracker"],
  "commands": ["/run", "/commands", "/help"],
  "ui": ["browser", "list", "editor"],
  "ml": ["prediction", "recommendation", "search"]
}
```

**Used by:** Auto-wiring menus, chat commands, workflows

### 3. Package.state.json
State model exposed to the app.

```json
{
  "states": [
    { "id": "idle", "name": "Idle", "icon": "circle", "color": "gray" },
    { "id": "executing", "name": "Executing", "icon": "play.fill", "color": "green" },
    { "id": "error", "name": "Error", "icon": "exclamationmark.triangle", "color": "red" }
  ],
  "events": [
    { "id": "command.started", "name": "Command Started", "severity": "info" },
    { "id": "command.completed", "name": "Command Completed", "severity": "success" }
  ],
  "transitions": [
    { "from": "idle", "to": "executing", "event": "command.started" }
  ]
}
```

**Feeds:** Banners, notifications, animations, progress UI, accessibility

### 4. Package.actions.json
Actions the system can invoke.

```json
{
  "actions": [
    {
      "id": "command.create",
      "name": "Create Command",
      "description": "Create a new command",
      "icon": "plus",
      "input": [
        { "name": "name", "type": "string", "required": true }
      ],
      "output": "Command",
      "shortcut": "⌘N",
      "category": "create"
    }
  ]
}
```

**Bridge:** Chat → Action → Kit

### 5. Package.ui.json
Declarative UI and UX hooks.

```json
{
  "menus": [
    {
      "id": "command.main",
      "type": "main",
      "items": [
        { "id": "cmd.new", "title": "New Command", "icon": "plus", "action": "command.create", "shortcut": "⌘N" }
      ]
    }
  ],
  "views": [
    { "id": "command.browser", "type": "browser", "title": "Commands", "icon": "command" }
  ],
  "accessibility": {
    "voiceOver": true,
    "reduceMotion": true,
    "highContrast": true
  }
}
```

**Allows:** Auto menus, consistent layout, per-package theming, motion rules

### 6. Package.agents.json
AI agents for intelligent automation.

```json
{
  "agents": [
    {
      "id": "command.suggester",
      "name": "Command Suggester",
      "description": "Suggests commands based on context",
      "triggers": [
        { "type": "event", "condition": "user.typing" }
      ],
      "actions": ["analyze.context", "suggest.commands"],
      "config": { "autoStart": true, "priority": "high" }
    }
  ]
}
```

### 7. Package.workflows.json
Pre-built automation sequences.

```json
{
  "workflows": [
    {
      "id": "command.quick.execute",
      "name": "Quick Command Execution",
      "description": "Execute a command via palette",
      "steps": [
        { "id": "1", "action": "command.palette.open" },
        { "id": "2", "action": "command.search" },
        { "id": "3", "action": "command.execute" }
      ],
      "triggers": ["shortcut.⌘K"]
    }
  ]
}
```

---

## Automation Pipeline

When you attach a package, everything auto-wires:

```
Attach Package
    ↓
PackageOrchestrator reads manifests
    ↓
CoreKit registers nodes + actions
    ↓
DocKit generates documentation
    ↓
WorkflowKit creates default workflows
    ↓
AgentKit spins up agents
    ↓
CommandKit registers commands
    ↓
UI auto-generates menus & views
    ↓
ML indexes everything
```

**The user presses Run once. Everything else is deterministic.**

---

## Key Components

### PackageOrchestrator
Central coordinator that:
- Loads and validates packages
- Resolves dependencies (topological sort)
- Auto-wires all systems
- Manages package lifecycle

```swift
// Attach a package
try await PackageOrchestrator.shared.attachPackage(contract)

// Run the system
try await PackageOrchestrator.shared.run()
```

### UIGenerator
Auto-generates UI from package contracts:
- Main menus
- Context menus
- Toolbars
- Sidebars
- Views

### MLIndexer
Indexes everything for intelligent operations:
- Semantic search
- Recommendations
- Predictions
- Explanations

### PackageGenerator
Creates complete package contracts from minimal input:

```swift
let contract = PackageGenerator.generate(
    id: "com.flowkit.mykit",
    name: "MyKit",
    category: .utility,
    description: "My custom package",
    nodes: ["MyNode"]
)
```

---

## Usage

### Bootstrap the System

```swift
import DataKit

// Initialize
await bootstrapPackageSystem()

// Attach packages
await CommandKitContract.shared.register()
await WorkflowKitContract.shared.register()
// ... more packages

// Run
try await runPackageSystem()
```

### Create a New Package

1. Use `PackageTemplate.generateAllFiles()` to create all canonical files
2. Place JSON files in `Resources/`
3. Create `PackageNameContract.swift` to load the contract
4. Register with the orchestrator

```swift
let files = PackageTemplate.generateAllFiles(
    id: "com.flowkit.mykit",
    name: "MyKit",
    category: .utility,
    description: "My package",
    nodes: ["MyNode"]
)

// files.jsonFiles contains all JSON content
// files.contractSwift contains the Swift loader
```

---

## ML Utilization

ML is used for **augmentation, not control**.

### ML Roles
- Explain files
- Detect inconsistencies
- Suggest workflows
- Predict next steps
- Personalize UI flows
- Optimize automation order

### ML Inputs
- Manifests
- State transitions
- User actions
- Package usage
- Documentation

### ML Outputs
- Recommendations
- Warnings
- Auto-generated guides
- Agent behavior tuning

---

## State Management

### Global State (CoreKit)
```
AppState
├── ActiveProject
├── ActiveNode
├── ActivePackage
├── AutomationStatus
├── Notifications
└── UserContext
```

### Package State (Per Package)
Each package emits:
- Progress
- Alerts
- Completion
- Errors

These automatically trigger:
- Banners
- Toasts
- Animations
- VoiceOver
- Achievements

---

## What This Gives You

- **A package operating system**
- **Zero manual wiring**
- **Consistent UI**
- **ML-powered intelligence**
- **Offline-first automation**
- **Platform-agnostic UI**
- **Scales to 100+ packages**
- **Feels designed, not hacked**

---

## Gold Standard: CommandKit

CommandKit is the reference implementation. All packages should follow its structure:

```
CommandKit/
├── Package.swift
├── Sources/CommandKit/
│   ├── Resources/
│   │   ├── Package.manifest.json
│   │   ├── Package.capabilities.json
│   │   ├── Package.state.json
│   │   ├── Package.actions.json
│   │   ├── Package.ui.json
│   │   ├── Package.agents.json
│   │   └── Package.workflows.json
│   ├── CommandKitContract.swift
│   ├── Models/
│   ├── Services/
│   ├── Views/
│   └── ViewModels/
└── README.md
```

**Total: 21 actions, 6 agents, 10 workflows, 30+ commands**
