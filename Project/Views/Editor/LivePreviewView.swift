//
//  LivePreviewView.swift
//  FlowKit
//
//  Live preview panel for SwiftUI views and web content
//

import SwiftUI

struct LivePreviewView: View {
    @Environment(\.colorScheme) private var colorScheme
    @State private var previewMode: PreviewMode = .swiftUI
    @State private var deviceFrame: DeviceFrame = .iPhone14
    @State private var isRefreshing = false
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            previewHeader
            
            // Preview content
            previewContent
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .background(FlowPalette.Semantic.surface(colorScheme))
    }
    
    private var previewHeader: some View {
        HStack(spacing: 12) {
            // Mode picker
            Picker("Mode", selection: $previewMode) {
                ForEach(PreviewMode.allCases) { mode in
                    Text(mode.title).tag(mode)
                }
            }
            .pickerStyle(.segmented)
            .frame(width: 200)
            
            Spacer()
            
            // Device picker
            Menu {
                ForEach(DeviceFrame.allCases) { device in
                    Button(device.title) {
                        deviceFrame = device
                    }
                }
            } label: {
                HStack(spacing: 4) {
                    Image(systemName: deviceFrame.icon)
                    Text(deviceFrame.title)
                }
                .font(.system(size: 12))
                .foregroundStyle(FlowPalette.Text.secondary(colorScheme))
            }
            .menuStyle(.borderlessButton)
            
            // Refresh button
            Button(action: refresh) {
                Image(systemName: "arrow.clockwise")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundStyle(FlowPalette.Text.secondary(colorScheme))
                    .rotationEffect(.degrees(isRefreshing ? 360 : 0))
            }
            .buttonStyle(.plain)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 10)
        .background(
            VStack {
                Spacer()
                FlowPalette.Border.subtle(colorScheme).frame(height: 1)
            }
        )
    }
    
    private var previewContent: some View {
        GeometryReader { geometry in
            ZStack {
                // Checkered background
                CheckeredBackground()
                
                // Device frame
                VStack {
                    devicePreview
                        .frame(width: deviceFrame.size.width, height: deviceFrame.size.height)
                        .background(Color.white)
                        .clipShape(RoundedRectangle(cornerRadius: deviceFrame.cornerRadius))
                        .overlay(
                            RoundedRectangle(cornerRadius: deviceFrame.cornerRadius)
                                .strokeBorder(Color.black.opacity(0.2), lineWidth: 2)
                        )
                        .shadow(color: Color.black.opacity(0.2), radius: 20, y: 10)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
    }
    
    @ViewBuilder
    private var devicePreview: some View {
        switch previewMode {
        case .swiftUI:
            // Placeholder SwiftUI preview
            VStack(spacing: 20) {
                Image(systemName: "swift")
                    .font(.system(size: 48))
                    .foregroundStyle(.orange)
                
                Text("SwiftUI Preview")
                    .font(.headline)
                
                Text("Your view will render here")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(white: 0.95))
            
        case .web:
            // Placeholder web preview
            VStack(spacing: 20) {
                Image(systemName: "globe")
                    .font(.system(size: 48))
                    .foregroundStyle(.blue)
                
                Text("Web Preview")
                    .font(.headline)
                
                Text("HTML/CSS will render here")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.white)
            
        case .markdown:
            // Placeholder markdown preview
            ScrollView {
                VStack(alignment: .leading, spacing: 12) {
                    Text("# Markdown Preview")
                        .font(.title)
                    
                    Text("Your markdown content will be rendered here with proper formatting.")
                        .font(.body)
                    
                    Text("## Features")
                        .font(.title2)
                    
                    Text("- Headers\n- Lists\n- Code blocks\n- And more...")
                        .font(.body)
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .background(Color.white)
        }
    }
    
    private func refresh() {
        withAnimation(.linear(duration: 0.5)) {
            isRefreshing = true
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            isRefreshing = false
        }
    }
}

// MARK: - Preview Mode

enum PreviewMode: String, CaseIterable, Identifiable {
    case swiftUI
    case web
    case markdown
    
    var id: String { rawValue }
    
    var title: String {
        switch self {
        case .swiftUI: return "SwiftUI"
        case .web: return "Web"
        case .markdown: return "Markdown"
        }
    }
}

// MARK: - Device Frame

enum DeviceFrame: String, CaseIterable, Identifiable {
    case iPhone14
    case iPhone14Pro
    case iPadMini
    case iPadPro
    case macBook
    
    var id: String { rawValue }
    
    var title: String {
        switch self {
        case .iPhone14: return "iPhone 14"
        case .iPhone14Pro: return "iPhone 14 Pro"
        case .iPadMini: return "iPad mini"
        case .iPadPro: return "iPad Pro"
        case .macBook: return "MacBook"
        }
    }
    
    var icon: String {
        switch self {
        case .iPhone14, .iPhone14Pro: return "iphone"
        case .iPadMini, .iPadPro: return "ipad"
        case .macBook: return "laptopcomputer"
        }
    }
    
    var size: CGSize {
        switch self {
        case .iPhone14: return CGSize(width: 195, height: 422)
        case .iPhone14Pro: return CGSize(width: 195, height: 422)
        case .iPadMini: return CGSize(width: 300, height: 400)
        case .iPadPro: return CGSize(width: 400, height: 300)
        case .macBook: return CGSize(width: 500, height: 312)
        }
    }
    
    var cornerRadius: CGFloat {
        switch self {
        case .iPhone14, .iPhone14Pro: return 24
        case .iPadMini, .iPadPro: return 12
        case .macBook: return 8
        }
    }
}

// MARK: - Checkered Background

struct CheckeredBackground: View {
    let squareSize: CGFloat = 10
    
    var body: some View {
        GeometryReader { geometry in
            let columns = Int(geometry.size.width / squareSize) + 1
            let rows = Int(geometry.size.height / squareSize) + 1
            
            Canvas { context, size in
                for row in 0..<rows {
                    for col in 0..<columns {
                        let isLight = (row + col) % 2 == 0
                        let rect = CGRect(
                            x: CGFloat(col) * squareSize,
                            y: CGFloat(row) * squareSize,
                            width: squareSize,
                            height: squareSize
                        )
                        context.fill(
                            Path(rect),
                            with: .color(isLight ? Color(white: 0.95) : Color(white: 0.9))
                        )
                    }
                }
            }
        }
    }
}

// MARK: - Preview

#Preview {
    LivePreviewView()
        .frame(width: 600, height: 500)
        .preferredColorScheme(.dark)
}
