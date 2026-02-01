import 'dart:async';
import 'dart:convert';
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
          'unit': {
            'type': 'string',
            'enum': ['celsius', 'fahrenheit'],
            'description': 'The unit of temperature',
          },
        },
        'required': ['location'],
      });

  final request = CreateResponseBody(
    model: 'gpt-4o',
    input: Input.items([
      ItemFactory.systemMessage(
        'You are a helpful assistant. Use the available tools when needed.',
      ),
      ItemFactory.userMessage('What\'s the weather like in San Francisco?'),
    ]),
    tools: [getWeatherTool],
    toolChoice: SimpleToolChoice(ToolChoice.auto),
  );

  try {
    final response = await client.createResponse(request);
    print('Response ID: ${response.id}');

    for (var item in response.output) {
      if (item is MessageItem) {
        for (var content in item.content) {
          if (content is OutputTextContent) {
            print('Assistant: ${content.text}');
          }
        }
      } else if (item is FunctionCallItem) {
        print('\nFunction Call:');
        print('  Name: ${item.name}');
        print('  Arguments: ${item.arguments}');

        // Parse the arguments
        final args = jsonDecode(item.arguments) as Map<String, dynamic>;
        print('  Parsed location: ${args['location']}');

        // Here you would call your actual function
        // final weatherResult = await callGetWeatherFunction(args);

        // Then send the result back in a follow-up request
        final followUpRequest = CreateResponseBody(
          model: 'gpt-4o',
          input: Input.items([
            ItemFactory.systemMessage('You are a helpful assistant.'),
            ItemFactory.userMessage(
              'What\'s the weather like in San Francisco?',
            ),
            item, // The function call
            FunctionCallOutputItem(
              callId: item.callId,
              output: StringOutput('{"temperature": 72, "condition": "sunny"}'),
            ),
          ]),
        );

        final finalResponse = await client.createResponse(followUpRequest);
        print('\nFinal Response:');
        for (var finalItem in finalResponse.output) {
          if (finalItem is MessageItem) {
            for (var content in finalItem.content) {
              if (content is OutputTextContent) {
                print('Assistant: ${content.text}');
              }
            }
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
