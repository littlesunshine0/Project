//
//  AnimationType.swift
//  DataKit
//

import Foundation

public enum AnimationType: String, Codable, Sendable, CaseIterable {
    case appear, disappear, move, scale, rotate, fade, bounce, shake, pulse, highlight
}
