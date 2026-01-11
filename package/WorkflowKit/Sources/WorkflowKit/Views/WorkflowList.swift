//
//  WorkflowList.swift
//  WorkflowKit
//

import SwiftUI

public struct WorkflowList: View {
    @ObservedObject public var viewModel: WorkflowViewModel
    public var onSelect: ((Workflow) -> Void)?
    public var onRun: ((Workflow) -> Void)?
    
    public init(viewModel: WorkflowViewModel, onSelect: ((Workflow) -> Void)? = nil, onRun: ((Workflow) -> Void)? = nil) {
        self.viewModel = viewModel
        self.onSelect = onSelect
        self.onRun = onRun
    }
    
    public var body: some View {
        List {
            ForEach(viewModel.filteredWorkflows) { workflow in
                WorkflowRow(
                    workflow: workflow,
                    onTap: { onSelect?(workflow) },
                    onRun: { onRun?(workflow) }
                )
                .listRowInsets(EdgeInsets())
            }
        }
        .listStyle(.plain)
        .searchable(text: $viewModel.searchText, prompt: "Search workflows...")
        .overlay {
            if viewModel.isLoading {
                ProgressView()
            } else if viewModel.filteredWorkflows.isEmpty {
                ContentUnavailableView("No Workflows", systemImage: "arrow.triangle.branch", description: Text("No workflows match your search"))
            }
        }
    }
}
