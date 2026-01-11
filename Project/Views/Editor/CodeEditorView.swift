//
//  CodeEditorView.swift
//  FlowKit
//
//  Code editor view with syntax highlighting placeholder
//

import SwiftUI

struct CodeEditorView: View {
    let tab: EditorTab?
    @Environment(\.colorScheme) private var colorScheme
    @State private var content: String = ""
    @State private var cursorPosition: Int = 0
    
    var body: some View {
        VStack(spacing: 0) {
            if let tab = tab {
                // Editor content
                ScrollView {
                    HStack(alignment: .top, spacing: 0) {
                        // Line numbers
                        lineNumbers
                        
                        // Code content
                        codeContent
                    }
                    .padding(.vertical, 8)
                }
                .background(FlowPalette.Semantic.background(colorScheme))
            } else {
                emptyState
            }
        }
    }
    
    private var lineNumbers: some View {
        VStack(alignment: .trailing, spacing: 0) {
            ForEach(1...max(content.components(separatedBy: "\n").count, 20), id: \.self) { line in
                Text("\(line)")
                    .font(.system(size: 12, design: .monospaced))
                    .foregroundStyle(FlowPalette.Text.tertiary(colorScheme))
                    .frame(height: 20)
            }
        }
        .padding(.horizontal, 12)
        .background(FlowPalette.Semantic.surface(colorScheme).opacity(0.5))
    }
    
    private var codeContent: some View {
        VStack(alignment: .leading, spacing: 0) {
            TextEditor(text: $content)
                .font(.system(size: 13, design: .monospaced))
                .scrollContentBackground(.hidden)
                .background(Color.clear)
        }
        .padding(.leading, 8)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var emptyState: some View {
        VStack(spacing: 16) {
            Image(systemName: "doc.text")
                .font(.system(size: 48))
                .foregroundStyle(FlowPalette.Text.tertiary(colorScheme))
            
            Text("No File Open")
                .font(.headline)
                .foregroundStyle(FlowPalette.Text.secondary(colorScheme))
            
            Text("Open a file from the explorer or use ⌘O")
                .font(.subheadline)
                .foregroundStyle(FlowPalette.Text.tertiary(colorScheme))
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(FlowPalette.Semantic.background(colorScheme))
    }
}

// MARK: - Preview

#Preview {
    CodeEditorView(tab: EditorTab.forFile("/test/example.swift"))
        .frame(width: 600, height: 400)
        .preferredColorScheme(.dark)
}
