//
//  StatusBadge.swift
//  DesignKit
//
//  Status indicator badge component
//

import SwiftUI

public struct StatusBadge: View {
    public let status: String
    public let isHealthy: Bool
    
    public init(status: String, isHealthy: Bool) {
        self.status = status
        self.isHealthy = isHealthy
    }
    
    public var body: some View {
        HStack(spacing: 4) {
            Circle().fill(isHealthy ? FlowColors.Status.success : FlowColors.Status.error).frame(width: 6, height: 6)
            Text(status).font(FlowTypography.caption(.medium))
        }
        .padding(.horizontal, 8).padding(.vertical, 4)
        .background((isHealthy ? FlowColors.Status.success : FlowColors.Status.error).opacity(0.15))
        .clipShape(Capsule())
    }
}
