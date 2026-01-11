//
//  ContentHub.swift
//  ContentHub
//
//  Centralized Content Storage & Cross-Project Sharing System
//
//  Architecture:
//  - All projects store generated content in a unified hub
//  - Content is indexed for ML training and user search
//  - Automatic content generation when packages are attached
//  - Cross-project content discovery and reuse
//

import Foundation

/// ContentHub - Centralized Content Storage System
public struct ContentHub {
    public static let version = "1.0.0"
    public static let identifier = "com.flowkit.contenthub"
    
    /// Default hub location
    public static var defaultHubPath: URL {
        FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask)[0]
            .appendingPathComponent("FlowKit/ContentHub")
    }
    
    public init() {}
    
    /// Store content from a project
    public static func store(_ content: GeneratedContent) async throws {
        try await ContentStore.shared.store(content)
    }
    
    /// Search all content across projects
    public static func search(_ query: String, filters: ContentFilters = ContentFilters()) async -> [ContentResult] {
        await ContentStore.shared.search(query: query, filters: filters)
    }
    
    /// Get all content for a project
    public static func getProjectContent(projectId: String) async -> [GeneratedContent] {
        await ContentStore.shared.getByProject(projectId)
    }
    
    /// Get content for ML training
    public static func getMLTrainingData(type: ContentType? = nil) async -> [MLTrainingRecord] {
        await ContentStore.shared.getMLData(type: type)
    }
    
    /// Register a project for automatic content generation
    public static func registerProject(_ project: ProjectRegistration) async {
        await ContentStore.shared.registerProject(project)
    }
    
    /// Get hub statistics
    public static func getStats() async -> HubStatistics {
        await ContentStore.shared.getStats()
    }
}

// MARK: - Content Types

public enum ContentType: String, Codable, CaseIterable, Sendable {
    // Documentation
    case readme, design, requirements, tasks, specs, changelog, api
    // Configuration
    case commands, workflows, actions, scripts, agents
    // Architecture
    case blueprint, dataModel, integration
    // Planning
    case roadmap, milestone, useCase
    
    public var fileExtension: String {
        switch self {
        case .readme, .design, .requirements, .tasks, .specs, .changelog, .api, .blueprint, .dataModel, .integration, .roadmap, .milestone, .useCase:
            return "md"
        case .commands, .workflows, .actions, .scripts, .agents:
            return "json"
        }
    }
    
    public var category: ContentCategory {
        switch self {
        case .readme, .design, .requirements, .tasks, .specs, .changelog, .api:
            return .documentation
        case .commands, .workflows, .actions, .scripts, .agents:
            return .configuration
        case .blueprint, .dataModel, .integration:
            return .architecture
        case .roadmap, .milestone, .useCase:
            return .planning
        }
    }
}

public enum ContentCategory: String, Codable, CaseIterable, Sendable {
    case documentation, configuration, architecture, planning
}

// MARK: - Generated Content

public struct GeneratedContent: Identifiable, Codable, Sendable {
    public let id: UUID
    public let projectId: String
    public let projectName: String
    public let type: ContentType
    public let title: String
    public let content: String
    public let metadata: ContentMetadata
    public let generatedAt: Date
    public let generatedBy: String // Kit that generated it
    public let version: Int
    
    public init(
        id: UUID = UUID(),
        projectId: String,
        projectName: String,
        type: ContentType,
        title: String,
        content: String,
        metadata: ContentMetadata = ContentMetadata(),
        generatedAt: Date = Date(),
        generatedBy: String,
        version: Int = 1
    ) {
        self.id = id
        self.projectId = projectId
        self.projectName = projectName
        self.type = type
        self.title = title
        self.content = content
        self.metadata = metadata
        self.generatedAt = generatedAt
        self.generatedBy = generatedBy
        self.version = version
    }
    
    public var fileName: String {
        "\(type.rawValue).\(type.fileExtension)"
    }
}

public struct ContentMetadata: Codable, Sendable {
    public var tags: [String]
    public var dependencies: [String]
    public var relatedContent: [UUID]
    public var wordCount: Int
    public var codeBlockCount: Int
    public var linkCount: Int
    public var customFields: [String: String]
    
    public init(
        tags: [String] = [],
        dependencies: [String] = [],
        relatedContent: [UUID] = [],
        wordCount: Int = 0,
        codeBlockCount: Int = 0,
        linkCount: Int = 0,
        customFields: [String: String] = [:]
    ) {
        self.tags = tags
        self.dependencies = dependencies
        self.relatedContent = relatedContent
        self.wordCount = wordCount
        self.codeBlockCount = codeBlockCount
        self.linkCount = linkCount
        self.customFields = customFields
    }
}

// MARK: - Content Filters

public struct ContentFilters: Sendable {
    public var types: [ContentType]?
    public var categories: [ContentCategory]?
    public var projectIds: [String]?
    public var tags: [String]?
    public var generatedBy: [String]?
    public var dateRange: (start: Date, end: Date)?
    public var maxResults: Int
    
    public init(
        types: [ContentType]? = nil,
        categories: [ContentCategory]? = nil,
        projectIds: [String]? = nil,
        tags: [String]? = nil,
        generatedBy: [String]? = nil,
        dateRange: (start: Date, end: Date)? = nil,
        maxResults: Int = 100
    ) {
        self.types = types
        self.categories = categories
        self.projectIds = projectIds
        self.tags = tags
        self.generatedBy = generatedBy
        self.dateRange = dateRange
        self.maxResults = maxResults
    }
}

// MARK: - Content Result

public struct ContentResult: Identifiable, Sendable {
    public let id: UUID
    public let content: GeneratedContent
    public let relevance: Double
    public let highlights: [String]
    
    public init(content: GeneratedContent, relevance: Double, highlights: [String] = []) {
        self.id = content.id
        self.content = content
        self.relevance = relevance
        self.highlights = highlights
    }
}

// MARK: - ML Training Record

public struct MLTrainingRecord: Codable, Sendable {
    public let contentId: UUID
    public let type: ContentType
    public let projectName: String
    public let title: String
    public let content: String
    public let tags: [String]
    public let embedding: [Float]?
    
    public init(from content: GeneratedContent, embedding: [Float]? = nil) {
        self.contentId = content.id
        self.type = content.type
        self.projectName = content.projectName
        self.title = content.title
        self.content = content.content
        self.tags = content.metadata.tags
        self.embedding = embedding
    }
}

// MARK: - Project Registration

public struct ProjectRegistration: Codable, Sendable {
    public let projectId: String
    public let projectName: String
    public let projectPath: String
    public let attachedKits: [String]
    public let autoGenerateTypes: [ContentType]
    public let registeredAt: Date
    
    public init(
        projectId: String,
        projectName: String,
        projectPath: String,
        attachedKits: [String] = [],
        autoGenerateTypes: [ContentType] = ContentType.allCases,
        registeredAt: Date = Date()
    ) {
        self.projectId = projectId
        self.projectName = projectName
        self.projectPath = projectPath
        self.attachedKits = attachedKits
        self.autoGenerateTypes = autoGenerateTypes
        self.registeredAt = registeredAt
    }
}

// MARK: - Hub Statistics

public struct HubStatistics: Sendable {
    public let totalContent: Int
    public let totalProjects: Int
    public let contentByType: [ContentType: Int]
    public let contentByCategory: [ContentCategory: Int]
    public let totalSize: Int64
    public let lastUpdated: Date
    
    public init(
        totalContent: Int = 0,
        totalProjects: Int = 0,
        contentByType: [ContentType: Int] = [:],
        contentByCategory: [ContentCategory: Int] = [:],
        totalSize: Int64 = 0,
        lastUpdated: Date = Date()
    ) {
        self.totalContent = totalContent
        self.totalProjects = totalProjects
        self.contentByType = contentByType
        self.contentByCategory = contentByCategory
        self.totalSize = totalSize
        self.lastUpdated = lastUpdated
    }
}
