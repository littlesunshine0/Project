//
//  ContentStore.swift
//  ContentHub
//
//  Persistent Storage for Cross-Project Content
//

import Foundation

/// ContentStore - Manages persistent storage of all generated content
public actor ContentStore {
    public static let shared = ContentStore()
    
    private var content: [UUID: GeneratedContent] = [:]
    private var projectIndex: [String: Set<UUID>] = [:]
    private var typeIndex: [ContentType: Set<UUID>] = [:]
    private var tagIndex: [String: Set<UUID>] = [:]
    private var registeredProjects: [String: ProjectRegistration] = [:]
    
    private let hubPath: URL
    
    private init() {
        self.hubPath = ContentHub.defaultHubPath
        Task { await loadFromDisk() }
    }
    
    // MARK: - Storage Operations
    
    public func store(_ newContent: GeneratedContent) throws {
        // Store in memory
        content[newContent.id] = newContent
        
        // Update indices
        projectIndex[newContent.projectId, default: []].insert(newContent.id)
        typeIndex[newContent.type, default: []].insert(newContent.id)
        for tag in newContent.metadata.tags {
            tagIndex[tag.lowercased(), default: []].insert(newContent.id)
        }
        
        // Persist to disk
        Task { await saveToDisk() }
    }
    
    public func getByProject(_ projectId: String) -> [GeneratedContent] {
        guard let ids = projectIndex[projectId] else { return [] }
        return ids.compactMap { content[$0] }
    }
    
    public func getByType(_ type: ContentType) -> [GeneratedContent] {
        guard let ids = typeIndex[type] else { return [] }
        return ids.compactMap { content[$0] }
    }
    
    // MARK: - Search
    
    public func search(query: String, filters: ContentFilters) -> [ContentResult] {
        let queryLower = query.lowercased()
        var results: [ContentResult] = []
        
        for item in content.values {
            // Apply filters
            if let types = filters.types, !types.contains(item.type) { continue }
            if let categories = filters.categories, !categories.contains(item.type.category) { continue }
            if let projectIds = filters.projectIds, !projectIds.contains(item.projectId) { continue }
            if let tags = filters.tags, !tags.contains(where: { item.metadata.tags.contains($0) }) { continue }
            if let kits = filters.generatedBy, !kits.contains(item.generatedBy) { continue }
            
            // Calculate relevance
            var relevance = 0.0
            var highlights: [String] = []
            
            // Title match
            if item.title.lowercased().contains(queryLower) {
                relevance += 50.0
                highlights.append("Title: \(item.title)")
            }
            
            // Content match
            let contentLower = item.content.lowercased()
            if contentLower.contains(queryLower) {
                let occurrences = contentLower.components(separatedBy: queryLower).count - 1
                relevance += Double(occurrences) * 10.0
                
                // Extract highlight snippet
                if let range = contentLower.range(of: queryLower) {
                    let start = contentLower.index(range.lowerBound, offsetBy: -50, limitedBy: contentLower.startIndex) ?? contentLower.startIndex
                    let end = contentLower.index(range.upperBound, offsetBy: 50, limitedBy: contentLower.endIndex) ?? contentLower.endIndex
                    highlights.append("...\(item.content[start..<end])...")
                }
            }
            
            // Tag match
            for tag in item.metadata.tags {
                if tag.lowercased().contains(queryLower) {
                    relevance += 20.0
                    highlights.append("Tag: \(tag)")
                }
            }
            
            // Project name match
            if item.projectName.lowercased().contains(queryLower) {
                relevance += 15.0
            }
            
            if relevance > 0 {
                results.append(ContentResult(content: item, relevance: relevance, highlights: highlights))
            }
        }
        
        return results
            .sorted { $0.relevance > $1.relevance }
            .prefix(filters.maxResults)
            .map { $0 }
    }
    
    // MARK: - ML Data
    
    public func getMLData(type: ContentType?) -> [MLTrainingRecord] {
        let items: [GeneratedContent]
        if let type = type {
            items = getByType(type)
        } else {
            items = Array(content.values)
        }
        
        return items.map { MLTrainingRecord(from: $0) }
    }
    
    // MARK: - Project Registration
    
    public func registerProject(_ project: ProjectRegistration) {
        registeredProjects[project.projectId] = project
        Task { await saveToDisk() }
    }
    
    public func getRegisteredProjects() -> [ProjectRegistration] {
        Array(registeredProjects.values)
    }
    
    // MARK: - Statistics
    
    public func getStats() -> HubStatistics {
        var byType: [ContentType: Int] = [:]
        var byCategory: [ContentCategory: Int] = [:]
        var totalSize: Int64 = 0
        
        for item in content.values {
            byType[item.type, default: 0] += 1
            byCategory[item.type.category, default: 0] += 1
            totalSize += Int64(item.content.utf8.count)
        }
        
        return HubStatistics(
            totalContent: content.count,
            totalProjects: projectIndex.keys.count,
            contentByType: byType,
            contentByCategory: byCategory,
            totalSize: totalSize,
            lastUpdated: Date()
        )
    }
    
    // MARK: - Persistence
    
    private func loadFromDisk() {
        let contentFile = hubPath.appendingPathComponent("content.json")
        let projectsFile = hubPath.appendingPathComponent("projects.json")
        
        if let data = try? Data(contentsOf: contentFile),
           let loaded = try? JSONDecoder().decode([GeneratedContent].self, from: data) {
            for item in loaded {
                content[item.id] = item
                projectIndex[item.projectId, default: []].insert(item.id)
                typeIndex[item.type, default: []].insert(item.id)
                for tag in item.metadata.tags {
                    tagIndex[tag.lowercased(), default: []].insert(item.id)
                }
            }
        }
        
        if let data = try? Data(contentsOf: projectsFile),
           let loaded = try? JSONDecoder().decode([ProjectRegistration].self, from: data) {
            for project in loaded {
                registeredProjects[project.projectId] = project
            }
        }
    }
    
    private func saveToDisk() {
        try? FileManager.default.createDirectory(at: hubPath, withIntermediateDirectories: true)
        
        let contentFile = hubPath.appendingPathComponent("content.json")
        let projectsFile = hubPath.appendingPathComponent("projects.json")
        
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        encoder.dateEncodingStrategy = .iso8601
        
        if let data = try? encoder.encode(Array(content.values)) {
            try? data.write(to: contentFile)
        }
        
        if let data = try? encoder.encode(Array(registeredProjects.values)) {
            try? data.write(to: projectsFile)
        }
    }
}
