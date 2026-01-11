//
//  SearchResultsList.swift
//  SearchKit
//

import SwiftUI

public struct SearchResultsList: View {
    @ObservedObject public var viewModel: SearchViewModel
    
    public init(viewModel: SearchViewModel) {
        self.viewModel = viewModel
    }
    
    public var body: some View {
        List {
            ForEach(viewModel.results) { result in
                SearchResultRow(result: result)
            }
        }
        .listStyle(.plain)
        .overlay {
            if viewModel.isSearching {
                ProgressView()
            } else if viewModel.results.isEmpty && !viewModel.query.isEmpty {
                ContentUnavailableView("No Results", systemImage: "magnifyingglass", description: Text("No results for '\(viewModel.query)'"))
            } else if viewModel.query.isEmpty {
                ContentUnavailableView("Search", systemImage: "magnifyingglass", description: Text("Enter a search term"))
            }
        }
    }
}

public struct SearchResultRow: View {
    public let result: SearchResult
    
    public init(result: SearchResult) {
        self.result = result
    }
    
    public var body: some View {
        HStack(spacing: 12) {
            Image(systemName: result.type.icon)
                .font(.title3)
                .foregroundStyle(.secondary)
                .frame(width: 24)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(result.title)
                    .font(.headline)
                
                Text(result.subtitle)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
            }
            
            Spacer()
            
            Text(result.type.rawValue)
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
