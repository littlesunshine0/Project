//
//  ViewType.swift
//  DataKit
//

import Foundation

public enum ViewType: String, Codable, Sendable, CaseIterable {
    case list, grid, table, editor, timeline, canvas, browser, detail, settings, dashboard
}
