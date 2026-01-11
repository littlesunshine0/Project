//
//  AppIdeaKit.swift
//  AppIdeaKit - App Idea Management & Generation System
//
//  Store app ideas with rich metadata, analyze with ML,
//  and automatically generate apps using the Kit ecosystem.
//

import Foundation

// MARK: - AppIdeaKit

public actor AppIdeaKit {
    public static let shared = AppIdeaKit()
    
    private init() {}
    
    // MARK: - Idea Management
    
    /// Create a new app idea with automatic analysis
    public func createIdea(
        name: String,
        description: String,
        category: AppCategory,
        kind: AppKind = .standalone,
        type: AppType = .utility
    ) async -> AppIdea {
        var idea = AppIdea(
            name: name,
            description: description,
            category: category,
            kind: kind,
            type: type
        )
        
        // Enrich with ML analysis
        idea = await IdeaAnalyzer.shared.enrichIdea(idea)
        
        // Save to store
        return await IdeaStore.shared.save(idea)
    }
    
    /// Get an idea by ID
    public func getIdea(_ id: String) async -> AppIdea? {
        await IdeaStore.shared.get(id)
    }
    
    /// Update an existing idea
    public func updateIdea(_ idea: AppIdea) async -> AppIdea {
        let enriched = await IdeaAnalyzer.shared.enrichIdea(idea)
        return await IdeaStore.shared.save(enriched)
    }
    
    /// Delete an idea
    public func deleteIdea(_ id: String) async {
        await IdeaStore.shared.delete(id)
    }
    
    /// Get all ideas
    public func allIdeas() async -> [AppIdea] {
        await IdeaStore.shared.all()
    }
    
    // MARK: - Queries
    
    /// Search ideas by query
    public func search(query: String) async -> [AppIdea] {
        await IdeaStore.shared.search(query: query)
    }
    
    /// Get ideas by category
    public func ideas(category: AppCategory) async -> [AppIdea] {
        await IdeaStore.shared.byCategory(category)
    }
    
    /// Get ideas by kind
    public func ideas(kind: AppKind) async -> [AppIdea] {
        await IdeaStore.shared.byKind(kind)
    }
    
    /// Get ideas by status
    public func ideas(status: IdeaStatus) async -> [AppIdea] {
        await IdeaStore.shared.byStatus(status)
    }
    
    // MARK: - Generation
    
    /// Generate an app from an idea
    public func generateApp(from ideaId: String) async -> GenerationResult? {
        guard let idea = await IdeaStore.shared.get(ideaId) else { return nil }
        
        // Update status
        var updatedIdea = idea
        updatedIdea.status = .inProgress
        _ = await IdeaStore.shared.save(updatedIdea)
        
        // Generate
        let result = await AppGenerator.shared.generate(from: idea)
        
        // Update status to generated
        updatedIdea.status = .generated
        _ = await IdeaStore.shared.save(updatedIdea)
        
        return result
    }
    
    /// Generate app directly from idea object
    public func generateApp(from idea: AppIdea) async -> GenerationResult {
        await AppGenerator.shared.generate(from: idea)
    }
    
    // MARK: - Kit Catalog
    
    /// Get all available kits
    public func availableKits() async -> [KitDefinition] {
        await KitCatalog.shared.all()
    }
    
    /// Get kits that auto-attach to new projects
    public func autoAttachKits() async -> [KitDefinition] {
        await KitCatalog.shared.autoAttachKits()
    }
    
    /// Get kits by category
    public func kits(category: KitCategory) async -> [KitDefinition] {
        await KitCatalog.shared.byCategory(category)
    }
    
    /// Suggest kits for an idea
    public func suggestKits(for idea: AppIdea) async -> [String] {
        let analysis = await IdeaAnalyzer.shared.analyze(idea)
        return analysis.suggestedKits
    }
    
    // MARK: - Statistics
    
    /// Get idea statistics
    public func stats() async -> IdeaStats {
        await IdeaStore.shared.stats
    }
    
    // MARK: - Bulk Operations
    
    /// Import ideas from JSON
    public func importIdeas(from json: Data) async throws -> [AppIdea] {
        let ideas = try JSONDecoder().decode([AppIdea].self, from: json)
        var saved: [AppIdea] = []
        for idea in ideas {
            let enriched = await IdeaAnalyzer.shared.enrichIdea(idea)
            saved.append(await IdeaStore.shared.save(enriched))
        }
        return saved
    }
    
    /// Export ideas to JSON
    public func exportIdeas() async throws -> Data {
        let ideas = await IdeaStore.shared.all()
        return try JSONEncoder().encode(ideas)
    }
}

// MARK: - Convenience Extensions

extension AppIdeaKit {
    
    /// Quick create from just name and description (auto-detects category)
    public func quickCreate(name: String, description: String) async -> AppIdea {
        let category = detectCategory(from: description)
        let kind = detectKind(from: description)
        let type = detectType(from: description)
        
        return await createIdea(
            name: name,
            description: description,
            category: category,
            kind: kind,
            type: type
        )
    }
    
    private func detectCategory(from text: String) -> AppCategory {
        let lowercased = text.lowercased()
        
        if lowercased.contains("ai") || lowercased.contains("ml") || lowercased.contains("machine learning") {
            return .aiFirst
        }
        if lowercased.contains("automat") {
            return .automation
        }
        if lowercased.contains("cli") || lowercased.contains("command") {
            return .cliTool
        }
        if lowercased.contains("develop") || lowercased.contains("code") {
            return .developerTool
        }
        if lowercased.contains("document") {
            return .documentation
        }
        if lowercased.contains("learn") || lowercased.contains("skill") {
            return .learning
        }
        if lowercased.contains("product") || lowercased.contains("task") {
            return .productivity
        }
        if lowercased.contains("business") || lowercased.contains("startup") {
            return .business
        }
        
        return .productivity
    }
    
    private func detectKind(from text: String) -> AppKind {
        let lowercased = text.lowercased()
        
        if lowercased.contains("cli") || lowercased.contains("command line") {
            return .cli
        }
        if lowercased.contains("package") || lowercased.contains("library") {
            return .package
        }
        if lowercased.contains("service") || lowercased.contains("background") {
            return .service
        }
        if lowercased.contains("plugin") || lowercased.contains("extension") {
            return .plugin
        }
        if lowercased.contains("api") {
            return .api
        }
        if lowercased.contains("framework") {
            return .framework
        }
        
        return .standalone
    }
    
    private func detectType(from text: String) -> AppType {
        let lowercased = text.lowercased()
        
        if lowercased.contains("generat") {
            return .generator
        }
        if lowercased.contains("analyz") {
            return .analyzer
        }
        if lowercased.contains("convert") {
            return .converter
        }
        if lowercased.contains("manag") {
            return .manager
        }
        if lowercased.contains("track") {
            return .tracker
        }
        if lowercased.contains("build") {
            return .builder
        }
        if lowercased.contains("assist") || lowercased.contains("help") {
            return .assistant
        }
        if lowercased.contains("dashboard") {
            return .dashboard
        }
        if lowercased.contains("engine") {
            return .engine
        }
        if lowercased.contains("orchestrat") {
            return .orchestrator
        }
        
        return .utility
    }
}
