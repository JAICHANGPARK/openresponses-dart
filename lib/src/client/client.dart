import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../types/requests.dart';
import '../types/responses.dart';

const String _defaultBaseUrl = 'https://api.openai.com/v1';

/// Exception thrown by the client
class OpenResponsesException implements Exception {
  final String message;
  final int? statusCode;
  final String? body;

  OpenResponsesException(this.message, {this.statusCode, this.body});

  @override
  String toString() =>
      'OpenResponsesException: $message${statusCode != null ? ' (Status: $statusCode)' : ''}';
}

/// HTTP client for the Open Responses API
class Client {
  final String _apiKey;
  final String _baseUrl;
  final http.Client _httpClient;

  /// Creates a new client with the given API key
  Client({required String apiKey, String? baseUrl, http.Client? httpClient})
    : _apiKey = apiKey,
      _baseUrl = baseUrl ?? _defaultBaseUrl,
      _httpClient = httpClient ?? http.Client();

  /// Creates a new client with a custom base URL
  factory Client.withBaseUrl({
    required String apiKey,
    required String baseUrl,
  }) {
    return Client(apiKey: apiKey, baseUrl: baseUrl);
  }

  /// Sends a request to create a response
  Future<ResponseResource> createResponse(CreateResponseBody request) async {
    final url = Uri.parse('$_baseUrl/responses');

    final response = await _httpClient.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $_apiKey',
      },
      body: jsonEncode(request.toJson()),
    );

    if (response.statusCode != 200) {
      throw OpenResponsesException(
        'Failed to create response',
        statusCode: response.statusCode,
        body: response.body,
      );
    }

    final json = jsonDecode(response.body) as Map<String, dynamic>;
    return ResponseResource.fromJson(json);
  }

  /// Sends a request and returns the raw JSON response
  Future<String> createResponseRaw(CreateResponseBody request) async {
    final url = Uri.parse('$_baseUrl/responses');

    final response = await _httpClient.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $_apiKey',
      },
      body: jsonEncode(request.toJson()),
    );

    if (response.statusCode != 200) {
      throw OpenResponsesException(
        'Failed to create response',
        statusCode: response.statusCode,
        body: response.body,
      );
    }

    return response.body;
  }

  /// Disposes the HTTP client
  void dispose() {
    _httpClient.close();
  }
}
