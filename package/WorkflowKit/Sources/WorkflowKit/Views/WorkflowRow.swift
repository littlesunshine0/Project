//
//  WorkflowRow.swift
//  WorkflowKit
//

import SwiftUI

public struct WorkflowRow: View {
    public let workflow: Workflow
    public var onTap: (() -> Void)?
    public var onRun: (() -> Void)?
    
    public init(workflow: Workflow, onTap: (() -> Void)? = nil, onRun: (() -> Void)? = nil) {
        self.workflow = workflow
        self.onTap = onTap
        self.onRun = onRun
    }
    
    public var body: some View {
        HStack(spacing: 12) {
            Image(systemName: workflow.category.icon)
                .font(.title3)
                .foregroundStyle(.secondary)
                .frame(width: 24)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(workflow.name)
                    .font(.headline)
                
                Text(workflow.description)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
            }
            
            Spacer()
            
            HStack(spacing: 8) {
                Text(workflow.category.rawValue)
                    .font(.caption2)
                    .padding(.horizontal, 6)
                    .padding(.vertical, 2)
                    .background(.quaternary)
                    .clipShape(Capsule())
                
                if let onRun {
                    Button(action: onRun) {
                        Image(systemName: "play.fill")
                            .foregroundStyle(.tint)
                    }
                    .buttonStyle(.plain)
                }
            }
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 12)
        .contentShape(Rectangle())
        .onTapGesture { onTap?() }
    }
}
