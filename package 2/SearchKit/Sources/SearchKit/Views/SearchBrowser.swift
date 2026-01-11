//
//  SearchBrowser.swift
//  SearchKit
//

import SwiftUI

public struct SearchBrowser: View {
    @StateObject private var viewModel = SearchViewModel()
    
    public init() {}
    
    public var body: some View {
        NavigationSplitView {
            sidebar
        } detail: {
            SearchResultsList(viewModel: viewModel)
        }
        .searchable(text: $viewModel.query, prompt: "Search...")
        .onSubmit(of: .search) {
            Task { await viewModel.search() }
        }
    }
    
    private var sidebar: some View {
        List(selection: $viewModel.selectedSection) {
            Section("Sections") {
                ForEach(SearchSection.allCases, id: \.self) { section in
                    Label(section.rawValue, systemImage: section.icon)
                        .tag(section)
                }
            }
            
            if !viewModel.recentSearches.isEmpty {
                Section("Recent") {
                    ForEach(viewModel.recentSearches, id: \.self) { search in
                        Label(search, systemImage: "clock")
                            .onTapGesture {
                                viewModel.query = search
                                Task { await viewModel.search() }
                            }
                    }
                }
            }
        }
        .navigationTitle("Search")
    }
}
