# AIKit - Unified ML Intelligence Platform

A single, modular ML-powered platform that understands ideas, code, documents, systems, and decisions, and continuously improves how projects are planned, built, and evolved.

**One-Sentence Pitch:** A unified ML platform that understands ideas, systems, and decisions—and continuously helps you build better ones.

## Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│                    INTELLIGENCE ORCHESTRATOR                     │
│         (routing, confidence, conflict resolution, HITL)        │
└─────────────────────────────┬───────────────────────────────────┘
                              │
┌─────────────────────────────▼───────────────────────────────────┐
│                      CORE ML ENGINES                             │
├─────────────┬─────────────┬─────────────┬─────────────┬─────────┤
│Understanding│  Structure  │  Planning   │   Memory    │  Risk   │
│   Engine    │   Engine    │   Engine    │   Engine    │ Engine  │
└─────────────┴─────────────┴─────────────┴─────────────┴─────────┘
```

## Core Engines

### 1. Understanding Engine
**Purpose:** Turn unstructured input into structured meaning

- Intent extraction
- Requirement inference
- Ambiguity detection
- Assumption detection
- Contradiction detection

```swift
let result = await AIKit.understanding.understand("Build a REST API for user management")
print(result.intent)       // .create
print(result.assumptions)  // [Assumption...]
print(result.ambiguities)  // [Ambiguity...]
```

### 2. Structure Engine
**Purpose:** Learn how systems should be shaped

- Architecture pattern classification (MVC, MVVM, Clean, etc.)
- Coupling & cohesion analysis
- Reusable boundary detection
- Refactor opportunity detection
- System complexity estimation
- Architecture stability prediction

```swift
let classification = await AIKit.structure.classifyArchitecture(files: files)
print(classification.primaryPattern)  // "MVVM"
print(classification.consistencyScore) // 0.85
```

### 3. Planning Engine
**Purpose:** Predict how plans break and how to improve them

- Task decomposition learning
- Estimate accuracy prediction
- Critical path risk prediction
- Effort vs outcome optimization
- Feature ROI modeling

```swift
let decomposition = await AIKit.planning.decomposeTask(TaskInput(
    description: "Implement OAuth",
    estimatedHours: 40
))
print(decomposition.subtasks)
print(decomposition.criticalPath)
```

### 4. Memory Engine
**Purpose:** Maintain long-term, evolving intelligence

- Semantic project memory
- Context compression
- Knowledge decay prediction
- Doc-code alignment detection
- Change significance detection

```swift
await AIKit.memory.remember(projectId: "my-project", content: MemoryContent(
    type: .decision,
    summary: "Chose PostgreSQL for the database"
))

let recalled = await AIKit.memory.recall(projectId: "my-project", query: "database")
```

### 5. Risk Engine
**Purpose:** Know how confident the system should be

- Uncertainty estimation (aleatoric + epistemic)
- Failure mode prediction
- Belief revision (Bayesian-like updates)
- Bias detection (optimism, anchoring, confirmation, etc.)
- Metric reliability scoring
- Human-in-the-loop routing

```swift
let biases = await AIKit.risk.detectBiases(input: BiasDetectionInput(
    id: "estimate",
    text: "This should be easy and quick to implement"
))
// Detects: Optimism Bias
```

## Intelligence Orchestrator

The orchestrator provides high-level operations that combine multiple engines:

```swift
// Analyze an idea end-to-end
let analysis = await AIKit.orchestrator.analyzeIdea(
    "Build an AI-powered code review tool"
)
// Returns: understanding, requirements, assumptions, risks, 
//          uncertainty, bias check, human input recommendation

// Analyze a codebase
let health = await AIKit.orchestrator.analyzeCodebase(codebase)
// Returns: architecture, coupling, complexity, refactor opportunities,
//          reusable boundaries, stability prediction

// Plan a project
let plan = await AIKit.orchestrator.planProject(
    goal: "Implement user authentication",
    constraints: EffortConstraints(maxEffort: 80)
)
// Returns: decomposition, optimization, critical path risks,
//          estimate accuracies

// Support a decision
let support = await AIKit.orchestrator.supportDecision(decision)
// Returns: understanding, uncertainty, biases, human input recommendation,
//          relevant memories

// Monitor project health
let report = await AIKit.orchestrator.monitorProjectHealth(
    projectId: "my-project",
    codebase: codebase
)
// Returns: codebase analysis, knowledge decay, alerts, recommendations
```

## Why One Platform?

- **Shared representations** - Every capability shares the same data structures
- **Compounding improvements** - Improvements in one engine benefit all products
- **Configuration over code** - New apps are configuration, not rewrites
- **Reusable-package-first** - Aligned with the Kit ecosystem design

## Tests

29 tests covering all 5 engines and the orchestrator.

## Primary Product Surfaces

All powered by the same core:

1. **Idea → MVP System** - Idea understanding, spec generation, risk analysis
2. **Architecture Intelligence Suite** - Classification, refactoring, package detection
3. **Project Health Monitor** - Estimate accuracy, tech debt, knowledge decay
4. **Decision Intelligence Assistant** - Tradeoff simulation, bias detection, recommendations

---

Part of the FlowKit ecosystem.
