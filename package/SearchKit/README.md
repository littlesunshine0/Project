# SearchKit

Universal Search System for Swift projects.

## Features

- **Full-Text Search** - Search across all indexed content
- **Relevance Ranking** - Smart relevance scoring
- **Type Filtering** - Filter by content type
- **Quick Search** - Optimized top-10 results

## Usage

```swift
import SearchKit

// Index content
let item = SearchableItem(
    type: .document,
    title: "Swift Guide",
    content: "Learn Swift programming",
    path: "/docs/swift.md"
)
await SearchKit.index(item)

// Search
let results = await SearchKit.search("Swift")
for result in results {
    print("\(result.title) - \(result.relevance)")
}

// Quick search (top 10)
let quick = await SearchKit.quickSearch("guide")

// Search with filters
var filters = SearchFilters()
filters.includeCode = false
filters.maxResults = 20
let filtered = await SearchKit.search("api", filters: filters)

// Calculate relevance
let score = SearchKit.relevance(
    query: "swift",
    title: "Swift Guide",
    content: "Learn Swift programming"
)
```

## Result Types

- `.documentation` - API docs
- `.document` - General documents
- `.code` - Source code
- `.asset` - Assets/resources
- `.workflow` - Workflows
- `.project` - Projects
- `.template` - Templates
- `.command` - Commands
- `.file` - Generic files

## Components

- `SearchEngine` - Main search engine (actor)
- `SearchIndex` - Content index (actor)
- `RelevanceCalculator` - Relevance scoring
- `SearchResult` - Search result
- `SearchFilters` - Search filters

## Tests

9 tests covering indexing, search, and relevance.
