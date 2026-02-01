import 'package:open_responses_dart/open_responses_dart.dart';

void main() async {
  final streamingClient = StreamingClient(apiKey: 'your-api-key');

  final request = CreateResponseBody(
    model: 'gpt-4o',
    input: Input.items([
      ItemFactory.systemMessage('You are a helpful assistant.'),
      ItemFactory.userMessage('Count from 1 to 5 slowly.'),
    ]),
    temperature: 0.7,
  );

  print('Streaming response:\n');

  try {
    await for (final event in streamingClient.streamResponse(request)) {
      if (event is OutputTextDeltaEvent) {
        // Print each token as it arrives
        print(event.delta);
      } else if (event is ResponseCompletedEvent) {
        print('\n\n[Response completed]');
      } else if (event is ResponseFailedEvent) {
        print('\n\n[Response failed]');
      } else if (event is StreamDoneEvent) {
        print('\n[Stream ended]');
        break;
      }
    }
  } on StreamingException catch (e) {
    print('Stream error: ${e.message}');
  } finally {
    streamingClient.dispose();
  }

  // Alternative: Using the text stream extension
  print('\n--- Alternative: Text-only stream ---\n');

  await for (final textChunk in streamingClient.streamText(request)) {
    print(textChunk);
  }
}
