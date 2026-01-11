//
//  TerminalView.swift
//  FlowKit
//
//  Terminal panel view for command execution
//

import SwiftUI
import DesignKit
import Combine
import NavigationKit

struct TerminalView: View {
    @StateObject private var viewModel = TerminalViewModel()
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        VStack(spacing: 0) {
            ScrollViewReader { proxy in
                ScrollView {
                    VStack(alignment: .leading, spacing: 6) {
                        ForEach(viewModel.history) { entry in
                            TerminalEntryLineView(
                                prompt: entry.directory,
                                command: entry.command,
                                output: entry.output,
                                isError: entry.isError
                            )
                        }
                        
                        Color.clear.frame(height: 1).id("bottom")
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(12)
                }
                .onChange(of: viewModel.history.count) { _, _ in
                    withAnimation { proxy.scrollTo("bottom") }
                }
            }
            
            Divider()
            
            HStack(spacing: 8) {
                Text("$")
                    .font(FlowTypography.mono(12))
                    .foregroundStyle(FlowColors.Status.success)
                
                TextField("Enter command...", text: $viewModel.currentCommand)
                    .textFieldStyle(.plain)
                    .font(FlowTypography.mono(12))
                    .onSubmit { viewModel.executeCommand() }
                
                if viewModel.isExecuting {
                    ProgressView()
                        .scaleEffect(0.6)
                }
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 10)
            .background(FlowColors.Semantic.canvas(colorScheme))
        }
        .accessibilityLabel("Terminal")
    }
}

// MARK: - Terminal View Model

@MainActor
class TerminalViewModel: ObservableObject {
    @Published var history: [TerminalEntry] = []
    @Published var currentCommand = ""
    @Published var isExecuting = false
    
    struct TerminalEntry: Identifiable {
        let id = UUID()
        let directory: String
        let command: String?
        let output: String?
        let isError: Bool
        let timestamp: Date
    }
    
    init() {
        history.append(TerminalEntry(
            directory: "~",
            command: nil,
            output: "FlowKit Terminal - Type commands and press Enter",
            isError: false,
            timestamp: Date()
        ))
        
        NotificationCenter.default.addObserver(
            forName: .showTerminalPanel,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            self?.objectWillChange.send()
        }
    }
    
    func executeCommand() {
        guard !currentCommand.trimmingCharacters(in: .whitespaces).isEmpty else { return }
        
        let cmd = currentCommand
        currentCommand = ""
        isExecuting = true
        
        history.append(TerminalEntry(
            directory: "~",
            command: cmd,
            output: nil,
            isError: false,
            timestamp: Date()
        ))
        
        // Simulate command execution
        Task {
            try? await Task.sleep(nanoseconds: 500_000_000)
            
            await MainActor.run {
                history.append(TerminalEntry(
                    directory: "~",
                    command: nil,
                    output: "Command '\(cmd)' executed",
                    isError: false,
                    timestamp: Date()
                ))
                isExecuting = false
            }
        }
    }
}

// MARK: - Terminal Entry Line View

struct TerminalEntryLineView: View {
    let prompt: String
    let command: String?
    let output: String?
    var isError: Bool = false
    
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            if let cmd = command {
                HStack(spacing: 6) {
                    Text(prompt)
                        .foregroundStyle(FlowColors.Status.info)
                    Text("$")
                        .foregroundStyle(FlowColors.Status.success)
                    Text(cmd)
                        .foregroundStyle(FlowColors.Text.primary(colorScheme))
                }
                .font(FlowTypography.mono(12))
            }
            
            if let out = output {
                Text(out)
                    .font(FlowTypography.mono(12))
                    .foregroundStyle(isError ? FlowColors.Status.error : FlowColors.Text.secondary(colorScheme))
                    .padding(.leading, command != nil ? 16 : 0)
                    .textSelection(.enabled)
            }
        }
    }
}
