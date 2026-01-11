//
//  AgentList.swift
//  AgentKit
//

import SwiftUI

public struct AgentList: View {
    @ObservedObject public var viewModel: AgentViewModel
    public var onSelect: ((Agent) -> Void)?
    public var onToggle: ((Agent) -> Void)?
    
    public init(viewModel: AgentViewModel, onSelect: ((Agent) -> Void)? = nil, onToggle: ((Agent) -> Void)? = nil) {
        self.viewModel = viewModel
        self.onSelect = onSelect
        self.onToggle = onToggle
    }
    
    public var body: some View {
        List {
            ForEach(viewModel.filteredAgents) { agent in
                AgentRow(
                    agent: agent,
                    onTap: { onSelect?(agent) },
                    onToggle: { onToggle?(agent) }
                )
                .listRowInsets(EdgeInsets())
            }
        }
        .listStyle(.plain)
        .searchable(text: $viewModel.searchText, prompt: "Search agents...")
        .overlay {
            if viewModel.isLoading {
                ProgressView()
            } else if viewModel.filteredAgents.isEmpty {
                ContentUnavailableView("No Agents", systemImage: "cpu", description: Text("No agents match your search"))
            }
        }
    }
}
