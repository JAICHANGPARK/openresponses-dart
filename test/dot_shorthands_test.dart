import 'package:open_responses_dart/open_responses_dart.dart';
import 'package:test/test.dart';

void main() {
  group('Dot Shorthands Demo', () {
    test('Enum dot shorthand - MessageRole', () {
      // Instead of MessageRole.user
      MessageRole role = .user;
      expect(role, MessageRole.user);

      // Can also use in switch expressions
      String description = switch (role) {
        .user => 'End user',
        .assistant => 'AI assistant',
        .system => 'System message',
        .developer => 'Developer instructions',
      };
      expect(description, 'End user');
    });

    test('Enum dot shorthand - ToolChoice', () {
      // Instead of ToolChoice.auto
      ToolChoice choice = .auto;
      expect(choice, ToolChoice.auto);

      // In equality check
      bool isAuto = choice == .auto;
      expect(isAuto, true);

      // In conditional with variable
      final useRequired = true;
      ToolChoice selected = useRequired ? .required : .none;
      expect(selected, ToolChoice.required);
    });

    test('Enum dot shorthand - ImageDetail', () {
      // Instead of ImageDetail.high
      ImageDetail detail = .high;
      expect(detail, ImageDetail.high);
    });

    test('Enum dot shorthand - ServiceTier', () {
      // Instead of ServiceTier.priority
      ServiceTier tier = .priority;
      expect(tier, ServiceTier.priority);
    });

    test('Enum dot shorthand - Truncation', () {
      // Instead of Truncation.disabled
      Truncation truncation = .disabled;
      expect(truncation, Truncation.disabled);
    });

    test('Enum dot shorthand in collections', () {
      // List of enums using dot shorthand
      final roles = <MessageRole>[.user, .assistant, .system];
      expect(roles.length, 3);
      expect(roles.first, MessageRole.user);

      // Map with enum values
      final statusMap = <MessageStatus, String>{
        MessageStatus.completed: 'Done',
        MessageStatus.inProgress: 'Working',
        MessageStatus.incomplete: 'Stopped',
      };
      expect(statusMap[MessageStatus.completed], 'Done');
    });
  });

  group('Content with dot shorthands', () {
    test('Input content using constructors', () {
      // Using constructors directly
      final content = InputTextContent(text: 'Hello');
      expect(content, isA<InputTextContent>());

      // In a list with explicit type
      final contents = <InputContent>[
        InputTextContent(text: 'Hello'),
        InputImageContent(imageUrl: 'https://example.com/image.png'),
        InputFileContent(fileUrl: 'https://example.com/doc.pdf'),
      ];
      expect(contents.length, 3);
    });

    test('Output content using constructor', () {
      // Using constructor directly
      final content = OutputTextContent(text: 'Response');
      expect(content, isA<OutputTextContent>());
      expect(content.text, 'Response');
    });
  });

  group('Items with dot shorthands', () {
    test('Creating items with factory and shorthand enums', () {
      // Combining ItemFactory with enum values
      final userMsg = ItemFactory.userMessage('Hello');
      expect(userMsg.role, MessageRole.user);

      final assistantMsg = ItemFactory.assistantMessage('Hi');
      expect(assistantMsg.role, MessageRole.assistant);
    });

    test('Function call item with shorthand status', () {
      // Using .completed shorthand for FunctionCallStatus
      final item = FunctionCallItem(
        callId: 'call_123',
        name: 'test',
        arguments: '{}',
        status: .completed,
      );
      expect(item.status, FunctionCallStatus.completed);
    });
  });

  group('Tools with dot shorthands', () {
    test('Tool choice param with enum shorthand', () {
      // Using .auto shorthand
      ToolChoiceParam choice = SimpleToolChoice(.auto);
      expect((choice as SimpleToolChoice).choice, ToolChoice.auto);

      // Using required in constructor
      final requiredChoice = SimpleToolChoice(ToolChoice.required);
      expect((requiredChoice as SimpleToolChoice).choice, ToolChoice.required);
      expect(requiredChoice, isA<SimpleToolChoice>());
    });
  });

  group('Request body with dot shorthands', () {
    test('CreateResponseBody with shorthand enums', () {
      final request = CreateResponseBody(
        model: 'gpt-4o',
        input: Input.items([ItemFactory.userMessage('Hello')]),
        truncation: .auto, // Instead of Truncation.auto
        serviceTier: .default_, // Instead of ServiceTier.default_
      );

      expect(request.truncation, Truncation.auto);
      expect(request.serviceTier, ServiceTier.default_);
    });

    test('Image detail with shorthand in content', () {
      final image = InputImageContent(
        imageUrl: 'https://example.com/image.png',
        detail: .high, // Instead of ImageDetail.high
      );
      expect(image.detail, ImageDetail.high);
    });

    test('Text format with shorthand', () {
      // Using shorthand for text format type
      TextFormat format = .text();
      expect(format.type, TextFormatType.text);

      TextFormat jsonFormat = .jsonObject();
      expect(jsonFormat.type, TextFormatType.jsonObject);
    });
  });

  group('Streaming events with dot shorthands', () {
    test('Event type checking with shorthand (conceptual)', () {
      // In a real scenario, you'd check events like this:
      // if (event is OutputTextDeltaEvent) { ... }
      //
      // The event types themselves are classes, not enums,
      // but when checking types, the `is` keyword already works well
    });
  });

  group('Original tests with dot shorthands applied', () {
    test('Content creation with constructors', () {
      // Using constructor directly
      final textContent = InputTextContent(text: 'Hello world');
      expect(textContent.text, 'Hello world');

      // Using constructor with enum value
      final image = InputImageContent(
        imageUrl: 'https://example.com/image.png',
        detail: ImageDetail.high,
      );
      expect(image.detail, ImageDetail.high);
    });

    test('Item creation with shorthand roles', () {
      final userMsg = MessageItem(
        role: .user, // Instead of MessageRole.user
        content: [OutputTextContent(text: 'Hello')],
      );
      expect(userMsg.role, MessageRole.user);

      final systemMsg = MessageItem(
        role: .system,
        content: [OutputTextContent(text: 'System')],
      );
      expect(systemMsg.role, MessageRole.system);
    });

    test('Tool creation with shorthand choice', () {
      final tool = FunctionTool(
        name: 'search',
      ).withDescription('Search').withStrict(true);
      expect(tool.name, 'search');
      expect(tool.description, 'Search');

      // Using .auto shorthand
      ToolChoiceParam choice = SimpleToolChoice(.auto);
      expect((choice as SimpleToolChoice).choice, ToolChoice.auto);
    });

    test('Request body with multiple shorthands', () {
      final request = CreateResponseBody(
        model: 'gpt-4o',
        input: Input.items([
          ItemFactory.systemMessage('You are helpful.'),
          ItemFactory.userMessage('Hello!'),
        ]),
        temperature: 0.7,
        maxOutputTokens: 100,
        truncation: .disabled, // Shorthand
        serviceTier: .priority, // Shorthand
      );

      expect(request.truncation, Truncation.disabled);
      expect(request.serviceTier, ServiceTier.priority);
    });

    test('Serialization roundtrip with shorthands', () {
      final request = CreateResponseBody(
        model: 'gpt-4o',
        input: Input.items([ItemFactory.userMessage('Test')]),
        truncation: .auto,
      );

      final json = request.toJson();
      expect(json['truncation'], 'auto');
    });

    test('Function call with shorthand status', () {
      final funcCall = FunctionCallItem(
        callId: 'fc_123',
        name: 'get_weather',
        arguments: '{}',
        status: .inProgress, // Shorthand
      );

      expect(funcCall.status, FunctionCallStatus.inProgress);
    });

    test('Reasoning config with shorthand', () {
      final config = ReasoningConfig(
        effort: .high, // Instead of ReasoningEffort.high
        summary: .detailed, // Instead of ReasoningSummary.detailed
      );

      expect(config.effort, ReasoningEffort.high);
      expect(config.summary, ReasoningSummary.detailed);
    });
  });
}
