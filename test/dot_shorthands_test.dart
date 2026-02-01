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

      // In conditional
      ToolChoice selected = true ? .required : .none;
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
        .completed: 'Done',
        .inProgress: 'Working',
        .incomplete: 'Stopped',
      };
      expect(statusMap[.completed], 'Done');
    });
  });

  group('Content with dot shorthands', () {
    test('Input content using shorthand', () {
      // Using dot shorthand with explicit type
      InputContent text = .text('Hello');
      expect(text, isA<InputTextContent>());

      // In a list with explicit type
      final contents = <InputContent>[
        .text('Hello'),
        .imageUrl('https://example.com/image.png'),
        .fileUrl('https://example.com/doc.pdf'),
      ];
      expect(contents.length, 3);
    });

    test('Output content using shorthand', () {
      // Using dot shorthand
      OutputContent content = .text('Response');
      expect(content, isA<OutputTextContent>());
      expect((content as OutputTextContent).text, 'Response');
    });
  });

  group('Items with dot shorthands', () {
    test('Creating items with factory and shorthand enums', () {
      // Combining ItemFactory with enum shorthands
      final userMsg = ItemFactory.userMessage('Hello');
      expect(userMsg.role, .user);

      final assistantMsg = ItemFactory.assistantMessage('Hi');
      expect(assistantMsg.role, .assistant);
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

      // Using .required shorthand in condition
      ToolChoiceParam requiredChoice = SimpleToolChoice(.required);
      expect((requiredChoice as SimpleToolChoice).choice, .required);
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
    test('Content creation with shorthands', () {
      // Using .text shorthand
      InputContent text = .text('Hello world');
      expect((text as InputTextContent).text, 'Hello world');

      // Using .high shorthand
      InputContent image = .imageUrlWithDetail(
        'https://example.com/image.png',
        .high,
      );
      expect((image as InputImageContent).detail, ImageDetail.high);
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
      expect(systemMsg.role, .system); // Can use shorthand in comparison too
    });

    test('Tool creation with shorthand choice', () {
      final tool = FunctionTool(
        name: 'search',
      ).withDescription('Search').withStrict(true);

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

// Extension methods to enable more dot shorthands
extension InputContentShorthand on InputContent {
  static InputContent text(String text) => InputTextContent(text: text);
  static InputContent imageUrl(String url) => InputImageContent(imageUrl: url);
  static InputContent imageUrlWithDetail(String url, ImageDetail detail) =>
      InputImageContent(imageUrl: url, detail: detail);
  static InputContent fileUrl(String url) => InputFileContent(fileUrl: url);
  static InputContent videoUrl(String url) => InputVideoContent(videoUrl: url);
}

extension OutputContentShorthand on OutputContent {
  static OutputContent text(String text) => OutputTextContent(text: text);
  static OutputContent refusal(String text) => RefusalContent(refusal: text);
}

extension TextFormatShorthand on TextFormat {
  static TextFormat text() => TextFormat(type: TextFormatType.text);
  static TextFormat jsonObject() => TextFormat(type: TextFormatType.jsonObject);
}
