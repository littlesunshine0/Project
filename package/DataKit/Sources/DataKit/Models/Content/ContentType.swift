//
//  ContentType.swift
//  DataKit
//

import Foundation

public enum ContentType: String, Codable, Sendable, CaseIterable {
    case article, tutorial, reference, guide, example, note
}
