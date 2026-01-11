//
//  CommandList.swift
//  CommandKit
//

import SwiftUI

public struct CommandList: View {
    @ObservedObject public var viewModel: CommandViewModel
    public var onSelect: ((Command) -> Void)?
    
    public init(viewModel: CommandViewModel, onSelect: ((Command) -> Void)? = nil) {
        self.viewModel = viewModel
        self.onSelect = onSelect
    }
    
    public var body: some View {
        List {
            ForEach(viewModel.filteredCommands) { command in
                CommandRow(
                    command: command,
                    isFavorite: viewModel.isFavorite(command),
                    onTap: { onSelect?(command) },
                    onFavorite: { viewModel.toggleFavorite(command) }
                )
                .listRowInsets(EdgeInsets())
            }
        }
        .listStyle(.plain)
        .searchable(text: $viewModel.searchText, prompt: "Search commands...")
        .overlay {
            if viewModel.isLoading {
                ProgressView()
            } else if viewModel.filteredCommands.isEmpty {
                ContentUnavailableView("No Commands", systemImage: "command", description: Text("No commands match your search"))
            }
        }
    }
}
