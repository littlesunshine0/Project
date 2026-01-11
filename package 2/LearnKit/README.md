# LearnKit

Machine Learning & Prediction System for Swift projects.

## Features

- **Action Recording** - Record user actions for learning
- **Prediction** - Predict next likely actions
- **Suggestions** - Personalized action suggestions
- **Pattern Learning** - Learn from action sequences

## Usage

```swift
import LearnKit

// Record user actions
let action = UserAction(
    userId: "user123",
    actionType: .executeWorkflow,
    target: "build",
    context: ["project": "MyApp"]
)
await LearnKit.record(action)

// Predict next action
let context = PredictionContext(
    userId: "user123",
    currentFile: "main.swift",
    recentActions: [.openFile, .editFile]
)
let predictions = await LearnKit.predict(context: context)
for prediction in predictions {
    print("\(prediction.actionType) - \(prediction.confidence)")
}

// Get suggestions
let suggestions = await LearnKit.suggest(for: "user123", limit: 5)
for suggestion in suggestions {
    print("\(suggestion.title): \(suggestion.description)")
}

// Train with historical data
let trainingData = TrainingData(actions: historicalActions)
await LearnKit.train(with: [trainingData])
```

## Action Types

- `executeWorkflow` - Run a workflow
- `createWorkflow` - Create new workflow
- `searchDocs` - Search documentation
- `viewAnalytics` - View analytics
- `runCommand` - Execute command
- `openFile` - Open a file
- `editFile` - Edit a file
- `saveFile` - Save a file

## Prediction Methods

1. **Pattern-based** - Learn from action sequences
2. **Frequency-based** - Most common actions per user
3. **Time-based** - Actions common at specific times

## Components

- `LearningEngine` - Main learning engine (actor)
- `UserAction` - Recorded user action
- `Prediction` - Predicted action
- `Suggestion` - Personalized suggestion
- `PredictionContext` - Context for predictions
- `TrainingData` - Training data container

## Tests

9 tests covering recording, prediction, and training.
