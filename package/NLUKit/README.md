# NLUKit

Natural Language Understanding System for Swift projects.

## Features

- **Intent Classification** - Classify user intent from text
- **Entity Extraction** - Extract entities (names, paths, URLs, numbers)
- **Real-Time Prediction** - <200ms latency predictions
- **Text Embeddings** - Generate text embeddings

## Supported Intents

- Workflow: create, execute, pause, resume, delete, list
- Documentation: search, ingest, view
- Analytics: view, generate report, identify bottlenecks
- Settings: configure, view, update preferences
- Commands: execute, list
- Collaboration: share, view shared, collaborate
- History: view, re-execute
- Feedback: provide, rate

## Usage

```swift
import NLUKit

// Classify intent
let intent = await NLUKit.classifyIntent("run the build workflow")
print(intent.type)       // .executeWorkflow
print(intent.confidence) // 0.85

// Extract entities
let entities = await NLUKit.extractEntities("run \"Build App\" at /projects/myapp")
// Returns: workflowName="Build App", directoryPath="/projects/myapp"

// Real-time prediction (optimized for <200ms)
let prediction = await NLUKit.predictRealtime("search do")
print(prediction.intent.type)           // .searchDocumentation
print(prediction.meetsLatencyRequirement) // true

// Generate embedding
let embedding = await NLUKit.embed("search documentation")
// Returns: [Float] with 384 dimensions
```

## Entity Types

- `workflowName` - Quoted workflow names
- `directoryPath` - File system paths
- `url` - HTTP/HTTPS URLs
- `number` - Numeric values
- `fileName` - File names
- `date`, `time` - Temporal values
- `projectName`, `userName`, `tag`

## Components

- `NLUEngine` - Main NLU engine (actor)
- `Intent` - Classified intent
- `Entity` - Extracted entity
- `IntentPrediction` - Real-time prediction result

## Tests

13 tests covering intent classification, entity extraction, and real-time prediction.
