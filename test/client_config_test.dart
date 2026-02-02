import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:open_responses_dart/open_responses_dart.dart';
import 'package:test/test.dart';

@GenerateMocks([http.Client])
import 'client_config_test.mocks.dart';

void main() {
  final validResponseJson = jsonEncode({
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
  });

  group('Client Configuration', () {
    late MockClient mockHttpClient;

    setUp(() {
      mockHttpClient = MockClient();
    });

    test('uses default base URL when not provided', () async {
      final client = Client(apiKey: 'test-key', httpClient: mockHttpClient);

      when(
        mockHttpClient.post(
          any,
          headers: anyNamed('headers'),
          body: anyNamed('body'),
        ),
      ).thenAnswer((_) async => http.Response(validResponseJson, 200));

      final request = CreateResponseBody(model: 'test-model');
      await client.createResponse(request);

      verify(
        mockHttpClient.post(
          argThat(
            predicate<Uri>(
              (uri) => uri.toString().startsWith(
                'https://api.openai.com/v1/responses',
              ),
            ),
          ),
          headers: anyNamed('headers'),
          body: anyNamed('body'),
        ),
      ).called(1);
    });

    test('uses custom base URL when provided', () async {
      final client = Client(
        apiKey: 'test-key',
        baseUrl: 'https://custom.api', // Changed from https://custom.api/v1
        httpClient: mockHttpClient,
      );

      when(
        mockHttpClient.post(
          any,
          headers: anyNamed('headers'),
          body: anyNamed('body'),
        ),
      ).thenAnswer((_) async => http.Response(validResponseJson, 200));

      final request = CreateResponseBody(model: 'test-model');
      await client.createResponse(request);

      verify(
        mockHttpClient.post(
          argThat(
            predicate<Uri>(
              (uri) =>
                  uri.toString().startsWith('https://custom.api/v1/responses'),
            ),
          ),
          headers: anyNamed('headers'),
          body: anyNamed('body'),
        ),
      ).called(1);
    });

    test('sends Authorization header when apiKey is provided', () async {
      final client = Client(apiKey: 'test-key', httpClient: mockHttpClient);

      when(
        mockHttpClient.post(
          any,
          headers: anyNamed('headers'),
          body: anyNamed('body'),
        ),
      ).thenAnswer((_) async => http.Response(validResponseJson, 200));

      final request = CreateResponseBody(model: 'test-model');
      await client.createResponse(request);

      verify(
        mockHttpClient.post(
          any,
          headers: argThat(
            containsPair('Authorization', 'Bearer test-key'),
            named: 'headers',
          ),
          body: anyNamed('body'),
        ),
      ).called(1);
    });

    test(
      'does NOT send Authorization header when apiKey is NOT provided',
      () async {
        final client = Client(httpClient: mockHttpClient);

        when(
          mockHttpClient.post(
            any,
            headers: anyNamed('headers'),
            body: anyNamed('body'),
          ),
        ).thenAnswer((_) async => http.Response(validResponseJson, 200));

        final request = CreateResponseBody(model: 'test-model');
        await client.createResponse(request);

        verify(
          mockHttpClient.post(
            any,
            headers: argThat(
              isNot(contains('Authorization')),
              named: 'headers',
            ),
            body: anyNamed('body'),
          ),
        ).called(1);
      },
    );
  });

  group('StreamingClient Configuration', () {
    late MockClient mockHttpClient;

    setUp(() {
      mockHttpClient = MockClient();
    });

    test('sends Authorization header when apiKey is provided', () async {
      final client = StreamingClient(
        apiKey: 'test-key',
        httpClient: mockHttpClient,
      );

      when(
        mockHttpClient.post(
          any,
          headers: anyNamed('headers'),
          body: anyNamed('body'),
        ),
      ).thenAnswer((_) async => http.Response('data: {}\n\n[DONE]', 200));

      final request = CreateResponseBody(model: 'test-model');
      await client.streamResponse(request).drain();

      verify(
        mockHttpClient.post(
          any,
          headers: argThat(
            containsPair('Authorization', 'Bearer test-key'),
            named: 'headers',
          ),
          body: anyNamed('body'),
        ),
      ).called(1);
    });

    test(
      'does NOT send Authorization header when apiKey is NOT provided',
      () async {
        final client = StreamingClient(httpClient: mockHttpClient);

        when(
          mockHttpClient.post(
            any,
            headers: anyNamed('headers'),
            body: anyNamed('body'),
          ),
        ).thenAnswer((_) async => http.Response('data: {}\n\n[DONE]', 200));

        final request = CreateResponseBody(model: 'test-model');
        await client.streamResponse(request).drain();

        verify(
          mockHttpClient.post(
            any,
            headers: argThat(
              isNot(contains('Authorization')),
              named: 'headers',
            ),
            body: anyNamed('body'),
          ),
        ).called(1);
      },
    );
  });
}
