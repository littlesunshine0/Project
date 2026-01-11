//
//  AssetType.swift
//  DataKit
//

import Foundation

public enum AssetType: String, Codable, Sendable, CaseIterable {
    case image, video, audio, document, archive, font, model3D, other
}
