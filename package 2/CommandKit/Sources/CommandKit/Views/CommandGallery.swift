//
//  CommandGallery.swift
//  CommandKit
//

import SwiftUI

public struct CommandGallery: View {
    @ObservedObject public var viewModel: CommandViewModel
    public var onSelect: ((Command) -> Void)?
    
    private let columns = [
        GridItem(.adaptive(minimum: 200, maximum: 300), spacing: 16)
    ]
    
    public init(viewModel: CommandViewModel, onSelect: ((Command) -> Void)? = nil) {
        self.viewModel = viewModel
        self.onSelect = onSelect
    }
    
    public var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 16) {
                ForEach(viewModel.filteredCommands) { command in
                    CommandGalleryItem(
                        command: command,
                        isFavorite: viewModel.isFavorite(command),
                        onTap: { onSelect?(command) },
                        onFavorite: { viewModel.toggleFavorite(command) }
                    )
                }
            }
            .padding()
        }
    }
}

public struct CommandGalleryItem: View {
    public let command: Command
    public var isFavorite: Bool
    public var onTap: (() -> Void)?
    public var onFavorite: (() -> Void)?
    
    public init(command: Command, isFavorite: Bool = false, onTap: (() -> Void)? = nil, onFavorite: (() -> Void)? = nil) {
        self.command = command
        self.isFavorite = isFavorite
        self.onTap = onTap
        self.onFavorite = onFavorite
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: command.type.icon)
                    .font(.title2)
                    .foregroundStyle(.tint)
                
                Spacer()
                
                if let onFavorite {
                    Button(action: onFavorite) {
                        Image(systemName: isFavorite ? "star.fill" : "star")
                            .foregroundStyle(isFavorite ? .yellow : .secondary)
                    }
                    .buttonStyle(.plain)
                }
            }
            
            Text("/\(command.name)")
                .font(.headline)
                .fontDesign(.monospaced)
            
            Text(command.description)
                .font(.caption)
                .foregroundStyle(.secondary)
                .lineLimit(2)
            
            HStack {
                Label(command.category.rawValue, systemImage: command.category.icon)
                    .font(.caption2)
                    .foregroundStyle(.secondary)
                
                Spacer()
                
                Text(command.format.rawValue)
                    .font(.caption2)
                    .padding(.horizontal, 6)
                    .padding(.vertical, 2)
                    .background(.quaternary)
                    .clipShape(Capsule())
            }
        }
        .padding()
        .background(.background)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(color: .black.opacity(0.1), radius: 4, y: 2)
        .contentShape(Rectangle())
        .onTapGesture { onTap?() }
    }
}
