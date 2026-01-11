//
//  KnowledgeViewModel.swift
//  KnowledgeKit
//

import Foundation
import Combine

@MainActor
public class KnowledgeViewModel: ObservableObject {
    @Published public var entries: [KnowledgeEntry] = []
    @Published public var selectedEntry: KnowledgeEntry?
    @Published public var searchText = ""
    @Published public var selectedCategory: KnowledgeCategory?
    @Published public var selectedSection: KnowledgeSection = .all
    @Published public var isLoading = false
    @Published public var error: KnowledgeError?
    
    public init() {
        Task { await loadEntries() }
    }
    
    // MARK: - CRUD Operations
    
    public func loadEntries() async {
        isLoading = true
        entries = await KnowledgeBase.shared.getAll()
        isLoading = false
    }
    
    public func create(title: String, content: String, category: KnowledgeCategory = .general, tags: [String] = []) async {
        let _ = await KnowledgeBase.shared.add(title: title, content: content, category: category, tags: tags)
        await loadEntries()
    }
    
    public func delete(_ entry: KnowledgeEntry) async {
        await KnowledgeBase.shared.delete(entry.id)
        await loadEntries()
    }
    
    public func search() async {
        guard !searchText.isEmpty else {
            await loadEntries()
            return
        }
        
        isLoading = true
        entries = await KnowledgeBase.shared.search(searchText)
        isLoading = false
    }
    
    // MARK: - Filtering
    
    public var filteredEntries: [KnowledgeEntry] {
        var result = entries
        
        if let category = selectedCategory {
            result = result.filter { $0.category == category }
        }
        
        return result
    }
}
