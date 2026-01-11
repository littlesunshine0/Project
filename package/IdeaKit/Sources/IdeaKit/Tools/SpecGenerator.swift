//
//  SpecGenerator.swift
//  IdeaKit - Project Operating System
//
//  Tool: SpecGenerator
//  Phase: Specification
//  Purpose: Generate living specs from intent
//  Outputs: requirements.md, functional_spec.md, nonfunctional_spec.md
//

import Foundation

/// Generates project specifications from intent
public final class SpecGenerator: ProjectTool, @unchecked Sendable {
    
    // MARK: - ProjectTool Conformance
    
    public static let id = "spec_generator"
    public static let name = "Spec Generator"
    public static let description = "Generate living specifications from project intent"
    public static let phase = ProjectPhase.specification
    public static let outputs = ["requirements.md", "functional_spec.md", "nonfunctional_spec.md"]
    public static let inputs = ["intent.json"]
    public static let isDefault = true
    
    // MARK: - Singleton
    
    public static let shared = SpecGenerator()
    private init() {}
    
    // MARK: - Generation
    
    /// Generate specification from intent
    public func generate(from intent: ProjectIntent) async throws -> Specification {
        let requirements = generateRequirements(from: intent)
        let functional = generateFunctionalSpec(from: intent)
        let nonFunctional = generateNonFunctionalSpec(from: intent)
        let criteria = generateAcceptanceCriteria(from: intent)
        
        return Specification(
            requirements: requirements,
            functional: functional,
            nonFunctional: nonFunctional,
            acceptanceCriteria: criteria
        )
    }
    
    // MARK: - Requirements Generation
    
    private func generateRequirements(from intent: ProjectIntent) -> String {
        """
        # Requirements Document
        
        ## Project Overview
        
        **Problem**: \(intent.problemStatement)
        
        **Target User**: \(intent.targetUser)
        
        **Value Proposition**: \(intent.valueProposition)
        
        ## Functional Requirements
        
        ### Core Features
        
        1. **FR-001**: Primary user workflow implementation
           - Priority: Critical
           - Status: Pending
        
        2. **FR-002**: User authentication and authorization
           - Priority: High
           - Status: Pending
        
        3. **FR-003**: Data persistence and retrieval
           - Priority: High
           - Status: Pending
        
        ### Secondary Features
        
        4. **FR-004**: User preferences and settings
           - Priority: Medium
           - Status: Pending
        
        5. **FR-005**: Export and sharing capabilities
           - Priority: Low
           - Status: Pending
        
        ## Non-Functional Requirements
        
        1. **NFR-001**: Response time < 200ms for common operations
        2. **NFR-002**: Support for offline operation
        3. **NFR-003**: Accessibility compliance (WCAG 2.1 AA)
        4. **NFR-004**: Data encryption at rest and in transit
        
        ## Constraints
        
        \(intent.constraints.map { "- \($0)" }.joined(separator: "\n"))
        
        ## Out of Scope
        
        \(intent.nonGoals.map { "- \($0)" }.joined(separator: "\n"))
        """
    }
    
    private func generateFunctionalSpec(from intent: ProjectIntent) -> String {
        """
        # Functional Specification
        
        ## 1. Introduction
        
        This document describes the functional behavior of the \(intent.projectType.rawValue) project.
        
        ### 1.1 Purpose
        \(intent.valueProposition)
        
        ### 1.2 Scope
        This specification covers the core functionality required for MVP.
        
        ## 2. User Workflows
        
        ### 2.1 Primary Workflow
        
        ```
        User → Opens Application → Performs Core Action → Sees Result → Saves/Exports
        ```
        
        ### 2.2 Secondary Workflows
        
        - Settings configuration
        - Data management
        - Help and documentation access
        
        ## 3. Feature Specifications
        
        ### 3.1 Core Feature
        
        **Description**: Main functionality that delivers the value proposition
        
        **Inputs**:
        - User input data
        - Configuration settings
        
        **Outputs**:
        - Processed result
        - Status feedback
        
        **Behavior**:
        1. User initiates action
        2. System validates input
        3. System processes request
        4. System displays result
        
        ### 3.2 Data Management
        
        **Description**: CRUD operations for user data
        
        **Operations**:
        - Create: Add new items
        - Read: View existing items
        - Update: Modify items
        - Delete: Remove items
        
        ## 4. Error Handling
        
        | Error Type | User Message | Recovery Action |
        |------------|--------------|-----------------|
        | Invalid Input | "Please check your input" | Highlight field |
        | Network Error | "Connection lost" | Retry button |
        | System Error | "Something went wrong" | Contact support |
        
        ## 5. Success Criteria
        
        \(intent.successCriteria.enumerated().map { index, criterion in "\\(index + 1). \\(criterion)" }.joined(separator: "\n"))
        """
    }
    
    private func generateNonFunctionalSpec(from intent: ProjectIntent) -> String {
        """
        # Non-Functional Specification
        
        ## 1. Performance Requirements
        
        | Metric | Target | Measurement |
        |--------|--------|-------------|
        | Response Time | < 200ms | 95th percentile |
        | Startup Time | < 3s | Cold start |
        | Memory Usage | < 100MB | Typical usage |
        
        ## 2. Reliability Requirements
        
        - **Availability**: 99.9% uptime
        - **Data Durability**: No data loss on crash
        - **Recovery Time**: < 5 minutes
        
        ## 3. Security Requirements
        
        - Data encryption at rest (AES-256)
        - Data encryption in transit (TLS 1.3)
        - Secure credential storage
        - Input validation and sanitization
        
        ## 4. Usability Requirements
        
        - Intuitive navigation (< 3 clicks to any feature)
        - Consistent UI patterns
        - Keyboard accessibility
        - Screen reader support
        
        ## 5. Compatibility Requirements
        
        - **Platform**: \(platformRequirements(for: intent.projectType))
        - **Backward Compatibility**: Support previous data formats
        
        ## 6. Maintainability Requirements
        
        - Code coverage > 80%
        - Documentation for all public APIs
        - Modular architecture
        - Automated testing pipeline
        """
    }
    
    private func generateAcceptanceCriteria(from intent: ProjectIntent) -> [AcceptanceCriterion] {
        [
            AcceptanceCriterion(
                feature: "Core Workflow",
                given: "User has opened the application",
                when: "User performs the primary action",
                then: "System completes the action and shows success feedback"
            ),
            AcceptanceCriterion(
                feature: "Data Persistence",
                given: "User has created data",
                when: "User closes and reopens the application",
                then: "Previously created data is still available"
            ),
            AcceptanceCriterion(
                feature: "Error Handling",
                given: "User provides invalid input",
                when: "User submits the form",
                then: "System shows clear error message and highlights the issue"
            )
        ]
    }
    
    private func platformRequirements(for type: ProjectType) -> String {
        switch type {
        case .app: return "macOS 13+, iOS 16+"
        case .cli: return "macOS, Linux, Windows"
        case .library, .framework: return "Swift 5.9+"
        case .api, .saas: return "Cloud-native, containerized"
        default: return "Cross-platform"
        }
    }
}
