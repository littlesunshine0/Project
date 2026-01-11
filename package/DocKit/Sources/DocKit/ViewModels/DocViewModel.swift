//
//  DocViewModel.swift
//  DocKit
//

import Foundation
import Combine

@MainActor
public class DocViewModel: ObservableObject {
    @Published public var documents: [Document] = []
    @Published public var selectedDocument: Document?
    @Published public var searchText = ""
    @Published public var selectedCategory: DocCategory?
    @Published public var selectedSection: DocSection = .all
    @Published public var isLoading = false
    @Published public var error: DocError?
    
    public init() {
        loadDocuments()
    }
    
    // MARK: - CRUD Operations
    
    public func loadDocuments() {
        isLoading = true
        // Load from storage
        documents = []
        isLoading = false
    }
    
    public func create(_ document: Document) {
        documents.append(document)
    }
    
    public func update(_ document: Document) {
        if let index = documents.firstIndex(where: { $0.id == document.id }) {
            documents[index] = document
        }
    }
    
    public func delete(_ document: Document) {
        documents.removeAll { $0.id == document.id }
    }
    
    // MARK: - Filtering
    
    public var filteredDocuments: [Document] {
        var result = documents
        
        if !searchText.isEmpty {
            result = result.filter {
                $0.title.localizedCaseInsensitiveContains(searchText) ||
                $0.description.localizedCaseInsensitiveContains(searchText)
            }
        }
        
        return result
    }
}


