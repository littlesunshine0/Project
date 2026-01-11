//
//  ProgressStatus.swift
//  DataKit
//

import Foundation

public enum ProgressStatus: String, Codable, Sendable, CaseIterable {
    case pending, inProgress, paused, completed, failed, cancelled
}
