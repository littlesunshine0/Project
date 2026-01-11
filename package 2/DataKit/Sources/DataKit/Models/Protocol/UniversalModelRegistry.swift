//
//  UniversalModelRegistry.swift
//  DataKit
//
//  FlowKit Package Standard v1.0
//  18 Categories, ~210 Files
//

import Foundation

/// Registry of all universal models for reflection/generation
public struct UniversalModelRegistry {
    
    /// Total category count
    public static let categoryCount = 18
    
    /// All model type names in the universal contract
    public static let allModels: [String] = [
        // Identity & Classification (6)
        "PackageModel", "PackageCategory", "PackageKind", "PackageType", "PackageSection", "PackageFormat",
        // Core Domain-Agnostic (12)
        "NodeModel", "ActionModel", "ResultModel", "ErrorModel", "StateModel", "EventModel", "AnyCodable", "NodeMetadata", "ParameterModel", "ParameterType", "ActionCategory", "EventSeverity",
        // Error & Recovery (7)
        "ErrorCategory", "ErrorSeverity", "RecoveryAction", "FallbackModel", "ValidationIssue", "ValidationSeverity", "ErrorModel",
        // Execution & Automation (13)
        "TaskModel", "StepModel", "WorkflowModel", "CommandModel", "AgentModel", "ExecutionContext", "ExecutionResult", "TriggerModel", "TriggerType", "AgentConfig", "AgentPriority", "TaskPriority", "TaskStatus",
        // UI & UX Surface (18)
        "ViewModel", "ViewDescriptor", "LayoutModel", "MenuModel", "MenuItemModel", "MenuType", "ToolbarItem", "ToolbarPlacement", "DockItem", "InspectorPanel", "InspectorSection", "InspectorField", "FieldType", "BreadcrumbModel", "BreadcrumbItem", "FooterStatus", "FooterStatusItem", "ViewType",
        // Navigation (9)
        "NavigationNode", "RouteModel", "SidebarSection", "SidebarItem", "InspectorRoute", "TabModel", "NavigationContext", "NavigationHistory", "NavigationEntry",
        // Content & Documentation (15)
        "ContentModel", "DocumentModel", "SectionModel", "GuideModel", "GuideStep", "WalkthroughModel", "WalkthroughStep", "ChecklistModel", "ChecklistItem", "MilestoneModel", "ExampleModel", "ContentType", "ContentFormat", "ContentMetadata", "Difficulty",
        // State (10)
        "AppState", "PackageState", "ViewState", "ExecutionState", "LoadState", "SyncState", "ValidationState", "ErrorState", "EmptyState", "FocusState",
        // Feedback & Notification (18)
        "StatusModel", "StatusType", "ProgressModel", "ProgressStatus", "NotificationModel", "NotificationType", "BannerModel", "BannerType", "BannerAction", "AlertModel", "AlertType", "AlertButton", "AlertButtonStyle", "FeedbackModel", "FeedbackType", "AchievementModel", "ActivityModel", "ActivityType",
        // ML & Intelligence (14)
        "MLContext", "MLParameters", "EmbeddingModel", "PredictionModel", "PredictionType", "PredictionAlternative", "RecommendationModel", "RecommendationType", "RecommendationItem", "ExplanationModel", "ExplanationType", "ExplanationFactor", "ConfidenceModel", "ConfidenceLevel",
        // Accessibility, Motion & Theming (20)
        "AccessibilityModel", "AccessibilityTrait", "AccessibilityAction", "MotionModel", "AnimationIntent", "AnimationType", "AnimationCurve", "ThemeModel", "ThemeColors", "ThemeTypography", "ThemeSpacing", "ThemeCornerRadius", "Appearance", "ColorModel", "IconModel", "IconType", "IconSize", "LayoutPreference", "LayoutDensity", "SidebarPosition",
        // User, Settings & Personalization (12)
        "UserModel", "PreferenceModel", "NotificationPreferences", "AccessibilityPreferences", "PrivacyPreferences", "SettingModel", "SettingType", "SettingOption", "PermissionModel", "PermissionType", "RoleModel", "ShortcutModel",
        // System, Lifecycle & Infrastructure (12)
        "LifecycleModel", "LifecycleState", "LifecycleTransition", "VersionModel", "DependencyModel", "DependencyType", "CapabilityModel", "ConstraintModel", "ConstraintType", "HealthModel", "HealthStatus", "HealthCheck",
        // File, Asset & Format (12)
        "FileModel", "FileType", "FileMetadata", "AssetModel", "AssetType", "AssetDimensions", "FormatModel", "FormatCategory", "EncodingModel", "PreviewModel", "PreviewType", "TransformModel",
        // Telemetry & Analytics (7)
        "MetricModel", "MetricType", "EventMetric", "DurationMetric", "CounterMetric", "TraceModel", "SessionModel", "AttributionModel",
        // Distribution & Marketplace (6)
        "PackageListing", "LicenseModel", "PricingModel", "Attribution", "UpdatePolicy", "CompatibilityMatrix",
        // Validation & Testing (6)
        "ValidationRule", "ValidationResult", "ComplianceReport", "CoverageModel", "QualityGate", "CertificationStatus"
    ]
    
    /// Model categories for organization (18 total)
    public static let modelCategories: [String: [String]] = [
        "identity": ["PackageModel", "PackageCategory", "PackageKind", "PackageType", "PackageSection", "PackageFormat"],
        "core": ["NodeModel", "ActionModel", "ResultModel", "StateModel", "EventModel", "AnyCodable", "NodeMetadata", "ParameterModel", "ParameterType", "ActionCategory", "EventSeverity", "ResultMetadata"],
        "error": ["ErrorModel", "ErrorCategory", "ErrorSeverity", "RecoveryAction", "FallbackModel", "ValidationIssue", "ValidationSeverity"],
        "execution": ["TaskModel", "StepModel", "WorkflowModel", "CommandModel", "AgentModel", "ExecutionContext", "ExecutionResult", "TriggerModel", "TriggerType", "AgentConfig", "AgentPriority", "TaskPriority", "TaskStatus"],
        "ui": ["ViewModel", "ViewDescriptor", "LayoutModel", "MenuModel", "MenuItemModel", "MenuType", "ToolbarItem", "ToolbarPlacement", "DockItem", "InspectorPanel", "InspectorSection", "InspectorField", "FieldType", "BreadcrumbModel", "BreadcrumbItem", "FooterStatus", "FooterStatusItem", "ViewType"],
        "navigation": ["NavigationNode", "RouteModel", "SidebarSection", "SidebarItem", "InspectorRoute", "TabModel", "NavigationContext", "NavigationHistory"],
        "content": ["ContentModel", "DocumentModel", "SectionModel", "GuideModel", "GuideStep", "WalkthroughModel", "WalkthroughStep", "ChecklistModel", "ChecklistItem", "MilestoneModel", "ExampleModel", "ContentType", "ContentFormat", "ContentMetadata", "Difficulty"],
        "state": ["AppState", "PackageState", "ViewState", "ExecutionState", "LoadState", "SyncState", "ValidationState", "ErrorState", "EmptyState", "FocusState"],
        "feedback": ["StatusModel", "StatusType", "ProgressModel", "ProgressStatus", "NotificationModel", "NotificationType", "BannerModel", "BannerType", "BannerAction", "AlertModel", "AlertType", "AlertButton", "AlertButtonStyle", "FeedbackModel", "FeedbackType", "AchievementModel", "ActivityModel", "ActivityType"],
        "ml": ["MLContext", "MLParameters", "EmbeddingModel", "PredictionModel", "PredictionType", "PredictionAlternative", "RecommendationModel", "RecommendationType", "RecommendationItem", "ExplanationModel", "ExplanationType", "ExplanationFactor", "ConfidenceModel", "ConfidenceLevel"],
        "accessibility": ["AccessibilityModel", "AccessibilityTrait", "AccessibilityAction", "MotionModel", "AnimationIntent", "AnimationType", "AnimationCurve", "ThemeModel", "ThemeColors", "ThemeTypography", "ThemeSpacing", "ThemeCornerRadius", "Appearance", "ColorModel", "IconModel", "IconType", "IconSize", "LayoutPreference", "LayoutDensity", "SidebarPosition"],
        "user": ["UserModel", "PreferenceModel", "NotificationPreferences", "AccessibilityPreferences", "PrivacyPreferences", "SettingModel", "SettingType", "SettingOption", "PermissionModel", "PermissionType", "RoleModel", "ShortcutModel"],
        "system": ["LifecycleModel", "LifecycleState", "LifecycleTransition", "VersionModel", "DependencyModel", "DependencyType", "CapabilityModel", "ConstraintModel", "ConstraintType", "HealthModel", "HealthStatus", "HealthCheck"],
        "file": ["FileModel", "FileType", "FileMetadata", "AssetModel", "AssetType", "AssetDimensions", "FormatModel", "FormatCategory", "EncodingModel", "PreviewModel", "PreviewType", "TransformModel"],
        "telemetry": ["MetricModel", "MetricType", "EventMetric", "DurationMetric", "CounterMetric", "TraceModel", "SessionModel", "AttributionModel"],
        "distribution": ["PackageListing", "LicenseModel", "PricingModel", "Attribution", "UpdatePolicy", "CompatibilityMatrix"],
        "validation": ["ValidationRule", "ValidationResult", "ComplianceReport", "CoverageModel", "QualityGate", "CertificationStatus"],
        "protocol": ["FlowKitPackageModels", "PackageContract", "PackageCapability", "PackageManifest", "PackageValidator", "DefaultPackageModels"]
    ]
    
    /// Required files for package compliance
    public static let requiredContractFiles = [
        "Package.manifest.json",
        "Package.capabilities.json",
        "Package.state.json",
        "Package.actions.json",
        "Package.ui.json",
        "Package.agents.json",
        "Package.workflows.json"
    ]
}
