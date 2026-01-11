//
//  CommandViewModel.swift
//  CommandKit
//

import Foundation
import Combine

@MainActor
public class CommandViewModel: ObservableObject {
    @Published public var commands: [Command] = []
    @Published public var selectedCommand: Command?
    @Published public var searchText = ""
    @Published public var selectedCategory: CommandCategory?
    @Published public var selectedSection: CommandSection = .all
    @Published public var isLoading = false
    @Published public var error: CommandError?
    
    private let manager: CommandManager
    
    public init(manager: CommandManager = .shared) {
        self.manager = manager
        Task { await loadCommands() }
    }
    
    // MARK: - CRUD Operations
    
    public func loadCommands() async {
        isLoading = true
        commands = await manager.getAllCommands()
        isLoading = false
    }
    
    public func create(_ command: Command) async {
        await manager.register(command)
        await loadCommands()
    }
    
    public func update(_ command: Command) async {
        await manager.update(command)
        await loadCommands()
    }
    
    public func delete(_ command: Command) async {
        await manager.delete(command.id)
        await loadCommands()
    }
    
    public func execute(_ command: Command, arguments: [String] = []) async throws -> ExecutionResult {
        try await manager.execute(command, arguments: arguments)
    }
    
    // MARK: - Filtering
    
    public var filteredCommands: [Command] {
        var result = commands
        
        if let category = selectedCategory {
            result = result.filter { $0.category == category }
        }
        
        if !searchText.isEmpty {
            result = result.filter {
                $0.name.localizedCaseInsensitiveContains(searchText) ||
                $0.description.localizedCaseInsensitiveContains(searchText)
            }
        }
        
        switch selectedSection {
        case .all: break
        case .favorites: result = result.filter { manager.isFavorite($0.id) }
        case .recent: result = Array(result.prefix(10))
        case .templates: result = result.filter { $0.isBuiltIn }
        case .custom: result = result.filter { !$0.isBuiltIn }
        }
        
        return result
    }
    
    // MARK: - Favorites
    
    public func toggleFavorite(_ command: Command) {
        manager.toggleFavorite(command.id)
        objectWillChange.send()
    }
    
    public func isFavorite(_ command: Command) -> Bool {
        manager.isFavorite(command.id)
    }
}


