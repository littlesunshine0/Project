//
//  AnimationCurve.swift
//  DataKit
//

import Foundation

public enum AnimationCurve: String, Codable, Sendable, CaseIterable {
    case linear, easeIn, easeOut, easeInOut, spring, bounce
}
