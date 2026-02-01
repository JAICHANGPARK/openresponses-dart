/// Message roles in a conversation
enum MessageRole {
  user,
  assistant,
  system,
  developer;

  String toJson() => name;
  static MessageRole fromJson(String json) => values.byName(json);
}

/// Status of items in the response
enum MessageStatus {
  inProgress,
  completed,
  incomplete;

  String toJson() => name;
  static MessageStatus fromJson(String json) => values.firstWhere(
    (e) => e.name == json || e.name.toLowerCase() == json.toLowerCase(),
  );
}

/// Status of function calls
enum FunctionCallStatus {
  inProgress,
  completed,
  incomplete;

  String toJson() => name;
  static FunctionCallStatus fromJson(String json) => values.firstWhere(
    (e) => e.name == json || e.name.toLowerCase() == json.toLowerCase(),
  );
}

/// Status of function call outputs
enum FunctionCallOutputStatus {
  inProgress,
  completed,
  incomplete;

  String toJson() => name;
  static FunctionCallOutputStatus fromJson(String json) => values.firstWhere(
    (e) => e.name == json || e.name.toLowerCase() == json.toLowerCase(),
  );
}

/// Image detail level
enum ImageDetail {
  low,
  high,
  auto;

  String toJson() => name;
  static ImageDetail fromJson(String json) =>
      values.firstWhere((e) => e.name == json, orElse: () => auto);
}

/// Reasoning effort level
enum ReasoningEffort {
  none,
  low,
  medium,
  high,
  xhigh;

  String toJson() => name;
  static ReasoningEffort fromJson(String json) =>
      values.firstWhere((e) => e.name == json, orElse: () => medium);
}

/// Reasoning summary type
enum ReasoningSummary {
  concise,
  detailed,
  auto;

  String toJson() => name;
  static ReasoningSummary fromJson(String json) =>
      values.firstWhere((e) => e.name == json, orElse: () => auto);
}

/// Service tier for request processing
enum ServiceTier {
  auto,
  default_,
  flex,
  priority;

  String toJson() => name == 'default_' ? 'default' : name;
  static ServiceTier fromJson(String json) =>
      values.firstWhere((e) => e.toJson() == json, orElse: () => auto);
}

/// Tool choice options
enum ToolChoice {
  none,
  auto,
  required;

  String toJson() => name;
  static ToolChoice fromJson(String json) =>
      values.firstWhere((e) => e.name == json, orElse: () => auto);
}

/// Truncation strategy
enum Truncation {
  auto,
  disabled;

  String toJson() => name;
  static Truncation fromJson(String json) =>
      values.firstWhere((e) => e.name == json, orElse: () => auto);
}

/// Verbosity level for responses
enum Verbosity {
  low,
  medium,
  high;

  String toJson() => name;
  static Verbosity fromJson(String json) =>
      values.firstWhere((e) => e.name == json, orElse: () => medium);
}

/// Options to include in the response
enum IncludeOption {
  reasoningEncryptedContent,
  messageOutputTextLogprobs;

  String toJson() {
    switch (this) {
      case reasoningEncryptedContent:
        return 'reasoning.encrypted_content';
      case messageOutputTextLogprobs:
        return 'message.output_text.logprobs';
    }
  }

  static IncludeOption fromJson(String json) {
    switch (json) {
      case 'reasoning.encrypted_content':
        return reasoningEncryptedContent;
      case 'message.output_text.logprobs':
        return messageOutputTextLogprobs;
      default:
        throw ArgumentError('Unknown IncludeOption: $json');
    }
  }
}

/// Text format types
enum TextFormatType {
  text,
  jsonObject,
  jsonSchema;

  String toJson() => name;
  static TextFormatType fromJson(String json) =>
      values.firstWhere((e) => e.name == json, orElse: () => text);
}

/// Error types
enum ErrorType {
  serverError,
  invalidRequest,
  notFound,
  modelError,
  tooManyRequests;

  String toJson() => name;
  static ErrorType fromJson(String json) =>
      values.firstWhere((e) => e.name == json, orElse: () => serverError);
}
