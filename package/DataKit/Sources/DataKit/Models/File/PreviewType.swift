//
//  PreviewType.swift
//  DataKit
//

import Foundation

public enum PreviewType: String, Codable, Sendable, CaseIterable {
    case image, video, audio, document, code, richText, unsupported
}
