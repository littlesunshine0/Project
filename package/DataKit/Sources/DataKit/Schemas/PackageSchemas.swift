//
//  PackageSchemas.swift
//  DataKit
//
//  Canonical JSON schema definitions for the Package Operating System
//  Every package MUST conform to these schemas
//

import Foundation

// MARK: - 1. Package Manifest Schema
// Note: PackageManifest is defined in Models/Protocol/PackageManifest.swift
// Note: PackageCategory is defined in Models/Identity/PackageCategory.swift
// Note: Platform is defined in Models/Distribution/CompatibilityMatrix.swift
// This file uses those canonical types

/// Extended manifest for schema validation (wraps the canonical PackageManifest)
public struct PackageManifestSchema: Codable, Sendable {
    public let id: String
    public let name: String
    public let version: String
    public let category: PackageCategory
    public let platforms: [Platform]
    public let dependencies: [String]
    public let author: String?
    public let license: String?
    public let repository: String?
    
    public init(
        id: String,
        name: String,
        version: String = "1.0.0",
        category: PackageCategory,
        platforms: [Platform] = [.macOS, .iOS, .visionOS],
        dependencies: [String] = [],
        author: String? = nil,
        license: String? = nil,
        repository: String? = nil
    ) {
        self.id = id
        self.name = name
        self.version = version
        self.category = category
        self.platforms = platforms
        self.dependencies = dependencies
        self.author = author
        self.license = license
        self.repository = repository
    }
}

// MARK: - 2. Package Capabilities Schema

public struct PackageCapabilities: Codable, Sendable {
    public let nodes: [String]
    public let actions: [String]
    public let agents: [String]
    public let commands: [String]
    public let ui: [UICapability]
    public let ml: [MLCapability]
    
    public init(
        nodes: [String] = [],
        actions: [String] = [],
        agents: [String] = [],
        commands: [String] = [],
        ui: [UICapability] = [],
        ml: [MLCapability] = []
    ) {
        self.nodes = nodes
        self.actions = actions
        self.agents = agents
        self.commands = commands
        self.ui = ui
        self.ml = ml
    }
    
    public enum UICapability: String, Codable, Sendable, CaseIterable {
        case browser, list, editor, timeline, gallery, card, table, graph, canvas, settings
    }
    
    public enum MLCapability: String, Codable, Sendable, CaseIterable {
        case prediction, classification, optimization, generation, embedding, search, recommendation
    }
}

// MARK: - 3. Package State Schema

public struct PackageStateSchema: Codable, Sendable {
    public let states: [StateDefinition]
    public let events: [EventDefinition]
    public let transitions: [StateTransition]
    
    public init(
        states: [StateDefinition] = StateDefinition.defaults,
        events: [EventDefinition] = EventDefinition.defaults,
        transitions: [StateTransition] = []
    ) {
        self.states = states
        self.events = events
        self.transitions = transitions
    }
    
    public struct StateDefinition: Codable, Sendable {
        public let id: String
        public let name: String
        public let icon: String
        public let color: String
        
        public init(id: String, name: String, icon: String, color: String) {
            self.id = id
            self.name = name
            self.icon = icon
            self.color = color
        }
        
        public static let defaults: [StateDefinition] = [
            StateDefinition(id: "idle", name: "Idle", icon: "circle", color: "gray"),
            StateDefinition(id: "loading", name: "Loading", icon: "arrow.clockwise", color: "blue"),
            StateDefinition(id: "running", name: "Running", icon: "play.fill", color: "green"),
            StateDefinition(id: "paused", name: "Paused", icon: "pause.fill", color: "yellow"),
            StateDefinition(id: "error", name: "Error", icon: "exclamationmark.triangle", color: "red"),
            StateDefinition(id: "completed", name: "Completed", icon: "checkmark.circle", color: "green")
        ]
    }
    
    public struct EventDefinition: Codable, Sendable {
        public let id: String
        public let name: String
        public let severity: Severity
        
        public init(id: String, name: String, severity: Severity) {
            self.id = id
            self.name = name
            self.severity = severity
        }
        
        public enum Severity: String, Codable, Sendable {
            case info, warning, error, success
        }
        
        public static let defaults: [EventDefinition] = [
            EventDefinition(id: "started", name: "Started", severity: .info),
            EventDefinition(id: "progress", name: "Progress", severity: .info),
            EventDefinition(id: "warning", name: "Warning", severity: .warning),
            EventDefinition(id: "success", name: "Success", severity: .success),
            EventDefinition(id: "failure", name: "Failure", severity: .error)
        ]
    }
    
    public struct StateTransition: Codable, Sendable {
        public let from: String
        public let to: String
        public let event: String
        
        public init(from: String, to: String, event: String) {
            self.from = from
            self.to = to
            self.event = event
        }
    }
}

// MARK: - 4. Package Actions Schema

public struct PackageActions: Codable, Sendable {
    public let actions: [ActionDefinition]
    
    public init(actions: [ActionDefinition] = []) {
        self.actions = actions
    }
    
    public struct ActionDefinition: Codable, Sendable, Identifiable {
        public let id: String
        public let name: String
        public let description: String
        public let icon: String
        public let input: [ParameterDefinition]
        public let output: String
        public let shortcut: String?
        public let category: ActionCategory
        
        public init(
            id: String,
            name: String,
            description: String,
            icon: String,
            input: [ParameterDefinition] = [],
            output: String,
            shortcut: String? = nil,
            category: ActionCategory = .general
        ) {
            self.id = id
            self.name = name
            self.description = description
            self.icon = icon
            self.input = input
            self.output = output
            self.shortcut = shortcut
            self.category = category
        }
        
        public enum ActionCategory: String, Codable, Sendable, CaseIterable {
            case create, read, update, delete, execute, navigate, export, share, general
        }
    }
    
    public struct ParameterDefinition: Codable, Sendable {
        public let name: String
        public let type: ParameterType
        public let required: Bool
        public let defaultValue: String?
        
        public init(name: String, type: ParameterType, required: Bool = true, defaultValue: String? = nil) {
            self.name = name
            self.type = type
            self.required = required
            self.defaultValue = defaultValue
        }
        
        public enum ParameterType: String, Codable, Sendable {
            case string, int, bool, date, file, node, array, object
        }
    }
}

// MARK: - 5. Package UI Schema

public struct PackageUI: Codable, Sendable {
    public let menus: [MenuDefinition]
    public let views: [ViewDefinition]
    public let animations: [AnimationDefinition]
    public let icons: [IconDefinition]
    public let colorScheme: ColorScheme
    public let accessibility: AccessibilityConfig
    
    public init(
        menus: [MenuDefinition] = [],
        views: [ViewDefinition] = [],
        animations: [AnimationDefinition] = AnimationDefinition.defaults,
        icons: [IconDefinition] = [],
        colorScheme: ColorScheme = .adaptive,
        accessibility: AccessibilityConfig = AccessibilityConfig()
    ) {
        self.menus = menus
        self.views = views
        self.animations = animations
        self.icons = icons
        self.colorScheme = colorScheme
        self.accessibility = accessibility
    }
    
    public struct MenuDefinition: Codable, Sendable {
        public let id: String
        public let type: MenuType
        public let items: [MenuItemDefinition]
        
        public init(id: String, type: MenuType, items: [MenuItemDefinition]) {
            self.id = id
            self.type = type
            self.items = items
        }
        
        public enum MenuType: String, Codable, Sendable {
            case main, context, help, toolbar, sidebar
        }
    }
    
    public struct MenuItemDefinition: Codable, Sendable {
        public let id: String
        public let title: String
        public let icon: String?
        public let action: String
        public let shortcut: String?
        public let children: [MenuItemDefinition]?
        
        public init(id: String, title: String, icon: String? = nil, action: String, shortcut: String? = nil, children: [MenuItemDefinition]? = nil) {
            self.id = id
            self.title = title
            self.icon = icon
            self.action = action
            self.shortcut = shortcut
            self.children = children
        }
    }
    
    public struct ViewDefinition: Codable, Sendable {
        public let id: String
        public let type: ViewType
        public let title: String
        public let icon: String
        
        public init(id: String, type: ViewType, title: String, icon: String) {
            self.id = id
            self.type = type
            self.title = title
            self.icon = icon
        }
        
        public enum ViewType: String, Codable, Sendable {
            case list, grid, table, editor, timeline, canvas, browser, detail, settings
        }
    }
    
    public struct AnimationDefinition: Codable, Sendable {
        public let id: String
        public let type: AnimationType
        public let duration: Double
        public let curve: AnimationCurve
        
        public init(id: String, type: AnimationType, duration: Double = 0.3, curve: AnimationCurve = .easeInOut) {
            self.id = id
            self.type = type
            self.duration = duration
            self.curve = curve
        }
        
        public enum AnimationType: String, Codable, Sendable {
            case fade, slide, scale, progress, success, error, loading
        }
        
        public enum AnimationCurve: String, Codable, Sendable {
            case linear, easeIn, easeOut, easeInOut, spring
        }
        
        public static let defaults: [AnimationDefinition] = [
            AnimationDefinition(id: "fade", type: .fade),
            AnimationDefinition(id: "slide", type: .slide),
            AnimationDefinition(id: "progress", type: .progress, duration: 0.5),
            AnimationDefinition(id: "success", type: .success, curve: .spring),
            AnimationDefinition(id: "error", type: .error)
        ]
    }
    
    public struct IconDefinition: Codable, Sendable {
        public let id: String
        public let systemName: String
        public let fallback: String?
        
        public init(id: String, systemName: String, fallback: String? = nil) {
            self.id = id
            self.systemName = systemName
            self.fallback = fallback
        }
    }
    
    public enum ColorScheme: String, Codable, Sendable {
        case light, dark, adaptive
    }
    
    public struct AccessibilityConfig: Codable, Sendable {
        public let voiceOver: Bool
        public let reduceMotion: Bool
        public let highContrast: Bool
        public let dynamicType: Bool
        
        public init(voiceOver: Bool = true, reduceMotion: Bool = true, highContrast: Bool = true, dynamicType: Bool = true) {
            self.voiceOver = voiceOver
            self.reduceMotion = reduceMotion
            self.highContrast = highContrast
            self.dynamicType = dynamicType
        }
    }
}

// MARK: - 6. Package Agents Schema

public struct PackageAgents: Codable, Sendable {
    public let agents: [AgentDefinition]
    
    public init(agents: [AgentDefinition] = []) {
        self.agents = agents
    }
    
    public struct AgentDefinition: Codable, Sendable, Identifiable {
        public let id: String
        public let name: String
        public let description: String
        public let triggers: [TriggerDefinition]
        public let actions: [String]
        public let config: AgentConfig
        
        public init(id: String, name: String, description: String, triggers: [TriggerDefinition], actions: [String], config: AgentConfig = AgentConfig()) {
            self.id = id
            self.name = name
            self.description = description
            self.triggers = triggers
            self.actions = actions
            self.config = config
        }
    }
    
    public struct TriggerDefinition: Codable, Sendable {
        public let type: TriggerType
        public let condition: String?
        
        public init(type: TriggerType, condition: String? = nil) {
            self.type = type
            self.condition = condition
        }
        
        public enum TriggerType: String, Codable, Sendable {
            case event, schedule, manual, fileChange, stateChange, command
        }
    }
    
    public struct AgentConfig: Codable, Sendable {
        public let autoStart: Bool
        public let priority: Priority
        public let maxConcurrent: Int
        
        public init(autoStart: Bool = false, priority: Priority = .normal, maxConcurrent: Int = 1) {
            self.autoStart = autoStart
            self.priority = priority
            self.maxConcurrent = maxConcurrent
        }
        
        public enum Priority: String, Codable, Sendable {
            case low, normal, high, critical
        }
    }
}

// MARK: - 7. Package Workflows Schema

public struct PackageWorkflows: Codable, Sendable {
    public let workflows: [WorkflowDefinition]
    
    public init(workflows: [WorkflowDefinition] = []) {
        self.workflows = workflows
    }
    
    public struct WorkflowDefinition: Codable, Sendable, Identifiable {
        public let id: String
        public let name: String
        public let description: String
        public let steps: [StepDefinition]
        public let triggers: [String]
        
        public init(id: String, name: String, description: String, steps: [StepDefinition], triggers: [String] = []) {
            self.id = id
            self.name = name
            self.description = description
            self.steps = steps
            self.triggers = triggers
        }
    }
    
    public struct StepDefinition: Codable, Sendable {
        public let id: String
        public let action: String
        public let input: [String: String]?
        public let condition: String?
        
        public init(id: String, action: String, input: [String: String]? = nil, condition: String? = nil) {
            self.id = id
            self.action = action
            self.input = input
            self.condition = condition
        }
    }
}

// MARK: - Complete Package Contract

public struct PackageContract: Codable, Sendable {
    public let manifest: PackageManifestSchema
    public let capabilities: PackageCapabilities
    public let state: PackageStateSchema
    public let actions: PackageActions
    public let ui: PackageUI
    public let agents: PackageAgents
    public let workflows: PackageWorkflows
    
    public init(
        manifest: PackageManifestSchema,
        capabilities: PackageCapabilities = PackageCapabilities(),
        state: PackageStateSchema = PackageStateSchema(),
        actions: PackageActions = PackageActions(),
        ui: PackageUI = PackageUI(),
        agents: PackageAgents = PackageAgents(),
        workflows: PackageWorkflows = PackageWorkflows()
    ) {
        self.manifest = manifest
        self.capabilities = capabilities
        self.state = state
        self.actions = actions
        self.ui = ui
        self.agents = agents
        self.workflows = workflows
    }
}
