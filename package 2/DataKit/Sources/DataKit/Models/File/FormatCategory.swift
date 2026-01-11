//
//  FormatCategory.swift
//  DataKit
//

import Foundation

public enum FormatCategory: String, Codable, Sendable, CaseIterable {
    case text, code, data, image, video, audio, document, archive, other
}
