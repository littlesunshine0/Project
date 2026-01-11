# AgentKit

A professional autonomous agent system for Swift applications.

## Overview

AgentKit provides a complete solution for creating and managing autonomous agents with support for:

- **Agent lifecycle management** - Create, update, delete, and monitor agents
- **Trigger-based automation** - File changes, schedules, webhooks, git events
- **Action execution** - Shell commands, workflows, notifications, AI operations
- **Scheduling** - Cron expressions, intervals, daily/weekly/monthly
- **AI capabilities** - Code analysis, documentation, refactoring

## Installation

Add AgentKit to your `Package.swift`:

```swift
dependencies: [
    .package(path: "../AgentKit")
]
```

## Quick Start

### Creating an Agent

```swift
import AgentKit

let agent = Agent(
    name: "Build Watcher",
    description: "Automatically builds when files change",
    type: .watcher,
    capabilities: [.executeCommands, .notifications],
    triggers: [
        AgentTrigger(type: .fileChange, condition: "*.swift")
    ],
    actions: [
        AgentAction(name: "Build", type: .shellCommand, command: "swift build"),
        AgentAction(name: "Notify", type: .notification, command: "Build complete")
    ]
)
```

### Using the Agent Manager

```swift
@MainActor
func setupAgents() async {
    let manager = AgentManager.shared
    
    // Create an agent
    let agent = manager.createAgent(
        name: "Test Runner",
        description: "Runs tests on demand",
        type: .task,
        actions: [
            AgentAction(name: "Test", type: .shellCommand, command: "swift test")
        ]
    )
    
    // Run the agent
    let result = await manager.runAgent(agent)
    
    if result.status == .success {
        print("Agent completed successfully")
    }
}
```

### Using Factory Methods

```swift
// Create a simple task agent
let taskAgent = AgentKit.createTaskAgent(
    name: "Formatter",
    description: "Formats code",
    actions: [
        AgentAction(name: "Format", type: .shellCommand, command: "swift-format .")
    ]
)

// Create an automation agent with triggers
let autoAgent = AgentKit.createAutomationAgent(
    name: "Auto Tester",
    description: "Tests on file change",
    triggers: [AgentTrigger(type: .fileChange, condition: "Sources/**/*.swift")],
    actions: [AgentAction(name: "Test", type: .shellCommand, command: "swift test")]
)
```

## Architecture

```
AgentKit/
├── Models/
│   ├── Agent.swift           # Core agent model
│   └── AgentRunResult.swift  # Execution results
├── Services/
│   └── AgentManager.swift    # Lifecycle management
└── AgentKit.swift            # Public API
```

## Agent Types

| Type | Description |
|------|-------------|
| Task | Executes specific tasks on demand |
| Monitor | Monitors system resources and metrics |
| Automation | Automates repetitive workflows |
| Assistant | Provides intelligent assistance |
| Scheduler | Schedules and runs timed tasks |
| Watcher | Watches files for changes |
| Builder | Builds and compiles projects |
| Deployer | Deploys applications |

## Trigger Types

- Manual, Schedule, File Change
- Git Event, Webhook, System Event
- Command Pattern, Error Occurrence

## Action Types

- Shell Command, Workflow, Notification
- HTTP Request, File Operation, Git Command
- Build Command, Script, Conditional, Loop
- AI Analysis, AI Documentation, AI Refactoring

## License

MIT License
