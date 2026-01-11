//
//  FlowTypography.swift
//  DesignKit
//
//  Typography system for FlowKit
//

import SwiftUI

public struct FlowTypography {
    public static func title1(_ weight: Font.Weight = .bold) -> Font {
        .system(size: 28, weight: weight, design: .default)
    }
    
    public static func title2(_ weight: Font.Weight = .semibold) -> Font {
        .system(size: 22, weight: weight, design: .default)
    }
    
    public static func title3(_ weight: Font.Weight = .semibold) -> Font {
        .system(size: 18, weight: weight, design: .default)
    }
    
    public static func headline(_ weight: Font.Weight = .semibold) -> Font {
        .system(size: 15, weight: weight, design: .default)
    }
    
    public static func body(_ weight: Font.Weight = .regular) -> Font {
        .system(size: 14, weight: weight, design: .default)
    }
    
    public static func caption(_ weight: Font.Weight = .regular) -> Font {
        .system(size: 12, weight: weight, design: .default)
    }
    
    public static func micro(_ weight: Font.Weight = .medium) -> Font {
        .system(size: 10, weight: weight, design: .default)
    }
    
    public static func mono(_ size: CGFloat = 13) -> Font {
        .system(size: size, weight: .regular, design: .monospaced)
    }
}
