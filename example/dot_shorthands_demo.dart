import 'package:open_responses_dart/open_responses_dart.dart';

/// Demonstrates Dart 3.10 dot shorthands syntax with Open Responses
///
/// Dot shorthands allow you to write more concise code by omitting the type
/// when the compiler can infer it from context.
void main() async {
  print('=== Dart 3.10 Dot Shorthands Demo ===\n');

  // 1. Enum shorthands
  print('1. Enum Dot Shorthands:');
  demonstrateEnumShorthands();

  // 2. Constructor shorthands (where applicable)
  print('\n2. Constructor Shorthands:');
  demonstrateConstructorShorthands();

  // 3. Static method shorthands
  print('\n3. Static Method Shorthands:');
  demonstrateStaticShorthands();

  // 4. Real-world API usage with shorthands
  print('\n4. Real-World API Example:');
  await demonstrateApiUsage();
}

void demonstrateEnumShorthands() {
  // Instead of: MessageRole.user
  MessageRole role = .user;
  print('  MessageRole: $role');

  // Instead of: ToolChoice.auto
  ToolChoice toolChoice = .auto;
  print('  ToolChoice: $toolChoice');

  // Instead of: ImageDetail.high
  ImageDetail detail = .high;
  print('  ImageDetail: $detail');

  // In switch expressions - very clean!
  String description = switch (role) {
    .user => 'End user input',
    .assistant => 'AI assistant response',
    .system => 'System-level instructions',
    .developer => 'Developer guidance',
  };
  print('  Switch result: $description');

  // In collections with explicit types
  final roles = <MessageRole>[.user, .assistant, .system];
  print('  List of roles: $roles');

  // In equality checks (must be on RIGHT side)
  bool isUser = role == .user;
  print('  Is user role: $isUser');
}

void demonstrateConstructorShorthands() {
  // When type is explicit, you can use .new() or named constructors
  // This works well for simple constructors

  // Input with explicit type can use factory constructor shorthand
  Input input = .items([ItemFactory.userMessage('Hello')]);
  print('  Input created with shorthand');

  // TextFormat with named constructors
  TextFormat format = .text();
  print('  TextFormat: ${format.type}');

  TextFormat jsonFormat = .jsonObject();
  print('  TextFormat JSON: ${jsonFormat.type}');

  // Content with static factory-like methods
  InputContent text = .text('Hello World');
  print('  InputContent: ${text.type}');
}

void demonstrateStaticShorthands() {
  // For types with static methods, when context is clear
  // Note: Most of our types use instance methods rather than static

  // Example with int.parse - Dart built-in
  int port = .parse('8080');
  print('  Parsed port: $port');

  // Example with double.parse
  double value = .parse('3.14');
  print('  Parsed double: $value');

  // Example with Uri.parse
  Uri url = .parse('https://api.example.com');
  print('  Parsed URI: $url');
}

Future<void> demonstrateApiUsage() async {
  final client = Client(apiKey: 'demo-key');

  // Create a request using dot shorthands throughout
  final request = CreateResponseBody(
    model: 'gpt-4o',
    input: .items([
      // Input.items shorthand
      ItemFactory.systemMessage('You are a helpful assistant.'),
      ItemFactory.userMessage('What is the weather?'),
    ]),
    // Enum shorthands for configuration
    truncation: .auto, // Instead of Truncation.auto
    serviceTier: .default_, // Instead of ServiceTier.default_
    temperature: 0.7,
    maxOutputTokens: 150,
  );

  print('  Request created with:');
  print('    - Truncation: ${request.truncation}');
  print('    - Service Tier: ${request.serviceTier}');

  // Function tool with dot shorthand for strict flag
  final tool = FunctionTool(name: 'get_weather')
      .withDescription('Get weather for a location')
      .withParameters({
        'type': 'object',
        'properties': {
          'location': {'type': 'string'},
        },
      })
      .withStrict(true);

  // Tool choice with enum shorthand
  final toolChoice = SimpleToolChoice(.auto); // Instead of ToolChoice.auto
  print('  Tool choice: ${(toolChoice as SimpleToolChoice).choice}');

  // Demonstrate reasoning config with shorthands
  final reasoningConfig = ReasoningConfig(
    effort: .high, // Instead of ReasoningEffort.high
    summary: .detailed, // Instead of ReasoningSummary.detailed
  );
  print('  Reasoning effort: ${reasoningConfig.effort}');

  client.dispose();
  print('  ✅ Demo complete!');
}

// Extension to enable more dot shorthand patterns
extension InputContentShorthand on InputContent {
  static InputContent text(String text) => InputTextContent(text: text);
  static InputContent imageUrl(String url) => InputImageContent(imageUrl: url);
  static InputContent fileUrl(String url) => InputFileContent(fileUrl: url);
  static InputContent videoUrl(String url) => InputVideoContent(videoUrl: url);
}

extension TextFormatShorthand on TextFormat {
  static TextFormat text() => TextFormat(type: TextFormatType.text);
  static TextFormat jsonObject() => TextFormat(type: TextFormatType.jsonObject);
}
