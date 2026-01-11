//
//  FieldType.swift
//  DataKit
//

import Foundation

public enum FieldType: String, Codable, Sendable, CaseIterable {
    case text, number, toggle, date, color, select
}
