//
//  FileType.swift
//  DataKit
//

import Foundation

public enum FileType: String, Codable, Sendable, CaseIterable {
    case file, directory, symlink, unknown
}
