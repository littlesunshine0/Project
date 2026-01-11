//
//  FloatingPanelState.swift
//  FlowKit
//
//  SwiftUI state management for floating panels
//  Uses DataKit models for core data
//

import SwiftUI
import Combine
import DataKit

// MARK: - Floating Panel State (SwiftUI)

/// Represents the state of a floating panel for SwiftUI rendering
public struct FloatingPanelState: Identifiable, Equatable {
    public let id: String
    public let type: ContextPanelTypeModel
    public var position: PanelPosition
    public var isExpanded: Bool
    public var heightRatio: CGFloat
    
    public init(
        type: ContextPanelTypeModel,
        position: PanelPosition? = nil,
        isExpanded: Bool = true,
        heightRatio: CGFloat = 0.5
    ) {
        self.id = type.rawValue
        self.type = type
        self.position = position ?? type.defaultPanelPosition
        self.isExpanded = isExpanded
        self.heightRatio = heightRatio
    }
    
    public static func == (lhs: FloatingPanelState, rhs: FloatingPanelState) -> Bool {
        lhs.id == rhs.id &&
        lhs.type == rhs.type &&
        lhs.position == rhs.position &&
        lhs.isExpanded == rhs.isExpanded &&
        lhs.heightRatio == rhs.heightRatio
    }
}

// MARK: - Floating Panel Manager (SwiftUI ObservableObject)

/// Manages multiple floating panels - SwiftUI state management
@MainActor
public class FloatingPanelManager: ObservableObject {
    public static let shared = FloatingPanelManager()
    
    @Published public var activePanels: [FloatingPanelState] = []
    @Published public var focusedPanelId: String? = nil
    @Published public var isPanelAreaVisible: Bool = false
    @Published public var panelAreaHeightRatio: CGFloat = 0.35
    
    private init() {}
    
    // MARK: - Panel Management
    
    public func showPanel(_ type: ContextPanelTypeModel, position: PanelPosition? = nil) {
        isPanelAreaVisible = true
        
        if let index = activePanels.firstIndex(where: { $0.type == type }) {
            focusedPanelId = activePanels[index].id
        } else {
            let panel = FloatingPanelState(type: type, position: position)
            activePanels.append(panel)
            focusedPanelId = panel.id
            rebalancePanels()
        }
    }
    
    public func hidePanel(_ type: ContextPanelTypeModel) {
        activePanels.removeAll { $0.type == type }
        if activePanels.isEmpty {
            isPanelAreaVisible = false
            focusedPanelId = nil
        } else {
            focusedPanelId = activePanels.last?.id
            rebalancePanels()
        }
    }
    
    public func togglePanel(_ type: ContextPanelTypeModel) {
        if activePanels.contains(where: { $0.type == type }) {
            hidePanel(type)
        } else {
            showPanel(type)
        }
    }
    
    public func hideAllPanels() {
        activePanels.removeAll()
        isPanelAreaVisible = false
        focusedPanelId = nil
    }
    
    public func focusPanel(_ type: ContextPanelTypeModel) {
        if let panel = activePanels.first(where: { $0.type == type }) {
            focusedPanelId = panel.id
        }
    }
    
    // MARK: - Layout
    
    private func rebalancePanels() {
        guard !activePanels.isEmpty else { return }
        
        let topPanels = activePanels.filter { $0.position == .top }
        let bottomPanels = activePanels.filter { $0.position == .bottom }
        
        if !topPanels.isEmpty && !bottomPanels.isEmpty {
            for i in activePanels.indices {
                activePanels[i].heightRatio = 0.5
            }
        } else {
            for i in activePanels.indices {
                activePanels[i].heightRatio = 1.0
            }
        }
    }
    
    public func panels(at position: PanelPosition) -> [FloatingPanelState] {
        activePanels.filter { $0.position == position }
    }
    
    public func isActive(_ type: ContextPanelTypeModel) -> Bool {
        activePanels.contains { $0.type == type }
    }
}
