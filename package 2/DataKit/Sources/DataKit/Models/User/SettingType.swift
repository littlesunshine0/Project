//
//  SettingType.swift
//  DataKit
//

import Foundation

public enum SettingType: String, Codable, Sendable, CaseIterable {
    case toggle, text, number, select, multiSelect, slider, color, date, file
}
