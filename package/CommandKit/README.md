# CommandKit

Professional Command Parsing & Autocomplete System.

## Features

- **Slash Commands** - Parse `/command arg1 arg2` syntax
- **Autocomplete** - Real-time command suggestions
- **Inline Help** - Context-aware help text
- **Command Registry** - Register custom commands

## Built-in Commands

- `/workflow` - Execute workflows
- `/docs` - Search documentation
- `/analytics` - View analytics
- `/config` - Configure settings
- `/help` - Show help
- `/list` - List items
- `/clear` - Clear screen

## Usage

```swift
import CommandKit

// Parse a command
let cmd = try await CommandKit.parse("/workflow build --verbose")
print(cmd.type)       // .workflow
print(cmd.arguments)  // ["build", "--verbose"]

// Check if input is a command
if CommandKit.isCommand(input) {
    // Handle command
}

// Get autocomplete suggestions
let suggestions = await CommandKit.autocomplete("/wo")
// Returns suggestions for /workflow

// Get inline help
let help = await CommandKit.getHelp(for: "/workflow")

// Register custom command
let custom = SlashCommand(
    name: "deploy",
    description: "Deploy to production",
    syntax: "/deploy <env>",
    category: .workflow
)
await CommandKit.register(custom)
```

## Components

- `CommandParser` - Parse slash commands (actor)
- `CommandRegistry` - Command registration (actor)
- `AutoCompleteService` - Autocomplete suggestions (actor)
- `SlashCommand` - Command definition
- `ParsedCommand` - Parsed command result

## Tests

11 tests covering parsing, autocomplete, and registration.
