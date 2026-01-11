//
//  ViewState.swift
//  DataKit
//

import Foundation

/// State of a view for deterministic rendering
public struct ViewState: Codable, Sendable, Identifiable, Hashable {
    public let id: String
    public let viewId: String
    public var load: LoadState
    public var selection: [String]
    public var scroll: ScrollPosition?
    public var focus: FocusStateModel?
    public var data: [String: AnyCodable]
    
    public init(id: String = UUID().uuidString, viewId: String, load: LoadState = .idle, selection: [String] = [], scroll: ScrollPosition? = nil, focus: FocusStateModel? = nil, data: [String: AnyCodable] = [:]) {
        self.id = id
        self.viewId = viewId
        self.load = load
        self.selection = selection
        self.scroll = scroll
        self.focus = focus
        self.data = data
    }
}

public struct ScrollPosition: Codable, Sendable, Hashable {
    public let x: Double
    public let y: Double
    
    public init(x: Double = 0, y: Double = 0) {
        self.x = x
        self.y = y
    }
}
