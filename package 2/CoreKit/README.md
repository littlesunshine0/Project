# CoreKit

The Core Data Model for the Project Operating System.

A local-first, AI-native project explorer that turns any directory into a fully navigable, editable, explainable, and automatable system — controlled entirely through chat.

**This is not an IDE. It's an intelligence layer over the filesystem.**

## Core Concept: Everything is a Node

```swift
// The fundamental unit - everything is a Node
struct Node {
    let id: String
    let type: NodeType           // sourceFile, view, script, workflow, agent...
    var path: String
    var name: String
    var extensions: [NodeExtension]      // syntax, preview, runtime, ml...
    var relationships: [NodeRelationship] // contains, imports, tests...
    var representations: NodeRepresentations // raw, parsed, indexed, embeddings
    var metadata: NodeMetadata           // tags, labels, annotations
    var capabilities: Set<NodeCapability> // viewable, editable, executable...
}
```

## Quick Start

```swift
import CoreKit

// Create nodes using factories
let project = NodeFactory.project(path: "/myapp", name: "MyApp")
let view = NodeFactory.view(path: "/myapp/Views/Home.swift", name: "Home.swift")
let script = NodeFactory.script(path: "/myapp/scripts/build.sh", name: "build.sh")

// Auto-detect type from path
let node = NodeFactory.fromPath("/myapp/src/utils.swift")
// → type: .sourceFile, capabilities: [.editable, .searchable, .embeddable, ...]

// Add to semantic graph
await CoreKit.graph.add(project)
await CoreKit.graph.add(view)

// Query the graph
let views = await CoreKit.graph.byType(.view)
let executables = await CoreKit.graph.byCapability(.executable)
let deps = await CoreKit.graph.dependencies(of: view.id)

// Parse chat commands
let intent = await CoreKit.chat.parse("Show all views")
// → type: .show, targets: [nodesByType: .view]
```

## Multi-Layer CRUD

CRUD happens at multiple layers, not just files:

| Layer | What it CRUDs |
|-------|---------------|
| File | Raw file content on disk |
| Node | Logical entity (type, name, path) |
| Metadata | Tags, labels, annotations (no file change) |
| Representation | Parsed AST, indexed text, embeddings |
| Relationship | Links between nodes (imports, depends, tests) |
| Capability | What the node can do (preview, execute, explain) |

```swift
// When you edit a script, you're actually CRUDing:
let multiLayer = MultiLayerCRUD.forFileChange(
    nodeId: script.id,
    path: script.path,
    content: newContent
)
// Cascades to: file, parsed, indexed, humanReadable, mlEmbeddings
```

## Semantic Graph

The directory becomes a semantic graph, not just a tree:

```swift
// Query operations
let views = await graph.byType(.view)
let executables = await graph.byCapability(.executable)
let children = await graph.children(of: projectId)
let deps = await graph.dependencies(of: nodeId)
let dependents = await graph.dependents(of: nodeId)
let results = await graph.search("authentication")
let similar = await graph.findSimilar(to: nodeId, limit: 10)
```

## Chat → Action Mapping

The chat is not a chatbot, it's a command surface:

```swift
// Parse natural language into structured intents
let intent = await CoreKit.chat.parse("Explain HomeView.swift")
// → type: .explain
// → targets: [specificNode: "HomeView.swift"]
// → action: ChatAction(type: .query)

let deleteIntent = await CoreKit.chat.parse("Delete this file")
// → type: .delete
// → action.requiresConfirmation: true
// → action.isDestructive: true
```

### Intent Types

| Category | Intents |
|----------|---------|
| Query | explain, describe, find, show, list, compare |
| Modify | create, edit, delete, rename, move, convert |
| Execute | run, test, build, deploy |
| Generate | generate, document, refactor, suggest |
| Link | link, unlink, connect |
| Meta | help, status, history, undo |

## Node Types

- **Project Structure**: project, package, module, directory
- **Code**: sourceFile, component, view, model, service, test
- **Automation**: script, command, workflow, agent, task
- **Assets**: asset, image, icon, data, config
- **Documentation**: document, readme, spec, changelog

## Capabilities

- **View**: viewable, previewable, renderable
- **Edit**: editable, refactorable, convertible
- **Execute**: executable, testable, debuggable
- **AI**: explainable, suggestible, generatable
- **Index**: indexable, searchable, embeddable
- **Sync**: syncable, versionable, exportable

## Representations

Every node can have multiple representations:

```swift
struct NodeRepresentations {
    var raw: RawRepresentation?           // bytes, encoding, mimeType
    var parsed: ParsedRepresentation?     // AST, symbols, imports
    var indexed: IndexedRepresentation?   // keywords, topics, searchable
    var humanReadable: HumanReadableRepresentation? // summary, explanation
    var mlEmbeddings: MLEmbeddingsRepresentation?   // vector, model
}
```

## Tests

63 tests covering all components:
- Node, NodeFactory, RelationshipFactory, ExtensionFactory
- NodeGraph queries and operations
- CRUD operations and multi-layer cascading
- ChatIntent parsing and ChatResponse creation
- All representation types
- Integration workflows

```bash
swift test
# ✅ 63 tests passed
```

## Architecture

CoreKit is the foundation of the Project Operating System:

```
┌─────────────────────────────────────────────────────────────┐
│                        CoreKit                               │
├─────────────────────────────────────────────────────────────┤
│  Node/           - Node schema, types, capabilities         │
│  CRUD/           - Multi-layer CRUD contracts               │
│  Graph/          - Semantic graph operations                │
│  Chat/           - Chat → Action mapping                    │
│  CoreKit.swift   - Factories and quick access               │
└─────────────────────────────────────────────────────────────┘
```
