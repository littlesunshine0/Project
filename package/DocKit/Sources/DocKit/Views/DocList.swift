//
//  DocList.swift
//  DocKit
//

import SwiftUI

public struct DocList: View {
    @ObservedObject public var viewModel: DocViewModel
    public var onSelect: ((Document) -> Void)?
    
    public init(viewModel: DocViewModel, onSelect: ((Document) -> Void)? = nil) {
        self.viewModel = viewModel
        self.onSelect = onSelect
    }
    
    public var body: some View {
        List {
            ForEach(viewModel.filteredDocuments) { document in
                DocRow(document: document)
                    .onTapGesture { onSelect?(document) }
                    .listRowInsets(EdgeInsets())
            }
        }
        .listStyle(.plain)
        .searchable(text: $viewModel.searchText, prompt: "Search documents...")
        .overlay {
            if viewModel.isLoading {
                ProgressView()
            } else if viewModel.filteredDocuments.isEmpty {
                ContentUnavailableView("No Documents", systemImage: "doc.text", description: Text("No documents match your search"))
            }
        }
    }
}
