import 'package:open_responses_dart/open_responses_dart.dart';
import 'package:test/test.dart';

void main() {
  group('Enums', () {
    test('MessageRole can be converted to and from JSON', () {
      expect(MessageRole.user.toJson(), 'user');
      expect(MessageRole.fromJson('user'), MessageRole.user);
      expect(MessageRole.fromJson('assistant'), MessageRole.assistant);
    });

    test('ToolChoice defaults correctly', () {
      expect(ToolChoice.fromJson('invalid'), ToolChoice.auto);
    });

    test('ImageDetail defaults to auto', () {
      expect(ImageDetail.fromJson('invalid'), ImageDetail.auto);
    });
  });

  group('Content', () {
    test('InputTextContent can be created and serialized', () {
      final content = InputTextContent(text: 'Hello, world!');
      final json = content.toJson();

      expect(json['type'], 'input_text');
      expect(json['text'], 'Hello, world!');
    });

    test('InputImageContent supports detail parameter', () {
      final content = InputImageContent(
        imageUrl: 'https://example.com/image.png',
        detail: ImageDetail.high,
      );

      expect(content.toJson()['detail'], 'high');
    });

    test('OutputTextContent can be created', () {
      final content = OutputTextContent(text: 'Response text');
      expect(content.text, 'Response text');
      expect(content.type, 'output_text');
    });
  });

  group('Items', () {
    test('MessageItem can be created with factory methods', () {
      final userMessage = ItemFactory.userMessage('Hello');
      expect(userMessage.role, MessageRole.user);
      expect(userMessage.content.length, 1);

      final assistantMessage = ItemFactory.assistantMessage('Hi there');
      expect(assistantMessage.role, MessageRole.assistant);

      final systemMessage = ItemFactory.systemMessage('System prompt');
      expect(systemMessage.role, MessageRole.system);
    });

    test('ItemReference can be created', () {
      final ref = ItemFactory.reference('msg_123');
      expect(ref.id, 'msg_123');
      expect(ref.type, 'item_reference');
    });

    test('FunctionCallItem can be serialized', () {
      final item = FunctionCallItem(
        callId: 'call_123',
        name: 'get_weather',
        arguments: '{"location": "NYC"}',
        status: FunctionCallStatus.completed,
      );

      final json = item.toJson();
      expect(json['type'], 'function_call');
      expect(json['name'], 'get_weather');
      expect(json['status'], 'completed');
    });
  });

  group('Tools', () {
    test('FunctionTool can be created with builder pattern', () {
      final tool = FunctionTool(
        name: 'search',
      ).withDescription('Search the web').withStrict(true);

      expect(tool.name, 'search');
      expect(tool.description, 'Search the web');
      expect(tool.strict, true);
    });

    test('ToolChoiceParam supports different types', () {
      final simple = SimpleToolChoice(ToolChoice.auto);
      expect(simple.toJson()['tool_choice'], 'auto');

      final specific = SpecificFunctionChoice(name: 'get_weather');
      expect(specific.toJson()['tool_choice']['name'], 'get_weather');
    });
  });

  group('Requests', () {
    test('CreateResponseBody can be created and serialized', () {
      final request = CreateResponseBody(
        model: 'gpt-4o',
        input: Input.items([
          ItemFactory.systemMessage('You are helpful.'),
          ItemFactory.userMessage('Hello!'),
        ]),
        temperature: 0.7,
        maxOutputTokens: 100,
      );

      final json = request.toJson();
      expect(json['model'], 'gpt-4o');
      expect(json['temperature'], 0.7);
      expect(json['max_output_tokens'], 100);
    });

    test('Input can be single string', () {
      final input = Input.single('Hello');
      expect(input.single, 'Hello');
      expect(input.items, isNull);
    });

    test('Input can be list of items', () {
      final input = Input.items([ItemFactory.userMessage('Hello')]);
      expect(input.single, isNull);
      expect(input.items?.length, 1);
    });

    test('TextFormat supports different types', () {
      final text = TextFormat.text();
      expect(text.toJson()['type'], 'text');

      final jsonSchema = TextFormat.jsonSchema(
        name: 'schema_name',
        description: 'A schema',
      );
      expect(jsonSchema.toJson()['type'], 'json_schema');
      expect(jsonSchema.toJson()['name'], 'schema_name');
    });
  });

  group('Responses', () {
    test('ResponseResource can be deserialized', () {
      final json = {
        'id': 'resp_123',
        'object': 'response',
        'created_at': 1234567890,
        'status': 'completed',
        'model': 'gpt-4o',
        'output': [],
        'tools': [],
        'tool_choice': 'auto',
        'truncation': 'auto',
        'parallel_tool_calls': true,
        'text': {
          'format': {'type': 'text'},
        },
        'top_p': 1.0,
        'presence_penalty': 0.0,
        'frequency_penalty': 0.0,
        'top_logprobs': 0,
        'temperature': 1.0,
        'store': false,
        'background': false,
        'service_tier': 'auto',
        'metadata': {},
      };

      final response = ResponseResource.fromJson(json);
      expect(response.id, 'resp_123');
      expect(response.status, 'completed');
    });

    test('Usage can be deserialized', () {
      final json = {
        'input_tokens': 10,
        'output_tokens': 20,
        'total_tokens': 30,
        'input_tokens_details': {'cached_tokens': 5},
        'output_tokens_details': {'reasoning_tokens': 0},
      };

      final usage = Usage.fromJson(json);
      expect(usage.inputTokens, 10);
      expect(usage.outputTokens, 20);
      expect(usage.totalTokens, 30);
    });
  });

  group('Streaming Events', () {
    test('OutputTextDeltaEvent can be deserialized', () {
      final json = {
        'type': 'response.output_text.delta',
        'sequence_number': 1,
        'item_id': 'msg_123',
        'output_index': 0,
        'content_index': 0,
        'delta': 'Hello',
      };

      final event = streamingEventFromJson(json);
      expect(event, isA<OutputTextDeltaEvent>());
      expect((event as OutputTextDeltaEvent).delta, 'Hello');
    });

    test('StreamDoneEvent can be deserialized', () {
      final json = {'type': '[DONE]'};
      final event = streamingEventFromJson(json);
      expect(event, isA<StreamDoneEvent>());
    });

    test('ErrorEvent can be deserialized', () {
      final json = {
        'type': 'error',
        'sequence_number': 1,
        'error': {'type': 'server_error', 'message': 'Something went wrong'},
      };

      final event = streamingEventFromJson(json);
      expect(event, isA<ErrorEvent>());
    });
  });
}
