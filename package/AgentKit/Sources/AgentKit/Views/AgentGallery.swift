//
//  AgentGallery.swift
//  AgentKit
//

import SwiftUI

public struct AgentGallery: View {
    @ObservedObject public var viewModel: AgentViewModel
    public var onSelect: ((Agent) -> Void)?
    
    private let columns = [
        GridItem(.adaptive(minimum: 200, maximum: 300), spacing: 16)
    ]
    
    public init(viewModel: AgentViewModel, onSelect: ((Agent) -> Void)? = nil) {
        self.viewModel = viewModel
        self.onSelect = onSelect
    }
    
    public var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 16) {
                ForEach(viewModel.filteredAgents) { agent in
                    AgentGalleryItem(agent: agent)
                        .onTapGesture { onSelect?(agent) }
                }
            }
            .padding()
        }
    }
}

public struct AgentGalleryItem: View {
    public let agent: Agent
    
    public init(agent: Agent) {
        self.agent = agent
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: agent.type.icon)
                    .font(.title2)
                    .foregroundStyle(.tint)
                
                Spacer()
                
                Circle()
                    .fill(statusColor)
                    .frame(width: 10, height: 10)
            }
            
            Text(agent.name)
                .font(.headline)
            
            Text(agent.description)
                .font(.caption)
                .foregroundStyle(.secondary)
                .lineLimit(2)
            
            HStack {
                Label(agent.type.rawValue, systemImage: agent.type.icon)
                    .font(.caption2)
                    .foregroundStyle(.secondary)
                
                Spacer()
                
                Text(agent.status.rawValue)
                    .font(.caption2)
                    .padding(.horizontal, 6)
                    .padding(.vertical, 2)
                    .background(statusColor.opacity(0.2))
                    .clipShape(Capsule())
            }
        }
        .padding()
        .background(.background)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(color: .black.opacity(0.1), radius: 4, y: 2)
    }
    
    private var statusColor: Color {
        switch agent.status {
        case .idle: return .gray
        case .running: return .green
        case .paused: return .orange
        case .error: return .red
        case .disabled: return .gray
        }
    }
}
