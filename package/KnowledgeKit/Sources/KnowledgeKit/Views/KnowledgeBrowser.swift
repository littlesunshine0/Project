//
//  KnowledgeBrowser.swift
//  KnowledgeKit
//

import SwiftUI

public struct KnowledgeBrowser: View {
    @StateObject private var viewModel = KnowledgeViewModel()
    
    public init() {}
    
    public var body: some View {
        NavigationSplitView {
            sidebar
        } detail: {
            KnowledgeList(viewModel: viewModel)
        }
        .searchable(text: $viewModel.searchText, prompt: "Search knowledge...")
        .onSubmit(of: .search) {
            Task { await viewModel.search() }
        }
    }
    
    private var sidebar: some View {
        List(selection: $viewModel.selectedSection) {
            Section("Sections") {
                ForEach(KnowledgeSection.allCases, id: \.self) { section in
                    Label(section.rawValue, systemImage: section.icon)
                        .tag(section)
                }
            }
            
            Section("Categories") {
                ForEach(KnowledgeCategory.allCases, id: \.self) { category in
                    Label(category.rawValue, systemImage: category.icon)
                        .tag(category)
                }
            }
        }
        .navigationTitle("Knowledge")
    }
}
