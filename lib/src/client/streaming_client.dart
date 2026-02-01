import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

import '../types/events.dart';
import '../types/requests.dart';

const String _defaultBaseUrl = 'https://api.openai.com/v1';

/// Exception thrown by the streaming client
class StreamingException implements Exception {
  final String message;
  final int? statusCode;

  StreamingException(this.message, {this.statusCode});

  @override
  String toString() =>
      'StreamingException: $message${statusCode != null ? ' (Status: $statusCode)' : ''}';
}

/// Streaming client for SSE (Server-Sent Events)
class StreamingClient {
  final String _apiKey;
  final String _baseUrl;
  final http.Client _httpClient;

  /// Creates a new streaming client
  StreamingClient({
    required String apiKey,
    String? baseUrl,
    http.Client? httpClient,
  }) : _apiKey = apiKey,
       _baseUrl = baseUrl ?? _defaultBaseUrl,
       _httpClient = httpClient ?? http.Client();

  /// Creates a new streaming client with a custom base URL
  factory StreamingClient.withBaseUrl({
    required String apiKey,
    required String baseUrl,
  }) {
    return StreamingClient(apiKey: apiKey, baseUrl: baseUrl);
  }

  /// Streams response events from the API
  Stream<StreamingEvent> streamResponse(CreateResponseBody request) async* {
    request.stream = true;

    final url = Uri.parse('$_baseUrl/responses');

    final response = await _httpClient.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $_apiKey',
        'Accept': 'text/event-stream',
      },
      body: jsonEncode(request.toJson()),
    );

    if (response.statusCode != 200) {
      throw StreamingException(
        'Failed to start stream',
        statusCode: response.statusCode,
      );
    }

    // Parse SSE stream
    final lines = LineSplitter.split(response.body);

    for (final line in lines) {
      if (line.startsWith('data: ')) {
        final data = line.substring(6);

        if (data == '[DONE]') {
          yield StreamDoneEvent();
          break;
        }

        try {
          final json = jsonDecode(data) as Map<String, dynamic>;
          yield streamingEventFromJson(json);
        } catch (e) {
          // Skip invalid JSON
          continue;
        }
      }
    }
  }

  /// Streams raw SSE lines from the API
  Stream<String> streamResponseLines(CreateResponseBody request) async* {
    request.stream = true;

    final url = Uri.parse('$_baseUrl/responses');

    final response = await _httpClient.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $_apiKey',
        'Accept': 'text/event-stream',
      },
      body: jsonEncode(request.toJson()),
    );

    if (response.statusCode != 200) {
      throw StreamingException(
        'Failed to start stream',
        statusCode: response.statusCode,
      );
    }

    final lines = LineSplitter.split(response.body);

    for (final line in lines) {
      if (line.startsWith('data: ')) {
        yield line.substring(6);
      }
    }
  }

  /// Disposes the HTTP client
  void dispose() {
    _httpClient.close();
  }
}

/// Extension to provide convenient stream handling
extension StreamingClientExtensions on StreamingClient {
  /// Collects all text deltas from a streaming response
  Stream<String> streamText(CreateResponseBody request) async* {
    await for (final event in streamResponse(request)) {
      if (event is OutputTextDeltaEvent) {
        yield event.delta;
      } else if (event is StreamDoneEvent) {
        break;
      }
    }
  }
}
