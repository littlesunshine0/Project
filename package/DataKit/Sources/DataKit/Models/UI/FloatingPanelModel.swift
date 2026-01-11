//
//  FloatingPanelModel.swift
//  DataKit
//
//  Represents the state of a floating panel
//

import Foundation
import CoreGraphics

/// Position for floating panels
public enum FloatingPanelPositionModel: String, Codable, Sendable {
    case top
    case bottom
    
    public var title: String {
        switch self {
        case .top: return "Top"
        case .bottom: return "Bottom"
        }
    }
}

/// Represents the state of a floating panel
public struct FloatingPanelModel: Identifiable, Equatable, Codable, Sendable {
    public let id: String
    public let type: ContextPanelTypeModel
    public var position: FloatingPanelPositionModel
    public var isExpanded: Bool
    public var heightRatio: CGFloat // 0.0 to 1.0 of available space
    
    public init(
        type: ContextPanelTypeModel,
        position: FloatingPanelPositionModel? = nil,
        isExpanded: Bool = true,
        heightRatio: CGFloat = 0.5
    ) {
        self.id = type.rawValue
        self.type = type
        self.position = position ?? (type.defaultPosition == .bottom ? .bottom : .top)
        self.isExpanded = isExpanded
        self.heightRatio = heightRatio
    }
}
