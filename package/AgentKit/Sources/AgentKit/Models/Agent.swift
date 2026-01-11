//
//  Agent.swift
//  AgentKit
//
//  Agent definitions for autonomous task execution
//

import Foundation

// MARK: - Agent Definition

public struct Agent: Identifiable, Codable, Hashable, Sendable {
    public let id: UUID
    public var name: String
    public var description: String
    public var type: AgentType
    public var status: AgentStatus
    public var capabilities: [AgentCapability]
    public var triggers: [AgentTrigger]
    public var actions: [AgentAction]
    public var configuration: AgentConfiguration
    public var createdAt: Date
    public var lastRunAt: Date?
    public var runCount: Int
    public var successCount: Int
    
    public init(
        id: UUID = UUID(),
        name: String,
        description: String = "",
        type: AgentType = .task,
        capabilities: [AgentCapability] = [],
        triggers: [AgentTrigger] = [],
        actions: [AgentAction] = []
    ) {
        self.id = id
        self.name = name
        self.description = description
        self.type = type
        self.status = .idle
        self.capabilities = capabilities
        self.triggers = triggers
        self.actions = actions
        self.configuration = AgentConfiguration()
        self.createdAt = Date()
        self.lastRunAt = nil
        self.runCount = 0
        self.successCount = 0
    }
    
    public var successRate: Double {
        runCount > 0 ? Double(successCount) / Double(runCount) : 0
    }
    
    public static func == (lhs: Agent, rhs: Agent) -> Bool {
        lhs.id == rhs.id
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

// MARK: - Agent Category

public enum AgentCategory: String, Codable, CaseIterable, Sendable {
    case all = "All"
    case automation = "Automation"
    case monitoring = "Monitoring"
    case building = "Building"
    case testing = "Testing"
    case deployment = "Deployment"
    case custom = "Custom"
    
    public var icon: String {
        switch self {
        case .all: return "square.grid.2x2"
        case .automation: return "gearshape.2"
        case .monitoring: return "gauge"
        case .building: return "hammer"
        case .testing: return "checkmark.seal"
        case .deployment: return "arrow.up.doc"
        case .custom: return "star"
        }
    }
}

// MARK: - Agent Section

public enum AgentSection: String, CaseIterable, Sendable {
    case all = "All Agents"
    case running = "Running"
    case templates = "Templates"
    case history = "History"
    
    public var icon: String {
        switch self {
        case .all: return "cpu"
        case .running: return "play.circle"
        case .templates: return "doc.on.doc"
        case .history: return "clock.arrow.circlepath"
        }
    }
}

// MARK: - Agent Type

public enum AgentType: String, Codable, CaseIterable, Identifiable, Sendable {
    case task = "Task Agent"
    case monitor = "Monitor Agent"
    case automation = "Automation Agent"
    case assistant = "Assistant Agent"
    case scheduler = "Scheduler Agent"
    case watcher = "File Watcher Agent"
    case builder = "Build Agent"
    case deployer = "Deploy Agent"
    
    public var id: String { rawValue }
    
    public var icon: String {
        switch self {
        case .task: return "checklist"
        case .monitor: return "gauge"
        case .automation: return "gearshape.2"
        case .assistant: return "person.wave.2"
        case .scheduler: return "calendar.badge.clock"
        case .watcher: return "eye"
        case .builder: return "hammer"
        case .deployer: return "arrow.up.doc"
        }
    }
    
    public var description: String {
        switch self {
        case .task: return "Executes specific tasks on demand"
        case .monitor: return "Monitors system resources and metrics"
        case .automation: return "Automates repetitive workflows"
        case .assistant: return "Provides intelligent assistance"
        case .scheduler: return "Schedules and runs timed tasks"
        case .watcher: return "Watches files for changes"
        case .builder: return "Builds and compiles projects"
        case .deployer: return "Deploys applications"
        }
    }
}

// MARK: - Agent Status

public enum AgentStatus: String, Codable, CaseIterable, Sendable {
    case idle = "Idle"
    case running = "Running"
    case paused = "Paused"
    case error = "Error"
    case disabled = "Disabled"
    
    public var icon: String {
        switch self {
        case .idle: return "circle"
        case .running: return "play.circle.fill"
        case .paused: return "pause.circle.fill"
        case .error: return "exclamationmark.circle.fill"
        case .disabled: return "xmark.circle"
        }
    }
}

// MARK: - Agent Capability

public enum AgentCapability: String, Codable, CaseIterable, Sendable {
    case executeCommands = "Execute Commands"
    case readFiles = "Read Files"
    case writeFiles = "Write Files"
    case networkAccess = "Network Access"
    case systemMonitoring = "System Monitoring"
    case processManagement = "Process Management"
    case notifications = "Send Notifications"
    case scheduling = "Task Scheduling"
    case gitOperations = "Git Operations"
    case buildOperations = "Build Operations"
    case deployOperations = "Deploy Operations"
    case databaseAccess = "Database Access"
    case aiCapabilities = "AI Capabilities"
    case codeAnalysis = "Code Analysis"
    case documentationGeneration = "Documentation Generation"
    case refactoringAssistance = "Refactoring Assistance"
}

// MARK: - Agent Trigger

public struct AgentTrigger: Identifiable, Codable, Sendable {
    public let id: UUID
    public var type: TriggerType
    public var condition: String
    public var parameters: [String: String]
    public var isEnabled: Bool
    
    public init(
        id: UUID = UUID(),
        type: TriggerType,
        condition: String,
        parameters: [String: String] = [:],
        isEnabled: Bool = true
    ) {
        self.id = id
        self.type = type
        self.condition = condition
        self.parameters = parameters
        self.isEnabled = isEnabled
    }
    
    public enum TriggerType: String, Codable, CaseIterable, Sendable {
        case manual = "Manual"
        case schedule = "Schedule"
        case fileChange = "File Change"
        case gitEvent = "Git Event"
        case webhook = "Webhook"
        case systemEvent = "System Event"
        case commandPattern = "Command Pattern"
        case errorOccurrence = "Error Occurrence"
    }
}

// MARK: - Agent Action

public struct AgentAction: Identifiable, Codable, Sendable {
    public let id: UUID
    public var name: String
    public var type: ActionType
    public var command: String
    public var parameters: [String: String]
    public var timeout: TimeInterval
    public var retryCount: Int
    public var continueOnError: Bool
    public var order: Int
    
    public init(
        id: UUID = UUID(),
        name: String,
        type: ActionType,
        command: String,
        parameters: [String: String] = [:],
        timeout: TimeInterval = 60,
        retryCount: Int = 0,
        continueOnError: Bool = false,
        order: Int = 0
    ) {
        self.id = id
        self.name = name
        self.type = type
        self.command = command
        self.parameters = parameters
        self.timeout = timeout
        self.retryCount = retryCount
        self.continueOnError = continueOnError
        self.order = order
    }
    
    public enum ActionType: String, Codable, CaseIterable, Sendable {
        case shellCommand = "Shell Command"
        case workflow = "Run Workflow"
        case notification = "Send Notification"
        case httpRequest = "HTTP Request"
        case fileOperation = "File Operation"
        case gitCommand = "Git Command"
        case buildCommand = "Build Command"
        case script = "Run Script"
        case conditional = "Conditional"
        case loop = "Loop"
        case aiAnalysis = "AI Analysis"
        case aiDocumentation = "AI Documentation"
        case aiRefactoring = "AI Refactoring"
        case aiCodeGeneration = "AI Code Generation"
        case aiWorkflowCreation = "AI Workflow Creation"
    }
}

// MARK: - Agent Configuration

public struct AgentConfiguration: Codable, Sendable {
    public var maxConcurrentRuns: Int
    public var defaultTimeout: TimeInterval
    public var logLevel: LogLevel
    public var notifyOnSuccess: Bool
    public var notifyOnFailure: Bool
    public var workingDirectory: String?
    public var environmentVariables: [String: String]
    public var schedule: AgentSchedule?
    
    public init(
        maxConcurrentRuns: Int = 1,
        defaultTimeout: TimeInterval = 300,
        logLevel: LogLevel = .info,
        notifyOnSuccess: Bool = false,
        notifyOnFailure: Bool = true,
        workingDirectory: String? = nil,
        environmentVariables: [String: String] = [:],
        schedule: AgentSchedule? = nil
    ) {
        self.maxConcurrentRuns = maxConcurrentRuns
        self.defaultTimeout = defaultTimeout
        self.logLevel = logLevel
        self.notifyOnSuccess = notifyOnSuccess
        self.notifyOnFailure = notifyOnFailure
        self.workingDirectory = workingDirectory
        self.environmentVariables = environmentVariables
        self.schedule = schedule
    }
    
    public enum LogLevel: String, Codable, CaseIterable, Sendable {
        case debug = "Debug"
        case info = "Info"
        case warning = "Warning"
        case error = "Error"
    }
}

// MARK: - Agent Schedule

public struct AgentSchedule: Codable, Sendable {
    public var type: ScheduleType
    public var interval: TimeInterval?
    public var cronExpression: String?
    public var specificTimes: [Date]?
    public var daysOfWeek: [Int]?
    public var timezone: String
    
    public init(
        type: ScheduleType,
        interval: TimeInterval? = nil,
        cronExpression: String? = nil,
        specificTimes: [Date]? = nil,
        daysOfWeek: [Int]? = nil,
        timezone: String = TimeZone.current.identifier
    ) {
        self.type = type
        self.interval = interval
        self.cronExpression = cronExpression
        self.specificTimes = specificTimes
        self.daysOfWeek = daysOfWeek
        self.timezone = timezone
    }
    
    public enum ScheduleType: String, Codable, CaseIterable, Sendable {
        case interval = "Interval"
        case cron = "Cron Expression"
        case daily = "Daily"
        case weekly = "Weekly"
        case monthly = "Monthly"
        case custom = "Custom"
    }
}
