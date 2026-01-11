//
//  DocManager.swift
//  DocKit
//
//  Documentation lifecycle management
//

import Foundation
import Combine

// MARK: - Doc Manager

@MainActor
public class DocManager: ObservableObject {
    public static let shared = DocManager()
    
    @Published public var documents: [Document] = []
    @Published public var recentDocuments: [Document] = []
    @Published public var isLoading = false
    
    private let documentsKey = "savedDocuments"
    private let maxRecent = 10
    
    private init() {
        loadDocuments()
    }
    
    // MARK: - Document CRUD
    
    public func createDocument(
        title: String,
        description: String,
        sections: [DocumentSection] = [],
        format: DocumentFormat = .markdown,
        tags: [String] = []
    ) -> Document {
        let document = Document(
            title: title,
            description: description,
            sections: sections,
            format: format,
            tags: tags
        )
        
        documents.append(document)
        addToRecent(document)
        saveDocuments()
        
        return document
    }
    
    public func updateDocument(_ document: Document) {
        if let index = documents.firstIndex(where: { $0.id == document.id }) {
            var updated = document
            updated = Document(
                id: document.id,
                title: document.title,
                description: document.description,
                sections: document.sections,
                format: document.format,
                tags: document.tags,
                createdAt: document.createdAt,
                updatedAt: Date()
            )
            documents[index] = updated
            addToRecent(updated)
            saveDocuments()
        }
    }
    
    public func deleteDocument(_ document: Document) {
        documents.removeAll { $0.id == document.id }
        recentDocuments.removeAll { $0.id == document.id }
        saveDocuments()
    }
    
    private func addToRecent(_ document: Document) {
        recentDocuments.removeAll { $0.id == document.id }
        recentDocuments.insert(document, at: 0)
        if recentDocuments.count > maxRecent {
            recentDocuments.removeLast()
        }
    }
    
    // MARK: - Query
    
    public func getDocument(byId id: UUID) -> Document? {
        documents.first { $0.id == id }
    }
    
    public func getDocuments(byFormat format: DocumentFormat) -> [Document] {
        documents.filter { $0.format == format }
    }
    
    public func searchDocuments(_ query: String) -> [Document] {
        guard !query.isEmpty else { return documents }
        let lowercased = query.lowercased()
        return documents.filter {
            $0.title.lowercased().contains(lowercased) ||
            $0.description.lowercased().contains(lowercased) ||
            $0.tags.contains { $0.lowercased().contains(lowercased) } ||
            $0.sections.contains { $0.title.lowercased().contains(lowercased) || $0.content.lowercased().contains(lowercased) }
        }
    }
    
    // MARK: - Statistics
    
    public var totalDocuments: Int { documents.count }
    
    public var totalWordCount: Int {
        documents.reduce(0) { $0 + $1.wordCount }
    }
    
    public func documentsByFormat() -> [DocumentFormat: Int] {
        var counts: [DocumentFormat: Int] = [:]
        for doc in documents {
            counts[doc.format, default: 0] += 1
        }
        return counts
    }
    
    // MARK: - Persistence
    
    private func loadDocuments() {
        if let data = UserDefaults.standard.data(forKey: documentsKey),
           let decoded = try? JSONDecoder().decode([Document].self, from: data) {
            documents = decoded
            recentDocuments = Array(decoded.sorted { $0.updatedAt > $1.updatedAt }.prefix(maxRecent))
        }
    }
    
    private func saveDocuments() {
        if let encoded = try? JSONEncoder().encode(documents) {
            UserDefaults.standard.set(encoded, forKey: documentsKey)
        }
    }
}
