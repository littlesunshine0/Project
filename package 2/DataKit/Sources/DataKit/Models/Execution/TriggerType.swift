//
//  TriggerType.swift
//  DataKit
//

import Foundation

public enum TriggerType: String, Codable, Sendable, CaseIterable {
    case event, schedule, manual, fileChange, stateChange, command
}
