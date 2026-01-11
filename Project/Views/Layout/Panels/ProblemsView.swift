//
//  ProblemsView.swift
//  FlowKit
//
//  Problems panel view for displaying errors and warnings
//

import SwiftUI
import DesignKit
import Combine
import NavigationKit

struct ProblemsView: View {
    @StateObject private var viewModel = ProblemsViewModel()
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        VStack(spacing: 0) {
            if viewModel.problems.isEmpty {
                VStack(spacing: 12) {
                    ZStack {
                        Circle()
                            .fill(FlowColors.Status.success.opacity(0.15))
                            .frame(width: 48, height: 48)
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 24))
                            .foregroundStyle(FlowColors.Status.success)
                    }
                    Text("No problems detected")
                        .font(FlowTypography.body(.medium))
                        .foregroundStyle(FlowColors.Text.primary(colorScheme))
                    Text("Your code is looking good!")
                        .font(FlowTypography.caption())
                        .foregroundStyle(FlowColors.Text.secondary(colorScheme))
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                // Problems header
                HStack {
                    Label("\(viewModel.errorCount) Errors", systemImage: "xmark.circle.fill")
                        .foregroundStyle(FlowColors.Status.error)
                    Label("\(viewModel.warningCount) Warnings", systemImage: "exclamationmark.triangle.fill")
                        .foregroundStyle(FlowColors.Status.warning)
                    Spacer()
                }
                .font(FlowTypography.caption(.medium))
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(FlowColors.Border.subtle(colorScheme))
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 4) {
                        ForEach(viewModel.problems) { problem in
                            ProblemRowView(problem: problem, colorScheme: colorScheme)
                        }
                    }
                    .padding(8)
                }
            }
        }
        .accessibilityLabel(viewModel.problems.isEmpty ? "No problems detected" : "\(viewModel.problems.count) problems")
    }
}

// MARK: - Problem Row

struct ProblemRowView: View {
    let problem: ProblemEntry
    let colorScheme: ColorScheme
    
    var body: some View {
        HStack(alignment: .top, spacing: 8) {
            Image(systemName: problem.isError ? "xmark.circle.fill" : "exclamationmark.triangle.fill")
                .font(.system(size: 12))
                .foregroundStyle(problem.isError ? FlowColors.Status.error : FlowColors.Status.warning)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(problem.message)
                    .font(FlowTypography.body())
                    .foregroundStyle(FlowColors.Text.primary(colorScheme))
                
                Text("\(problem.file):\(problem.line)")
                    .font(FlowTypography.mono(10))
                    .foregroundStyle(FlowColors.Text.tertiary(colorScheme))
            }
            
            Spacer()
        }
        .padding(8)
        .background(
            RoundedRectangle(cornerRadius: FlowRadius.sm)
                .fill(problem.isError ? FlowColors.Status.error.opacity(0.05) : FlowColors.Status.warning.opacity(0.05))
        )
    }
}

// MARK: - Problem Entry

struct ProblemEntry: Identifiable {
    let id = UUID()
    let message: String
    let file: String
    let line: Int
    let isError: Bool
}

// MARK: - Problems View Model

@MainActor
class ProblemsViewModel: ObservableObject {
    @Published var problems: [ProblemEntry] = []
    
    var errorCount: Int { problems.filter { $0.isError }.count }
    var warningCount: Int { problems.filter { !$0.isError }.count }
    
    init() {
        NotificationCenter.default.addObserver(
            forName: .showProblemsPanel,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            self?.objectWillChange.send()
        }
    }
    
    func addProblem(_ message: String, file: String, line: Int, isError: Bool) {
        problems.append(ProblemEntry(message: message, file: file, line: line, isError: isError))
    }
    
    func clear() {
        problems.removeAll()
    }
}
