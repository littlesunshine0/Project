//
//  ContentFormat.swift
//  DataKit
//

import Foundation

public enum ContentFormat: String, Codable, Sendable, CaseIterable {
    case markdown, html, plainText, richText, json
}
