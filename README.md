# Open Responses Dart

[![pub package](https://img.shields.io/pub/v/open_responses_dart.svg)](https://pub.dev/packages/open_responses_dart)
[![License: Apache 2.0](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)

A Dart/Flutter client library for the Open Responses API specification.

Open Responses is an open-source specification for building multi-provider, interoperable LLM interfaces based on the OpenAI Responses API. This Dart package enables Flutter developers to integrate LLM capabilities into their applications with ease.

## Features

✨ **Complete Type Coverage** - All request/response types from the Open Responses specification  
🌊 **Streaming Support** - Built-in SSE (Server-Sent Events) streaming for real-time responses  
🔒 **Type-Safe** - Strongly typed API with comprehensive error handling  
⚡ **Async/Await** - Full support for Dart's async patterns  
🛠️ **Easy to Use** - Simple, intuitive API with builder patterns  
🎯 **Multi-Provider Ready** - Works with any Open Responses compatible API  
🚀 **Dart 3.10+** - Full support for dot shorthands syntax for cleaner code  

## Installation

Add this to your `pubspec.yaml`:

```yaml
dependencies:
  open_responses_dart: ^0.1.0
```

Then run:

```bash
dart pub get
```

## Quick Start

### Basic Usage

```dart
import 'package:open_responses_dart/open_responses_dart.dart';

void main() async {
  final client = Client(apiKey: 'your-api-key');

  final request = CreateResponseBody(
    model: 'gpt-4o',
    input: Input.items([
      ItemFactory.systemMessage('You are a helpful assistant.'),
      ItemFactory.userMessage('What is the capital of France?'),
    ]),
    temperature: 0.7,
    maxOutputTokens: 100,
  );

  try {
    final response = await client.createResponse(request);
    print('Response: ${response.output.first.content.first.text}');
  } on OpenResponsesException catch (e) {
    print('Error: ${e.message}');
  } finally {
    client.dispose();
  }
}
```

### Streaming Responses

```dart
import 'package:open_responses_dart/open_responses_dart.dart';

void main() async {
  final streamingClient = StreamingClient(apiKey: 'your-api-key');

  final request = CreateResponseBody(
    model: 'gpt-4o',
    input: Input.items([
      ItemFactory.userMessage('Count from 1 to 5'),
    ]),
  );

  await for (final event in streamingClient.streamResponse(request)) {
    if (event is OutputTextDeltaEvent) {
      print(event.delta); // Print each token as it arrives
    } else if (event is StreamDoneEvent) {
      break;
    }
  }
}
```

### Function Calling

```dart
import 'package:open_responses_dart/open_responses_dart.dart';

void main() async {
  final client = Client(apiKey: 'your-api-key');

  // Define a function tool
  final getWeatherTool = FunctionTool(name: 'get_weather')
      .withDescription('Get the current weather for a location')
      .withParameters({
        'type': 'object',
        'properties': {
          'location': {
            'type': 'string',
            'description': 'The city and state, e.g. San Francisco, CA',
          },
        },
        'required': ['location'],
      });

  final request = CreateResponseBody(
    model: 'gpt-4o',
    input: Input.items([
      ItemFactory.userMessage('What\'s the weather in San Francisco?'),
    ]),
    tools: [getWeatherTool],
    toolChoice: SimpleToolChoice(ToolChoice.auto),
  );

  final response = await client.createResponse(request);
  
  for (var item in response.output) {
    if (item is FunctionCallItem) {
      print('Function: ${item.name}');
      print('Arguments: ${item.arguments}');
      
      // Execute your function and send result back
    }
  }
}
```

## Core Concepts

### Items

Items are the fundamental unit of context in Open Responses:

```dart
// Create different types of items
final userMsg = ItemFactory.userMessage('Hello!');
final assistantMsg = ItemFactory.assistantMessage('Hi there!');
final systemMsg = ItemFactory.systemMessage('You are helpful.');
final devMsg = ItemFactory.developerMessage('Follow these rules.');
final reference = ItemFactory.reference('msg_123');
```

### Content Types

```dart
// Text input
final text = InputTextContent(text: 'Hello');

// Image input
final image = InputImageContent(
  imageUrl: 'https://example.com/image.png',
  detail: ImageDetail.high,
);

// File input
final file = InputFileContent(fileUrl: 'https://example.com/doc.pdf');

// Video input
final video = InputVideoContent(videoUrl: 'https://example.com/video.mp4');
```

### Tools

```dart
// Create a function tool
final tool = FunctionTool(name: 'search')
    .withDescription('Search the web')
    .withParameters({
      'type': 'object',
      'properties': {
        'query': {'type': 'string'}
      }
    })
    .withStrict(true);
```

## Dart 3.10 Dot Shorthands 🚀

This package fully supports Dart 3.10's dot shorthands syntax, allowing you to write cleaner, more concise code when the type can be inferred from context.

### Enum Shorthands

Instead of writing the full enum type, use dot shorthand when the context is clear:

```dart
// Instead of MessageRole.user
MessageRole role = .user;

// Instead of ToolChoice.auto
ToolChoice choice = .auto;

// Instead of ImageDetail.high
ImageDetail detail = .high;

// Perfect for switch expressions
String description = switch (role) {
  .user => 'End user input',
  .assistant => 'AI assistant',
  .system => 'System instructions',
  .developer => 'Developer guidance',
};

// Works in collections too
final roles = <MessageRole>[.user, .assistant, .system];

// Equality checks (shorthand must be on right side)
bool isAuto = choice == .auto;
```

### Constructor Shorthands

Use `.new()` or named constructors when the type is explicit:

```dart
// Instead of Input.items([...])
Input input = .items([
  ItemFactory.userMessage('Hello'),
]);

// TextFormat named constructors
TextFormat format = .text();
TextFormat jsonFormat = .jsonObject();

// Content creation with extension helpers
InputContent text = .text('Hello World');
InputContent image = .imageUrl('https://example.com/image.png');
```

### Real-World Example

Here's how dot shorthands make your API calls cleaner:

```dart
final request = CreateResponseBody(
  model: 'gpt-4o',
  input: .items([  // Input.items
    ItemFactory.systemMessage('You are helpful.'),
    ItemFactory.userMessage('Hello!'),
  ]),
  // Enum shorthands
  truncation: .auto,           // Truncation.auto
  serviceTier: .priority,      // ServiceTier.priority
  toolChoice: SimpleToolChoice(.auto),  // ToolChoice.auto
  reasoning: ReasoningConfig(
    effort: .high,             // ReasoningEffort.high
    summary: .detailed,        // ReasoningSummary.detailed
  ),
);
```

### Extension Helpers

Enable even more shorthands with these extension methods:

```dart
extension InputContentShorthand on InputContent {
  static InputContent text(String text) => InputTextContent(text: text);
  static InputContent imageUrl(String url) => InputImageContent(imageUrl: url);
  static InputContent fileUrl(String url) => InputFileContent(fileUrl: url);
}

extension TextFormatShorthand on TextFormat {
  static TextFormat text() => TextFormat(type: TextFormatType.text);
  static TextFormat jsonObject() => TextFormat(type: TextFormatType.jsonObject);
}
```

See the `example/dot_shorthands_demo.dart` file for a complete demonstration.

## API Reference

### Client

The `Client` class provides synchronous API calls:

```dart
final client = Client(apiKey: 'your-api-key');

// Create a response
final response = await client.createResponse(request);

// Get raw JSON response
final jsonString = await client.createResponseRaw(request);

// Don't forget to dispose
client.dispose();
```

### StreamingClient

The `StreamingClient` provides SSE streaming:

```dart
final streamingClient = StreamingClient(apiKey: 'your-api-key');

// Stream events
await for (final event in streamingClient.streamResponse(request)) {
  // Handle event
}

// Stream only text
await for (final text in streamingClient.streamText(request)) {
  print(text);
}

streamingClient.dispose();
```

### Types

All types from the Open Responses specification are available:

- `CreateResponseBody` - Request body for creating responses
- `ResponseResource` - Response from the API
- `Item` and its implementations (`MessageItem`, `FunctionCallItem`, etc.)
- `InputContent` / `OutputContent` - Content types
- `StreamingEvent` and its implementations
- `Tool` and `ToolChoiceParam` - Tool definitions
- Enums: `MessageRole`, `MessageStatus`, `ToolChoice`, etc.

## Examples

See the `example/` directory for complete working examples:

- `basic_usage.dart` - Simple API usage
- `streaming.dart` - Streaming responses
- `function_calling.dart` - Tool/Function calling

Run examples with:

```bash
cd example
dart basic_usage.dart
```

## Testing

Run the test suite:

```bash
dart test
```

## Platform Support

| Platform | Supported |
|----------|-----------|
| Android  | ✅        |
| iOS      | ✅        |
| Web      | ✅        |
| macOS    | ✅        |
| Windows  | ✅        |
| Linux    | ✅        |

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the Apache 2.0 License - see the [LICENSE](LICENSE) file for details.

## Resources

- [Open Responses Specification](https://github.com/openresponses/spec)
- [Pub.dev Package](https://pub.dev/packages/open_responses_dart)
- [API Documentation](https://pub.dev/documentation/open_responses_dart)

## Acknowledgments

This package is based on the Open Responses open specification, designed to enable portability, competition, and long-term stability for LLM APIs across vendors and platforms.
