# Package Kit Structure Diagram

> **39 Kits** | **~450 Swift Files** | Generated: December 13, 2025

---

## Kit Overview Table

| # | Kit | Files | Subfolders |
|---|-----|-------|------------|
| 1 | ActivityKit | 6 | UI/ |
| 2 | AgentKit | 20 | Models/, Services/, UI/, ViewModels/, Views/ |
| 3 | AIKit | 17 | Engines/, Orchestrator/, UI/ |
| 4 | AnalyticsKit | 6 | UI/ |
| 5 | AppIdeaKit | 12 | Data/, Models/, Services/, UI/ |
| 6 | AssetKit | 6 | UI/ |
| 7 | BridgeKit | 11 | UI/ |
| 8 | ChatKit | 14 | Models/, Services/, UI/, ViewModels/, Views/ |
| 9 | CollaborationKit | 6 | UI/ |
| 10 | CommandKit | 24 | Models/, Services/, UI/, ViewModels/, Views/ |
| 11 | ContentHub | 7 | UI/ |
| 12 | CoreKit | 10 | Chat/, CRUD/, Graph/, Node/, UI/ |
| 13 | DataKit | 150+ | Generator/, ML/, Models/, Orchestrator/, Schemas/, UI/, Views/ |
| 14 | DesignKit | 21 | Components/, Design/, Extensions/, UI/, Widgets/ |
| 15 | DocKit | 24 | AutoDoc/, Generators/, Models/, Parsers/, Services/, UI/, ViewModels/, Views/ |
| 16 | ErrorKit | 6 | UI/ |
| 17 | ExportKit | 6 | UI/ |
| 18 | FeedbackKit | 6 | UI/ |
| 19 | FileKit | 6 | UI/ |
| 20 | IconKit | 45 | Components/, Core/, Export/, Icons/, Services/, UI/, Views/ |
| 21 | IdeaKit | 30 | Core/, Packages/, Tools/, UI/ |
| 22 | IndexerKit | 6 | UI/ |
| 23 | KitOrchestrator | 5 | UI/ |
| 24 | KnowledgeKit | 14 | Models/, Services/, UI/, ViewModels/, Views/ |
| 25 | LearnKit | 14 | Models/, Services/, UI/, ViewModels/, Views/ |
| 26 | MarketplaceKit | 6 | UI/ |
| 27 | NavigationKit | 9 | Models/, Services/, UI/ |
| 28 | NetworkKit | 6 | UI/ |
| 29 | NLUKit | 6 | UI/ |
| 30 | NotificationKit | 6 | UI/ |
| 31 | ParseKit | 6 | UI/ |
| 32 | ProjectScaffold | 12 | Models/, Services/, UI/, ScaffoldCLI/ |
| 33 | SearchKit | 13 | Models/, Services/, UI/, ViewModels/, Views/ |
| 34 | SyntaxKit | 6 | UI/ |
| 35 | SystemKit | 6 | UI/ |
| 36 | UIKit | 15 | KitContexts/, Models/, Protocols/, Systems/ |
| 37 | UserKit | 6 | UI/ |
| 38 | WebKit | 6 | UI/ |
| 39 | WorkflowKit | 26 | Models/, Services/, UI/, ViewModels/, Views/ |

---

## Full Tree Structure

```
package/
├── ActivityKit/
│   ├── Package.swift
│   ├── Sources/ActivityKit/
│   │   ├── ActivityKit.swift
│   │   ├── ActivityKitContract.swift
│   │   └── UI/
│   │       ├── BottomPanelItemActivity.swift
│   │       ├── KitLayoutActivity.swift
│   │       └── SidebarItemActivity.swift
│   └── Tests/ActivityKitTests/
│       └── ActivityKitTests.swift
│
├── AgentKit/
│   ├── Package.swift
│   ├── README.md
│   ├── Sources/AgentKit/
│   │   ├── AgentKit.swift
│   │   ├── AgentKitContract.swift
│   │   ├── AgentKitManifest.swift
│   │   ├── AgentKitPackage.swift
│   │   ├── Models/
│   │   │   ├── Agent.swift
│   │   │   ├── AgentError.swift
│   │   │   ├── AgentFormat.swift
│   │   │   ├── AgentKind.swift
│   │   │   └── AgentRunResult.swift
│   │   ├── Services/
│   │   │   ├── AgentComposer.swift
│   │   │   ├── AgentGenerator.swift
│   │   │   ├── AgentManager.swift
│   │   │   └── AgentParser.swift
│   │   ├── UI/
│   │   │   ├── BottomPanelItemAgent.swift
│   │   │   ├── KitLayoutAgent.swift
│   │   │   └── SidebarItemAgent.swift
│   │   ├── ViewModels/
│   │   │   └── AgentViewModel.swift
│   │   └── Views/
│   │       ├── AgentBrowser.swift
│   │       ├── AgentCard.swift
│   │       ├── AgentGallery.swift
│   │       ├── AgentIcon.swift
│   │       ├── AgentList.swift
│   │       └── AgentRow.swift
│   └── Tests/AgentKitTests/
│       └── AgentKitTests.swift
│
├── AIKit/
│   ├── Package.swift
│   ├── README.md
│   ├── Sources/AIKit/
│   │   ├── AIKit.swift
│   │   ├── AIKitContract.swift
│   │   ├── Engines/
│   │   │   ├── MemoryEngine.swift
│   │   │   ├── MemoryModels.swift
│   │   │   ├── PlanningEngine.swift
│   │   │   ├── PlanningModels.swift
│   │   │   ├── RiskEngine.swift
│   │   │   ├── RiskModels.swift
│   │   │   ├── StructureEngine.swift
│   │   │   ├── StructureModels.swift
│   │   │   ├── UnderstandingEngine.swift
│   │   │   └── UnderstandingModels.swift
│   │   ├── Orchestrator/
│   │   │   └── IntelligenceOrchestrator.swift
│   │   └── UI/
│   │       ├── BottomPanelItemAI.swift
│   │       ├── KitLayoutAI.swift
│   │       └── SidebarItemAI.swift
│   └── Tests/AIKitTests/
│       └── AIKitTests.swift
│
├── AnalyticsKit/
│   ├── Package.swift
│   ├── Sources/AnalyticsKit/
│   │   ├── AnalyticsKit.swift
│   │   ├── AnalyticsKitContract.swift
│   │   └── UI/
│   │       ├── BottomPanelItemAnalytics.swift
│   │       ├── KitLayoutAnalytics.swift
│   │       └── SidebarItemAnalytics.swift
│   └── Tests/AnalyticsKitTests/
│       └── AnalyticsKitTests.swift
│
├── AppIdeaKit/
│   ├── Package.swift
│   ├── README.md
│   ├── Sources/AppIdeaKit/
│   │   ├── AppIdeaKit.swift
│   │   ├── AppIdeaKitContract.swift
│   │   ├── Data/
│   │   │   └── BuiltInIdeas.swift
│   │   ├── Models/
│   │   │   ├── AppIdea.swift
│   │   │   └── KitCatalog.swift
│   │   ├── Services/
│   │   │   ├── AppGenerator.swift
│   │   │   ├── IdeaAnalyzer.swift
│   │   │   └── IdeaStore.swift
│   │   └── UI/
│   │       ├── BottomPanelItemAppIdea.swift
│   │       ├── KitLayoutAppIdea.swift
│   │       └── SidebarItemAppIdea.swift
│   └── Tests/AppIdeaKitTests/
│       └── AppIdeaKitTests.swift
│
├── AssetKit/
│   ├── Package.swift
│   ├── Sources/AssetKit/
│   │   ├── AssetKit.swift
│   │   ├── AssetKitContract.swift
│   │   └── UI/
│   │       ├── BottomPanelItemAsset.swift
│   │       ├── KitLayoutAsset.swift
│   │       └── SidebarItemAsset.swift
│   └── Tests/AssetKitTests/
│       └── AssetKitTests.swift
│
├── BridgeKit/
│   ├── Package.swift
│   ├── README.md
│   ├── Sources/BridgeKit/
│   │   ├── AutoBridge.swift
│   │   ├── BridgeExecutor.swift
│   │   ├── BridgeKit.swift
│   │   ├── BridgeKitContract.swift
│   │   ├── BridgeRegistry.swift
│   │   ├── KitDescriptors.swift
│   │   ├── KitPack.swift
│   │   └── UI/
│   │       ├── BottomPanelItemBridge.swift
│   │       ├── KitLayoutBridge.swift
│   │       └── SidebarItemBridge.swift
│   └── Tests/BridgeKitTests/
│       └── BridgeKitTests.swift

│
├── ChatKit/
│   ├── Package.swift
│   ├── Sources/ChatKit/
│   │   ├── ChatKit.swift
│   │   ├── ChatKitContract.swift
│   │   ├── ChatKitPackage.swift
│   │   ├── Models/
│   │   │   ├── ChatError.swift
│   │   │   ├── ChatFormat.swift
│   │   │   └── ChatKind.swift
│   │   ├── Services/
│   │   │   └── ChatManager.swift
│   │   ├── UI/
│   │   │   ├── BottomPanelItemChat.swift
│   │   │   ├── KitLayoutChat.swift
│   │   │   └── SidebarItemChat.swift
│   │   ├── ViewModels/
│   │   │   └── ChatViewModel.swift
│   │   └── Views/
│   │       ├── ChatBrowser.swift
│   │       └── ChatCard.swift
│   └── Tests/ChatKitTests/
│       └── ChatKitTests.swift
│
├── CollaborationKit/
│   ├── Package.swift
│   ├── Sources/CollaborationKit/
│   │   ├── CollaborationKit.swift
│   │   ├── CollaborationKitContract.swift
│   │   └── UI/
│   │       ├── BottomPanelItemCollaboration.swift
│   │       ├── KitLayoutCollaboration.swift
│   │       └── SidebarItemCollaboration.swift
│   └── Tests/CollaborationKitTests/
│       └── CollaborationKitTests.swift
│
├── CommandKit/
│   ├── Package.swift
│   ├── README.md
│   ├── Sources/CommandKit/
│   │   ├── CommandKit.swift
│   │   ├── CommandKitContract.swift
│   │   ├── CommandKitManifest.swift
│   │   ├── CommandKitPackage.swift
│   │   ├── Models/
│   │   │   ├── Command.swift
│   │   │   ├── CommandCategory.swift
│   │   │   ├── CommandError.swift
│   │   │   ├── CommandFormat.swift
│   │   │   ├── CommandKind.swift
│   │   │   ├── CommandSection.swift
│   │   │   ├── CommandType.swift
│   │   │   └── ExecutionResult.swift
│   │   ├── Services/
│   │   │   ├── CommandComposer.swift
│   │   │   ├── CommandGenerator.swift
│   │   │   ├── CommandManager.swift
│   │   │   └── CommandParser.swift
│   │   ├── UI/
│   │   │   ├── BottomPanelItemCommand.swift
│   │   │   ├── KitLayoutCommand.swift
│   │   │   └── SidebarItemCommand.swift
│   │   ├── ViewModels/
│   │   │   └── CommandViewModel.swift
│   │   └── Views/
│   │       ├── CommandBrowser.swift
│   │       ├── CommandCard.swift
│   │       ├── CommandColumn.swift
│   │       ├── CommandGallery.swift
│   │       ├── CommandIcon.swift
│   │       ├── CommandList.swift
│   │       ├── CommandRow.swift
│   │       └── CommandTable.swift
│   └── Tests/CommandKitTests/
│       └── CommandKitTests.swift
│
├── ContentHub/
│   ├── Package.swift
│   ├── README.md
│   ├── Sources/ContentHub/
│   │   ├── ContentHub.swift
│   │   ├── ContentHubContract.swift
│   │   ├── ContentStore.swift
│   │   └── UI/
│   │       ├── BottomPanelItemContentHub.swift
│   │       ├── KitLayoutContentHub.swift
│   │       └── SidebarItemContentHub.swift
│   └── Tests/ContentHubTests/
│       └── ContentHubTests.swift
│
├── CoreKit/
│   ├── Package.swift
│   ├── README.md
│   ├── Sources/CoreKit/
│   │   ├── CoreKit.swift
│   │   ├── CoreKitContract.swift
│   │   ├── Chat/
│   │   │   └── ChatActionMapping.swift
│   │   ├── CRUD/
│   │   │   └── CRUDContracts.swift
│   │   ├── Graph/
│   │   │   └── NodeGraph.swift
│   │   ├── Node/
│   │   │   └── Node.swift
│   │   └── UI/
│   │       ├── BottomPanelItemCore.swift
│   │       ├── KitLayoutCore.swift
│   │       └── SidebarItemCore.swift
│   └── Tests/CoreKitTests/
│       └── CoreKitTests.swift
