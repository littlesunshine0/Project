//
//  OutputView.swift
//  FlowKit
//
//  Output panel view for build and workflow output
//

import SwiftUI
import DesignKit
import Combine
import NavigationKit

struct OutputView: View {
    @StateObject private var viewModel = OutputViewModel()
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        VStack(spacing: 0) {
            if viewModel.outputs.isEmpty {
                VStack(spacing: 12) {
                    Image(systemName: "doc.text")
                        .font(.system(size: 28))
                        .foregroundStyle(FlowColors.Text.tertiary(colorScheme))
                    Text("Build output will appear here")
                        .font(FlowTypography.caption())
                        .foregroundStyle(FlowColors.Text.secondary(colorScheme))
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                ScrollView {
                    VStack(alignment: .leading, spacing: 8) {
                        ForEach(viewModel.outputs) { output in
                            OutputEntryLineView(output: output, colorScheme: colorScheme)
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(12)
                }
            }
        }
        .accessibilityLabel(viewModel.outputs.isEmpty ? "Output panel, empty" : "Output panel with \(viewModel.outputs.count) entries")
    }
}

// MARK: - Output Entry Line View

struct OutputEntryLineView: View {
    let output: OutputEntry
    let colorScheme: ColorScheme
    
    var body: some View {
        HStack(alignment: .top, spacing: 8) {
            Image(systemName: output.icon)
                .font(.system(size: 10))
                .foregroundStyle(output.color)
                .frame(width: 16)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(output.message)
                    .font(FlowTypography.mono(11))
                    .foregroundStyle(FlowColors.Text.primary(colorScheme))
                    .textSelection(.enabled)
                
                Text(output.timestamp, style: .time)
                    .font(FlowTypography.micro())
                    .foregroundStyle(FlowColors.Text.tertiary(colorScheme))
            }
        }
    }
}

// MARK: - Output Entry

struct OutputEntry: Identifiable {
    let id = UUID()
    let message: String
    let type: OutputType
    let timestamp: Date
    
    enum OutputType {
        case info, success, warning, error
    }
    
    var icon: String {
        switch type {
        case .info: return "info.circle"
        case .success: return "checkmark.circle"
        case .warning: return "exclamationmark.triangle"
        case .error: return "xmark.circle"
        }
    }
    
    var color: Color {
        switch type {
        case .info: return FlowColors.Status.info
        case .success: return FlowColors.Status.success
        case .warning: return FlowColors.Status.warning
        case .error: return FlowColors.Status.error
        }
    }
}

// MARK: - Output View Model

@MainActor
class OutputViewModel: ObservableObject {
    @Published var outputs: [OutputEntry] = []
    
    init() {
        NotificationCenter.default.addObserver(
            forName: .workflowCompleted,
            object: nil,
            queue: .main
        ) { [weak self] notification in
            guard let userInfo = notification.userInfo,
                  let name = userInfo["workflowName"] as? String,
                  let success = userInfo["success"] as? Bool else { return }
            
            Task { @MainActor in
                self?.outputs.append(OutputEntry(
                    message: "Workflow '\(name)' \(success ? "completed successfully" : "failed")",
                    type: success ? .success : .error,
                    timestamp: Date()
                ))
            }
        }
        
        NotificationCenter.default.addObserver(
            forName: .showOutputPanel,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            self?.objectWillChange.send()
        }
    }
    
    func addOutput(_ message: String, type: OutputEntry.OutputType = .info) {
        outputs.append(OutputEntry(message: message, type: type, timestamp: Date()))
    }
    
    func clear() {
        outputs.removeAll()
    }
}
