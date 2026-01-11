# BridgeKit

Universal Kit Bridge System - automatically connects and orchestrates all Kits when attached to a project.

## One-Liner Activation

```swift
import BridgeKit

// Activate ALL Kits for a project - fully automatic
let result = await KitPack.activate(project: "/path/to/project")

// That's it. All Kits are now:
// ✅ Attached to the project
// ✅ Producing their outputs
// ✅ Bridged to compatible Kits
// ✅ Flowing data automatically
```

## How It Works

When you call `KitPack.activate()`:

1. **Registration** - All Kit descriptors are registered with their inputs/outputs
2. **Attachment** - Each Kit is attached to the project
3. **Auto-Bridge** - Compatible Kits are automatically connected
4. **Production** - Each Kit produces its initial outputs
5. **Flow** - Outputs flow through bridges to other Kits

## Preset Packs

```swift
// Documentation Pack: DocKit + ParseKit + SearchKit
await KitPack.docs(project: path)

// Intelligence Pack: NLUKit + LearnKit + CommandKit
await KitPack.intelligence(project: path)

// Automation Pack: WorkflowKit + AgentKit + CommandKit
await KitPack.automation(project: path)

// Full Stack: All 11 Kits
await KitPack.full(project: path)
```

## Event Hooks

```swift
// Trigger production when files change
await KitPack.fileChanged("Model.swift", in: projectPath)

// Trigger production when files are saved
await KitPack.fileSaved("README.md", in: projectPath)
```

## Manual Kit Selection

```swift
// Activate specific Kits
await KitPack.activate(kits: [.docKit, .parseKit, .nluKit], project: path)
```

## Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                        KitPack                               │
│                   (One-liner entry point)                    │
└─────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────┐
│                       AutoBridge                             │
│              (Automatic attachment & production)             │
└─────────────────────────────────────────────────────────────┘
                              │
              ┌───────────────┼───────────────┐
              ▼               ▼               ▼
┌─────────────────┐ ┌─────────────────┐ ┌─────────────────┐
│  BridgeRegistry │ │  BridgeExecutor │ │  KitDescriptors │
│  (Kit registry) │ │  (Data flow)    │ │  (Kit metadata) │
└─────────────────┘ └─────────────────┘ └─────────────────┘
```

## Kit Connections

BridgeKit automatically creates bridges between compatible Kits:

- **DocKit** → LearnKit (config → training data)
- **ParseKit** → DocKit (structure → documentation)
- **NLUKit** → AgentKit (intent → agent trigger)
- **NLUKit** → WorkflowKit (command → workflow)
- **CommandKit** → WorkflowKit (command → execution)
- **WorkflowKit** → AgentKit (workflow → agent)
- **ContentHub** → SearchKit (content → indexing)
- **ContentHub** → LearnKit (content → training)
- And many more...

## Data Types

Bridges connect ports with compatible data types:

| Type | Description |
|------|-------------|
| `text` | Plain text |
| `markdown` | Markdown content |
| `json` | JSON data |
| `code` | Source code |
| `intent` | User intent |
| `command` | Parsed command |
| `workflow` | Workflow definition |
| `action` | Action to execute |
| `content` | Generic content |

## Automatic Storage & Indexing

All produced content is automatically:
1. **Stored** in an in-memory database
2. **Indexed** for full-text search
3. **Organized** by project, Kit, and type

```swift
// Search all content across all projects
let results = await KitPack.search("authentication")

// Get all content for a project
let projectContent = await KitPack.getProjectContent("/path/to/project")

// Get all content from a specific Kit
let docContent = await KitPack.getKitContent("com.flowkit.dockit")

// Get all READMEs
let readmes = await KitPack.getTypeContent("readme")

// Export for ML training
let mlData = await KitPack.exportForML()

// Get storage statistics
let stats = await KitPack.storageStats()
// stats.totalContent, stats.projectCount, stats.indexedWords
```

## Tests

28 tests covering:
- KitPack activation
- Preset packs
- AutoBridge attachment
- BridgeRegistry operations
- BridgeExecutor flow
- Bridge chains and pairs
- Data type compatibility
- Kit production
- Content storage
- Full-text search indexing
- Project/Kit/Type retrieval
- ML export
