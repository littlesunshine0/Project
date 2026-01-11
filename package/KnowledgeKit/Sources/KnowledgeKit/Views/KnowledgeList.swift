//
//  KnowledgeList.swift
//  KnowledgeKit
//

import SwiftUI

public struct KnowledgeList: View {
    @ObservedObject public var viewModel: KnowledgeViewModel
    
    public init(viewModel: KnowledgeViewModel) {
        self.viewModel = viewModel
    }
    
    public var body: some View {
        List {
            ForEach(viewModel.filteredEntries) { entry in
                KnowledgeRow(entry: entry)
            }
        }
        .listStyle(.plain)
        .overlay {
            if viewModel.isLoading {
                ProgressView()
            } else if viewModel.filteredEntries.isEmpty {
                ContentUnavailableView("No Knowledge", systemImage: "brain", description: Text("No entries match your search"))
            }
        }
    }
}

public struct KnowledgeRow: View {
    public let entry: KnowledgeEntry
    
    public init(entry: KnowledgeEntry) {
        self.entry = entry
    }
    
    public var body: some View {
        HStack(spacing: 12) {
            Image(systemName: entry.category.icon)
                .font(.title3)
                .foregroundStyle(.secondary)
                .frame(width: 24)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(entry.title)
                    .font(.headline)
                
                Text(entry.content.prefix(50) + "...")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
            }
            
            Spacer()
            
            Text(entry.category.rawValue)
                .font(.caption2)
                .padding(.horizontal, 6)
                .padding(.vertical, 2)
                .background(.quaternary)
                .clipShape(Capsule())
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 12)
    }
}
