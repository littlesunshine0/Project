//
//  CoreKitTests.swift
//  CoreKit Tests
//

import Foundation
import Testing
@testable import CoreKit

// MARK: - Node Tests

@Suite("Node Tests")
struct NodeTests {
    
    @Test("Node creation with defaults")
    func nodeCreation() {
        let node = Node(
            type: .sourceFile,
            path: "/project/src/main.swift",
            name: "main.swift"
        )
        
        #expect(!node.id.isEmpty)
        #expect(node.type == .sourceFile)
        #expect(node.path == "/project/src/main.swift")
        #expect(node.name == "main.swift")
        #expect(node.extensions.isEmpty)
        #expect(node.relationships.isEmpty)
        #expect(node.capabilities.isEmpty)
    }
    
    @Test("Node with capabilities")
    func nodeWithCapabilities() {
        let node = Node(
            type: .view,
            path: "/project/Views/HomeView.swift",
            name: "HomeView.swift",
            capabilities: [.viewable, .editable, .previewable, .explainable]
        )
        
        #expect(node.capabilities.contains(.viewable))
        #expect(node.capabilities.contains(.previewable))
        #expect(node.capabilities.count == 4)
    }
    
    @Test("Node with metadata")
    func nodeWithMetadata() {
        var node = Node(
            type: .sourceFile,
            path: "/project/src/utils.swift",
            name: "utils.swift"
        )
        node.metadata.tags = ["utility", "helpers"]
        node.metadata.labels["language"] = "swift"
        node.metadata.author = "developer"
        
        #expect(node.metadata.tags.count == 2)
        #expect(node.metadata.labels["language"] == "swift")
        #expect(node.metadata.author == "developer")
    }
    
    @Test("Node with relationships")
    func nodeWithRelationships() {
        let relationship = NodeRelationship(
            type: .imports,
            targetId: "target-123"
        )
        
        let node = Node(
            type: .sourceFile,
            path: "/project/src/app.swift",
            name: "app.swift",
            relationships: [relationship]
        )
        
        #expect(node.relationships.count == 1)
        #expect(node.relationships[0].type == .imports)
        #expect(node.relationships[0].targetId == "target-123")
    }
    
    @Test("Node with extensions")
    func nodeWithExtensions() {
        let syntaxExt = NodeExtension(type: .syntax, config: ["language": "swift"])
        let previewExt = NodeExtension(type: .preview, config: ["renderer": "swiftui"])
        
        let node = Node(
            type: .view,
            path: "/project/Views/ContentView.swift",
            name: "ContentView.swift",
            extensions: [syntaxExt, previewExt]
        )
        
        #expect(node.extensions.count == 2)
        #expect(node.extensions[0].type == .syntax)
        #expect(node.extensions[1].config["renderer"] == "swiftui")
    }
}

// MARK: - NodeFactory Tests

@Suite("NodeFactory Tests")
struct NodeFactoryTests {
    
    @Test("Create project node")
    func createProject() {
        let node = NodeFactory.project(path: "/myproject", name: "MyProject")
        
        #expect(node.type == .project)
        #expect(node.name == "MyProject")
        #expect(node.capabilities.contains(.viewable))
        #expect(node.capabilities.contains(.indexable))
    }
    
    @Test("Create source file node")
    func createSourceFile() {
        let node = NodeFactory.sourceFile(path: "/src/main.swift", name: "main.swift", language: "swift")
        
        #expect(node.type == .sourceFile)
        #expect(node.metadata.labels["language"] == "swift")
        #expect(node.capabilities.contains(.editable))
        #expect(node.capabilities.contains(.refactorable))
    }
    
    @Test("Create view node")
    func createView() {
        let node = NodeFactory.view(path: "/Views/Home.swift", name: "Home.swift")
        
        #expect(node.type == .view)
        #expect(node.capabilities.contains(.previewable))
    }
    
    @Test("Create script node")
    func createScript() {
        let node = NodeFactory.script(path: "/scripts/build.sh", name: "build.sh")
        
        #expect(node.type == .script)
        #expect(node.capabilities.contains(.executable))
        #expect(node.capabilities.contains(.testable))
    }
    
    @Test("Create workflow node")
    func createWorkflow() {
        let node = NodeFactory.workflow(path: "/workflows/deploy.yaml", name: "deploy.yaml")
        
        #expect(node.type == .workflow)
        #expect(node.capabilities.contains(.executable))
    }
    
    @Test("Create document node")
    func createDocument() {
        let node = NodeFactory.document(path: "/docs/README.md", name: "README.md")
        
        #expect(node.type == .document)
        #expect(node.capabilities.contains(.searchable))
        #expect(node.capabilities.contains(.previewable))
    }
    
    @Test("Detect type from path - Swift")
    func detectTypeSwift() {
        let type = NodeFactory.detectType(from: "/src/main.swift")
        #expect(type == .sourceFile)
    }
    
    @Test("Detect type from path - Script")
    func detectTypeScript() {
        let type = NodeFactory.detectType(from: "/scripts/build.sh")
        #expect(type == .script)
    }
    
    @Test("Detect type from path - Config")
    func detectTypeConfig() {
        let type = NodeFactory.detectType(from: "/config/settings.json")
        #expect(type == .config)
    }
    
    @Test("Detect type from path - Document")
    func detectTypeDocument() {
        let type = NodeFactory.detectType(from: "/docs/README.md")
        #expect(type == .document)
    }
    
    @Test("Detect type from path - Image")
    func detectTypeImage() {
        let type = NodeFactory.detectType(from: "/assets/logo.png")
        #expect(type == .image)
    }
    
    @Test("Create node from path")
    func createFromPath() {
        let node = NodeFactory.fromPath("/project/src/utils.swift")
        
        #expect(node.type == .sourceFile)
        #expect(node.name == "utils.swift")
        #expect(node.capabilities.contains(.editable))
        #expect(node.capabilities.contains(.embeddable))
    }
}

// MARK: - RelationshipFactory Tests

@Suite("RelationshipFactory Tests")
struct RelationshipFactoryTests {
    
    @Test("Create contains relationship")
    func createContains() {
        let rel = RelationshipFactory.contains(targetId: "child-123")
        
        #expect(rel.type == .contains)
        #expect(rel.targetId == "child-123")
    }
    
    @Test("Create dependsOn relationship")
    func createDependsOn() {
        let rel = RelationshipFactory.dependsOn(targetId: "dep-456")
        
        #expect(rel.type == .dependsOn)
        #expect(rel.targetId == "dep-456")
    }
    
    @Test("Create imports relationship")
    func createImports() {
        let rel = RelationshipFactory.imports(targetId: "import-789")
        
        #expect(rel.type == .imports)
    }
    
    @Test("Create tests relationship")
    func createTests() {
        let rel = RelationshipFactory.tests(targetId: "tested-abc")
        
        #expect(rel.type == .tests)
    }
}

// MARK: - ExtensionFactory Tests

@Suite("ExtensionFactory Tests")
struct ExtensionFactoryTests {
    
    @Test("Create syntax extension")
    func createSyntax() {
        let ext = ExtensionFactory.syntax(language: "swift")
        
        #expect(ext.type == .syntax)
        #expect(ext.config["language"] == "swift")
        #expect(ext.isEnabled)
    }
    
    @Test("Create preview extension")
    func createPreview() {
        let ext = ExtensionFactory.preview(renderer: "swiftui")
        
        #expect(ext.type == .preview)
        #expect(ext.config["renderer"] == "swiftui")
    }
    
    @Test("Create runtime extension")
    func createRuntime() {
        let ext = ExtensionFactory.runtime(executor: "bash")
        
        #expect(ext.type == .runtime)
        #expect(ext.config["executor"] == "bash")
    }
    
    @Test("Create ML extension")
    func createML() {
        let ext = ExtensionFactory.ml(model: "embeddings-v1")
        
        #expect(ext.type == .ml)
        #expect(ext.config["model"] == "embeddings-v1")
    }
}


// MARK: - NodeGraph Tests

@Suite("NodeGraph Tests")
struct NodeGraphTests {
    
    @Test("Add and get node")
    func addAndGetNode() async {
        let graph = NodeGraph.shared
        let node = Node(
            id: "test-node-1",
            type: .sourceFile,
            path: "/test/file1.swift",
            name: "file1.swift"
        )
        
        await graph.add(node)
        let retrieved = await graph.get("test-node-1")
        
        #expect(retrieved != nil)
        #expect(retrieved?.name == "file1.swift")
    }
    
    @Test("Get node by path")
    func getByPath() async {
        let graph = NodeGraph.shared
        let node = Node(
            id: "test-node-2",
            type: .view,
            path: "/test/views/HomeView.swift",
            name: "HomeView.swift"
        )
        
        await graph.add(node)
        let retrieved = await graph.getByPath("/test/views/HomeView.swift")
        
        #expect(retrieved != nil)
        #expect(retrieved?.id == "test-node-2")
    }
    
    @Test("Query nodes by type")
    func queryByType() async {
        let graph = NodeGraph.shared
        
        let view1 = Node(id: "view-1", type: .view, path: "/views/A.swift", name: "A.swift")
        let view2 = Node(id: "view-2", type: .view, path: "/views/B.swift", name: "B.swift")
        let script = Node(id: "script-1", type: .script, path: "/scripts/run.sh", name: "run.sh")
        
        await graph.add(view1)
        await graph.add(view2)
        await graph.add(script)
        
        let views = await graph.byType(.view)
        #expect(views.count >= 2)
    }
    
    @Test("Query nodes by capability")
    func queryByCapability() async {
        let graph = NodeGraph.shared
        
        let executableNode = Node(
            id: "exec-1",
            type: .script,
            path: "/scripts/deploy.sh",
            name: "deploy.sh",
            capabilities: [.executable, .viewable]
        )
        
        await graph.add(executableNode)
        
        let executables = await graph.byCapability(.executable)
        #expect(executables.contains { $0.id == "exec-1" })
    }
    
    @Test("Get children of node")
    func getChildren() async {
        let graph = NodeGraph.shared
        
        let childRel = NodeRelationship(type: .contains, targetId: "child-node")
        let parent = Node(
            id: "parent-node",
            type: .directory,
            path: "/src",
            name: "src",
            relationships: [childRel]
        )
        let child = Node(
            id: "child-node",
            type: .sourceFile,
            path: "/src/main.swift",
            name: "main.swift"
        )
        
        await graph.add(parent)
        await graph.add(child)
        
        let children = await graph.children(of: "parent-node")
        #expect(children.contains { $0.id == "child-node" })
    }
    
    @Test("Search nodes")
    func searchNodes() async {
        let graph = NodeGraph.shared
        
        let node = Node(
            id: "searchable-node",
            type: .document,
            path: "/docs/architecture.md",
            name: "architecture.md"
        )
        
        await graph.add(node)
        
        let results = await graph.search(query: "architecture")
        #expect(results.contains { $0.id == "searchable-node" })
    }
    
    @Test("Remove node")
    func removeNode() async {
        let graph = NodeGraph.shared
        
        let node = Node(
            id: "removable-node",
            type: .config,
            path: "/config/temp.json",
            name: "temp.json"
        )
        
        await graph.add(node)
        await graph.remove("removable-node")
        
        let retrieved = await graph.get("removable-node")
        #expect(retrieved == nil)
    }
    
    @Test("Graph stats")
    func graphStats() async {
        let graph = NodeGraph.shared
        let stats = await graph.stats
        
        #expect(stats.nodeCount >= 0)
        #expect(stats.relationshipCount >= 0)
    }
}

// MARK: - CRUD Tests

@Suite("CRUD Tests")
struct CRUDTests {
    
    @Test("Create CRUD operation")
    func createOperation() {
        let operation = CRUDOperation(
            type: .create,
            layer: .node,
            nodeId: "new-node",
            path: "/src/new.swift",
            payload: .node(Node(type: .sourceFile, path: "/src/new.swift", name: "new.swift"))
        )
        
        #expect(operation.type == .create)
        #expect(operation.layer == .node)
        #expect(operation.nodeId == "new-node")
        #expect(operation.source == .user)
    }
    
    @Test("CRUD result success")
    func resultSuccess() {
        let operation = CRUDOperation(
            type: .read,
            layer: .file,
            payload: .empty
        )
        
        let result = CRUDResult(
            success: true,
            operation: operation,
            affectedNodes: ["node-1"],
            duration: 0.05
        )
        
        #expect(result.success)
        #expect(result.affectedNodes.count == 1)
        #expect(result.error == nil)
    }
    
    @Test("CRUD result failure")
    func resultFailure() {
        let operation = CRUDOperation(
            type: .delete,
            layer: .file,
            payload: .empty
        )
        
        let result = CRUDResult(
            success: false,
            operation: operation,
            error: .nodeNotFound("missing-node")
        )
        
        #expect(!result.success)
        #expect(result.error != nil)
    }
    
    @Test("Multi-layer CRUD for file change")
    func multiLayerFileChange() {
        let multiLayer = MultiLayerCRUD.forFileChange(
            nodeId: "file-node",
            path: "/src/main.swift",
            content: "// updated".data(using: .utf8)!
        )
        
        #expect(multiLayer.primaryOperation.type == .update)
        #expect(multiLayer.primaryOperation.layer == .file)
        #expect(multiLayer.cascadingOperations.count == 4) // parsed, indexed, humanReadable, mlEmbeddings
        #expect(multiLayer.affectedLayers.contains(.file))
        #expect(multiLayer.affectedLayers.contains(.representation))
    }
    
    @Test("Multi-layer CRUD for node creation")
    func multiLayerNodeCreation() {
        let node = Node(
            type: .sourceFile,
            path: "/src/utils.swift",
            name: "utils.swift",
            capabilities: [.indexable, .explainable, .embeddable]
        )
        
        let multiLayer = MultiLayerCRUD.forNodeCreation(
            node: node,
            content: "// utils".data(using: .utf8)!
        )
        
        #expect(multiLayer.primaryOperation.type == .create)
        #expect(multiLayer.primaryOperation.layer == .node)
        #expect(multiLayer.cascadingOperations.count >= 1) // At least file creation
        #expect(multiLayer.affectedLayers.contains(.node))
        #expect(multiLayer.affectedLayers.contains(.file))
    }
    
    @Test("CRUD change tracking")
    func changeTracking() {
        let change = CRUDChange(
            nodeId: "node-1",
            field: "name",
            oldValue: "old.swift",
            newValue: "new.swift"
        )
        
        #expect(change.nodeId == "node-1")
        #expect(change.field == "name")
        #expect(change.oldValue == "old.swift")
        #expect(change.newValue == "new.swift")
    }
    
    @Test("CRUD event creation")
    func eventCreation() {
        let operation = CRUDOperation(type: .update, layer: .metadata, payload: .empty)
        let result = CRUDResult(success: true, operation: operation)
        let event = CRUDEvent(operation: operation, result: result)
        
        #expect(!event.id.isEmpty)
        #expect(event.result.success)
    }
}

// MARK: - ChatIntent Tests

@Suite("ChatIntent Tests")
struct ChatIntentTests {
    
    @Test("Parse explain intent")
    func parseExplain() async {
        let parser = ChatIntentParser.shared
        let intent = await parser.parse("Explain this code")
        
        #expect(intent.type == .explain)
        #expect(intent.action.type == .query)
    }
    
    @Test("Parse create intent")
    func parseCreate() async {
        let parser = ChatIntentParser.shared
        let intent = await parser.parse("Create a new workflow")
        
        #expect(intent.type == .create)
        #expect(intent.action.type == .create)
    }
    
    @Test("Parse delete intent")
    func parseDelete() async {
        let parser = ChatIntentParser.shared
        let intent = await parser.parse("Delete this file")
        
        #expect(intent.type == .delete)
        #expect(intent.action.type == .delete)
        #expect(intent.action.requiresConfirmation)
        #expect(intent.action.isDestructive)
    }
    
    @Test("Parse run intent")
    func parseRun() async {
        let parser = ChatIntentParser.shared
        let intent = await parser.parse("Run the build script")
        
        #expect(intent.type == .run)
        #expect(intent.action.type == .execute)
    }
    
    @Test("Parse find intent")
    func parseFind() async {
        let parser = ChatIntentParser.shared
        let intent = await parser.parse("Find all views")
        
        #expect(intent.type == .find)
        #expect(intent.targets.contains { $0.nodeType == .view })
    }
    
    @Test("Parse list intent")
    func parseList() async {
        let parser = ChatIntentParser.shared
        let intent = await parser.parse("List all scripts")
        
        #expect(intent.type == .list)
        #expect(intent.targets.contains { $0.nodeType == .script })
    }
    
    @Test("Parse refactor intent")
    func parseRefactor() async {
        let parser = ChatIntentParser.shared
        let intent = await parser.parse("Refactor this function")
        
        #expect(intent.type == .refactor)
        #expect(intent.action.type == .transform)
    }
    
    @Test("Parse generate intent")
    func parseGenerate() async {
        let parser = ChatIntentParser.shared
        let intent = await parser.parse("Generate documentation for this")
        
        #expect(intent.type == .generate)
        #expect(intent.action.type == .generate)
    }
    
    @Test("Detect file target")
    func detectFileTarget() async {
        let parser = ChatIntentParser.shared
        let intent = await parser.parse("Explain HomeView.swift")
        
        #expect(intent.targets.contains { $0.identifier == "HomeView.swift" })
    }
    
    @Test("Confidence calculation")
    func confidenceCalculation() async {
        let parser = ChatIntentParser.shared
        
        let shortIntent = await parser.parse("explain")
        let longIntent = await parser.parse("Can you please explain this code to me")
        
        #expect(longIntent.confidence > shortIntent.confidence)
    }
}

// MARK: - ChatResponse Tests

@Suite("ChatResponse Tests")
struct ChatResponseTests {
    
    @Test("Create text response")
    func textResponse() {
        let response = ChatResponse(
            intentId: "intent-1",
            type: .text,
            content: .text("This is a Swift file that defines...")
        )
        
        #expect(response.type == .text)
        if case .text(let content) = response.content {
            #expect(content.contains("Swift"))
        }
    }
    
    @Test("Create node list response")
    func nodeListResponse() {
        let nodes = [
            Node(type: .view, path: "/views/A.swift", name: "A.swift"),
            Node(type: .view, path: "/views/B.swift", name: "B.swift")
        ]
        
        let response = ChatResponse(
            intentId: "intent-2",
            type: .nodeList,
            content: .nodes(nodes)
        )
        
        #expect(response.type == .nodeList)
        if case .nodes(let list) = response.content {
            #expect(list.count == 2)
        }
    }
    
    @Test("Create diff response")
    func diffResponse() {
        let diff = DiffContent(
            before: "let x = 1",
            after: "let x = 2",
            changes: ["Changed value from 1 to 2"]
        )
        
        let response = ChatResponse(
            intentId: "intent-3",
            type: .diff,
            content: .diff(diff)
        )
        
        #expect(response.type == .diff)
    }
    
    @Test("Response with follow-up actions")
    func followUpActions() async {
        let parser = ChatIntentParser.shared
        let followUpIntent = await parser.parse("Show more details")
        
        let followUp = ChatFollowUpAction(
            label: "Show more",
            intent: followUpIntent
        )
        
        let response = ChatResponse(
            intentId: "intent-4",
            type: .text,
            content: .text("Here's a summary..."),
            actions: [followUp]
        )
        
        #expect(response.actions.count == 1)
        #expect(response.actions[0].label == "Show more")
    }
}

// MARK: - Representations Tests

@Suite("Representations Tests")
struct RepresentationsTests {
    
    @Test("Raw representation")
    func rawRepresentation() {
        let content = "let x = 1".data(using: .utf8)!
        let raw = RawRepresentation(
            content: content,
            encoding: "utf-8",
            mimeType: "text/x-swift"
        )
        
        #expect(raw.size == content.count)
        #expect(raw.encoding == "utf-8")
        #expect(raw.mimeType == "text/x-swift")
    }
    
    @Test("Parsed representation")
    func parsedRepresentation() {
        let parsed = ParsedRepresentation(
            structure: "{\"type\": \"file\"}",
            symbols: ["main", "helper"],
            imports: ["Foundation", "SwiftUI"],
            exports: ["MyClass"],
            language: "swift"
        )
        
        #expect(parsed.symbols.count == 2)
        #expect(parsed.imports.contains("Foundation"))
        #expect(parsed.language == "swift")
    }
    
    @Test("Indexed representation")
    func indexedRepresentation() {
        let indexed = IndexedRepresentation(
            keywords: ["swift", "view", "ui"],
            topics: ["user interface", "mobile"],
            searchableText: "A SwiftUI view for displaying content"
        )
        
        #expect(indexed.keywords.count == 3)
        #expect(indexed.topics.count == 2)
        #expect(indexed.searchableText.contains("SwiftUI"))
    }
    
    @Test("Human readable representation")
    func humanReadableRepresentation() {
        let humanReadable = HumanReadableRepresentation(
            summary: "Main entry point",
            description: "This file contains the main entry point for the application",
            explanation: "The @main attribute marks this as the app entry point",
            documentation: "# Main\n\nThe main entry point..."
        )
        
        #expect(humanReadable.summary == "Main entry point")
        #expect(humanReadable.explanation != nil)
    }
    
    @Test("ML embeddings representation")
    func mlEmbeddingsRepresentation() {
        let embeddings = MLEmbeddingsRepresentation(
            vector: [0.1, 0.2, 0.3, 0.4, 0.5],
            model: "local-embeddings-v1"
        )
        
        #expect(embeddings.vector.count == 5)
        #expect(embeddings.model == "local-embeddings-v1")
    }
    
    @Test("Node with all representations")
    func nodeWithAllRepresentations() {
        let representations = NodeRepresentations(
            raw: RawRepresentation(content: Data()),
            parsed: ParsedRepresentation(),
            indexed: IndexedRepresentation(),
            humanReadable: HumanReadableRepresentation(),
            mlEmbeddings: MLEmbeddingsRepresentation()
        )
        
        let node = Node(
            type: .sourceFile,
            path: "/src/main.swift",
            name: "main.swift",
            representations: representations
        )
        
        #expect(node.representations.raw != nil)
        #expect(node.representations.parsed != nil)
        #expect(node.representations.indexed != nil)
        #expect(node.representations.humanReadable != nil)
        #expect(node.representations.mlEmbeddings != nil)
    }
}

// MARK: - CoreKit Integration Tests

@Suite("CoreKit Integration Tests")
struct CoreKitIntegrationTests {
    
    @Test("CoreKit version")
    func version() {
        #expect(CoreKit.version == "1.0.0")
        #expect(!CoreKit.identifier.isEmpty)
        #expect(!CoreKit.description.isEmpty)
    }
    
    @Test("Full workflow: Create project with files")
    func fullWorkflow() async {
        let graph = CoreKit.graph
        
        // Create project
        let project = NodeFactory.project(path: "/myapp", name: "MyApp")
        await graph.add(project)
        
        // Create source file
        var sourceFile = NodeFactory.sourceFile(
            path: "/myapp/src/main.swift",
            name: "main.swift",
            language: "swift"
        )
        sourceFile.relationships.append(RelationshipFactory.contains(targetId: project.id))
        await graph.add(sourceFile)
        
        // Create view
        var view = NodeFactory.view(path: "/myapp/Views/Home.swift", name: "Home.swift")
        view.extensions.append(ExtensionFactory.preview(renderer: "swiftui"))
        await graph.add(view)
        
        // Verify
        let retrieved = await graph.get(project.id)
        #expect(retrieved != nil)
        
        let views = await graph.byType(.view)
        #expect(views.contains { $0.id == view.id })
    }
    
    @Test("Chat to action workflow")
    func chatToAction() async {
        let parser = CoreKit.chat
        
        // User says "Show all views"
        let intent = await parser.parse("Show all views")
        
        #expect(intent.type == .show || intent.type == .list)
        #expect(intent.targets.contains { $0.nodeType == .view })
        
        // This would trigger a query on the graph
        let graph = CoreKit.graph
        let views = await graph.byType(.view)
        
        // Create response
        let response = ChatResponse(
            intentId: intent.id,
            type: .nodeList,
            content: .nodes(views)
        )
        
        #expect(response.type == .nodeList)
    }
}
