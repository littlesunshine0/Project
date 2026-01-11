//
//  ViewDescriptor.swift
//  DataKit
//

import Foundation

/// View descriptor for auto-generation
public struct ViewDescriptor: Codable, Sendable, Identifiable, Hashable {
    public let id: String
    public let viewType: ViewType
    public let dataSource: String
    public let layout: LayoutModel
    public let actions: [String]
    
    public init(id: String, viewType: ViewType, dataSource: String, layout: LayoutModel = LayoutModel(), actions: [String] = []) {
        self.id = id
        self.viewType = viewType
        self.dataSource = dataSource
        self.layout = layout
        self.actions = actions
    }
}
