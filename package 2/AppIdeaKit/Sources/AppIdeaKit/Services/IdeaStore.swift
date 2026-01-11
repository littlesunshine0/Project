//
//  IdeaStore.swift
//  AppIdeaKit - Persistent Idea Storage
//

import Foundation

// MARK: - Idea Store

public actor IdeaStore {
    public static let shared = IdeaStore()
    
    private var ideas: [String: AppIdea] = [:]
    private var categoryIndex: [AppCategory: Set<String>] = [:]
    private var kindIndex: [AppKind: Set<String>] = [:]
    private var tagIndex: [String: Set<String>] = [:]
    private var statusIndex: [IdeaStatus: Set<String>] = [:]
    
    private let storageURL: URL
    
    private init() {
        let appSupport = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first!
        let dir = appSupport.appendingPathComponent("FlowKit/AppIdeaKit", isDirectory: true)
        try? FileManager.default.createDirectory(at: dir, withIntermediateDirectories: true)
        self.storageURL = dir.appendingPathComponent("ideas.json")
        
        Task { await load() }
    }
    
    // MARK: - CRUD Operations
    
    public func save(_ idea: AppIdea) -> AppIdea {
        var updated = idea
        updated.updatedAt = Date()
        ideas[idea.id] = updated
        updateIndices(for: updated)
        Task { await persist() }
        return updated
    }
    
    public func get(_ id: String) -> AppIdea? {
        ideas[id]
    }
    
    public func delete(_ id: String) {
        if let idea = ideas[id] {
            removeFromIndices(idea)
            ideas.removeValue(forKey: id)
            Task { await persist() }
        }
    }
    
    public func all() -> [AppIdea] {
        Array(ideas.values).sorted { $0.createdAt > $1.createdAt }
    }
    
    // MARK: - Queries
    
    public func byCategory(_ category: AppCategory) -> [AppIdea] {
        (categoryIndex[category] ?? []).compactMap { ideas[$0] }
    }
    
    public func byKind(_ kind: AppKind) -> [AppIdea] {
        (kindIndex[kind] ?? []).compactMap { ideas[$0] }
    }
    
    public func byTag(_ tag: String) -> [AppIdea] {
        (tagIndex[tag.lowercased()] ?? []).compactMap { ideas[$0] }
    }
    
    public func byStatus(_ status: IdeaStatus) -> [AppIdea] {
        (statusIndex[status] ?? []).compactMap { ideas[$0] }
    }
    
    public func search(query: String) -> [AppIdea] {
        let lowercased = query.lowercased()
        return ideas.values.filter { idea in
            idea.name.lowercased().contains(lowercased) ||
            idea.description.lowercased().contains(lowercased) ||
            idea.tags.contains { $0.lowercased().contains(lowercased) }
        }
    }
    
    // MARK: - Statistics
    
    public var stats: IdeaStats {
        IdeaStats(
            totalIdeas: ideas.count,
            byCategory: Dictionary(grouping: ideas.values, by: { $0.category }).mapValues { $0.count },
            byKind: Dictionary(grouping: ideas.values, by: { $0.kind }).mapValues { $0.count },
            byStatus: Dictionary(grouping: ideas.values, by: { $0.status }).mapValues { $0.count },
            byComplexity: Dictionary(grouping: ideas.values, by: { $0.complexity }).mapValues { $0.count }
        )
    }
    
    // MARK: - Index Management
    
    private func updateIndices(for idea: AppIdea) {
        categoryIndex[idea.category, default: []].insert(idea.id)
        kindIndex[idea.kind, default: []].insert(idea.id)
        statusIndex[idea.status, default: []].insert(idea.id)
        for tag in idea.tags {
            tagIndex[tag.lowercased(), default: []].insert(idea.id)
        }
    }
    
    private func removeFromIndices(_ idea: AppIdea) {
        categoryIndex[idea.category]?.remove(idea.id)
        kindIndex[idea.kind]?.remove(idea.id)
        statusIndex[idea.status]?.remove(idea.id)
        for tag in idea.tags {
            tagIndex[tag.lowercased()]?.remove(idea.id)
        }
    }
    
    // MARK: - Persistence
    
    private func persist() {
        let data = Array(ideas.values)
        if let encoded = try? JSONEncoder().encode(data) {
            try? encoded.write(to: storageURL)
        }
    }
    
    private func load() {
        guard let data = try? Data(contentsOf: storageURL),
              let loaded = try? JSONDecoder().decode([AppIdea].self, from: data) else { return }
        
        for idea in loaded {
            ideas[idea.id] = idea
            updateIndices(for: idea)
        }
    }
}

// MARK: - Stats

public struct IdeaStats: Sendable {
    public let totalIdeas: Int
    public let byCategory: [AppCategory: Int]
    public let byKind: [AppKind: Int]
    public let byStatus: [IdeaStatus: Int]
    public let byComplexity: [Complexity: Int]
}
