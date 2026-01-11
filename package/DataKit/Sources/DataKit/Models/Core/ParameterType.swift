//
//  ParameterType.swift
//  DataKit
//

import Foundation

public enum ParameterType: String, Codable, Sendable, CaseIterable {
    case string, int, bool, date, file, node, array, object, any
}
