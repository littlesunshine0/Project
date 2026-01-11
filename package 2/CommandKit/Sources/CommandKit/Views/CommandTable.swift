//
//  CommandTable.swift
//  CommandKit
//

import SwiftUI

public struct CommandTable: View {
    @ObservedObject public var viewModel: CommandViewModel
    @State private var selection: Set<UUID> = []
    @State private var sortOrder = [KeyPathComparator(\Command.name)]
    
    public init(viewModel: CommandViewModel) {
        self.viewModel = viewModel
    }
    
    public var body: some View {
        Table(viewModel.filteredCommands, selection: $selection, sortOrder: $sortOrder) {
            TableColumn("Name", value: \.name) { command in
                HStack {
                    Image(systemName: command.type.icon)
                        .foregroundStyle(.secondary)
                    Text("/\(command.name)")
                        .fontDesign(.monospaced)
                }
            }
            .width(min: 120, ideal: 150)
            
            TableColumn("Description", value: \.description)
                .width(min: 200, ideal: 300)
            
            TableColumn("Category", value: \.category.rawValue) { command in
                Text(command.category.rawValue)
                    .font(.caption)
                    .padding(.horizontal, 6)
                    .padding(.vertical, 2)
                    .background(.quaternary)
                    .clipShape(Capsule())
            }
            .width(min: 80, ideal: 100)
            
            TableColumn("Type", value: \.type.rawValue) { command in
                Label(command.type.rawValue, systemImage: command.type.icon)
                    .font(.caption)
            }
            .width(min: 80, ideal: 100)
            
            TableColumn("Format", value: \.format.rawValue) { command in
                Text(command.format.rawValue)
                    .font(.caption)
            }
            .width(min: 80, ideal: 100)
        }
        .onChange(of: sortOrder) { _, newOrder in
            viewModel.commands.sort(using: newOrder)
        }
    }
}
