//
//  PermissionType.swift
//  DataKit
//

import Foundation

public enum PermissionType: String, Codable, Sendable, CaseIterable {
    case camera, microphone, location, notifications, photos, contacts, calendar, files, network, bluetooth
}
