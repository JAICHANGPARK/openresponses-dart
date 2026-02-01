import 'dart:async';
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
    print('Response ID: ${response.id}');
    print('Status: ${response.status}');

    if (response.usage != null) {
      print('\nToken Usage:');
      print('  Input: ${response.usage!.inputTokens}');
      print('  Output: ${response.usage!.outputTokens}');
      print('  Total: ${response.usage!.totalTokens}');
    }

    print('\nOutput:');
    for (var item in response.output) {
      if (item is MessageItem) {
        for (var content in item.content) {
          if (content is OutputTextContent) {
            print('Assistant: ${content.text}');
          }
        }
      }
    }
  } on OpenResponsesException catch (e) {
    print('Error: ${e.message}');
  } finally {
    client.dispose();
  }
}
