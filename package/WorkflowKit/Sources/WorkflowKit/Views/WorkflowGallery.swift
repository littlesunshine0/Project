//
//  WorkflowGallery.swift
//  WorkflowKit
//

import SwiftUI

public struct WorkflowGallery: View {
    @ObservedObject public var viewModel: WorkflowViewModel
    public var onSelect: ((Workflow) -> Void)?
    
    private let columns = [
        GridItem(.adaptive(minimum: 200, maximum: 300), spacing: 16)
    ]
    
    public init(viewModel: WorkflowViewModel, onSelect: ((Workflow) -> Void)? = nil) {
        self.viewModel = viewModel
        self.onSelect = onSelect
    }
    
    public var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 16) {
                ForEach(viewModel.filteredWorkflows) { workflow in
                    WorkflowGalleryItem(workflow: workflow)
                        .onTapGesture { onSelect?(workflow) }
                }
            }
            .padding()
        }
    }
}

public struct WorkflowGalleryItem: View {
    public let workflow: Workflow
    
    public init(workflow: Workflow) {
        self.workflow = workflow
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: workflow.category.icon)
                    .font(.title2)
                    .foregroundStyle(.tint)
                
                Spacer()
                
                Text("\(workflow.steps.count) steps")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            
            Text(workflow.name)
                .font(.headline)
            
            Text(workflow.description)
                .font(.caption)
                .foregroundStyle(.secondary)
                .lineLimit(2)
            
            HStack {
                Label(workflow.category.rawValue, systemImage: workflow.category.icon)
                    .font(.caption2)
                    .foregroundStyle(.secondary)
                
                Spacer()
                
                if workflow.isBuiltIn {
                    Text("Built-in")
                        .font(.caption2)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(.blue.opacity(0.2))
                        .clipShape(Capsule())
                }
            }
        }
        .padding()
        .background(.background)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(color: .black.opacity(0.1), radius: 4, y: 2)
    }
}
