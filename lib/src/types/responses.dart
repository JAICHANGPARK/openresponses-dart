import 'content.dart';
import 'enums.dart';
import 'items.dart';
import 'tools.dart';
import 'requests.dart';

/// Response resource from the API
class ResponseResource {
  final String id;
  final String object;
  final int createdAt;
  final int? completedAt;
  final String status;
  final IncompleteDetails? incompleteDetails;
  final String model;
  final String? previousResponseId;
  final String? instructions;
  final List<Item> output;
  final Error? error;
  final List<Tool> tools;
  final ToolChoiceParam toolChoice;
  final Truncation truncation;
  final bool parallelToolCalls;
  final TextField text;
  final double topP;
  final double presencePenalty;
  final double frequencyPenalty;
  final int topLogprobs;
  final double temperature;
  final ReasoningOutput? reasoning;
  final Usage? usage;
  final int? maxOutputTokens;
  final int? maxToolCalls;
  final bool store;
  final bool background;
  final String serviceTier;
  final Map<String, String> metadata;
  final String? safetyIdentifier;
  final String? promptCacheKey;

  ResponseResource({
    required this.id,
    required this.object,
    required this.createdAt,
    this.completedAt,
    required this.status,
    this.incompleteDetails,
    required this.model,
    this.previousResponseId,
    this.instructions,
    required this.output,
    this.error,
    required this.tools,
    required this.toolChoice,
    required this.truncation,
    required this.parallelToolCalls,
    required this.text,
    required this.topP,
    required this.presencePenalty,
    required this.frequencyPenalty,
    required this.topLogprobs,
    required this.temperature,
    this.reasoning,
    this.usage,
    this.maxOutputTokens,
    this.maxToolCalls,
    required this.store,
    required this.background,
    required this.serviceTier,
    required this.metadata,
    this.safetyIdentifier,
    this.promptCacheKey,
  });

  factory ResponseResource.fromJson(Map<String, dynamic> json) {
    return ResponseResource(
      id: json['id'] as String,
      object: json['object'] as String,
      createdAt: json['created_at'] as int,
      completedAt: json['completed_at'] as int?,
      status: json['status'] as String,
      incompleteDetails: json['incomplete_details'] != null
          ? IncompleteDetails.fromJson(
              json['incomplete_details'] as Map<String, dynamic>,
            )
          : null,
      model: json['model'] as String,
      previousResponseId: json['previous_response_id'] as String?,
      instructions: json['instructions'] as String?,
      output: (json['output'] as List<dynamic>)
          .map((e) => itemFromJson(e as Map<String, dynamic>))
          .toList(),
      error: json['error'] != null
          ? Error.fromJson(json['error'] as Map<String, dynamic>)
          : null,
      tools: (json['tools'] as List<dynamic>)
          .map((e) => toolFromJson(e as Map<String, dynamic>))
          .toList(),
      toolChoice: _toolChoiceFromJson(json['tool_choice']),
      truncation: Truncation.fromJson(json['truncation'] as String),
      parallelToolCalls: json['parallel_tool_calls'] as bool,
      text: TextField.fromJson(json['text'] as Map<String, dynamic>),
      topP: (json['top_p'] as num).toDouble(),
      presencePenalty: (json['presence_penalty'] as num).toDouble(),
      frequencyPenalty: (json['frequency_penalty'] as num).toDouble(),
      topLogprobs: json['top_logprobs'] as int,
      temperature: (json['temperature'] as num).toDouble(),
      reasoning: json['reasoning'] != null
          ? ReasoningOutput.fromJson(json['reasoning'] as Map<String, dynamic>)
          : null,
      usage: json['usage'] != null
          ? Usage.fromJson(json['usage'] as Map<String, dynamic>)
          : null,
      maxOutputTokens: json['max_output_tokens'] as int?,
      maxToolCalls: json['max_tool_calls'] as int?,
      store: json['store'] as bool,
      background: json['background'] as bool,
      serviceTier: json['service_tier'] as String,
      metadata: (json['metadata'] as Map<String, dynamic>).map(
        (k, v) => MapEntry(k, v as String),
      ),
      safetyIdentifier: json['safety_identifier'] as String?,
      promptCacheKey: json['prompt_cache_key'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'object': object,
    'created_at': createdAt,
    if (completedAt != null) 'completed_at': completedAt,
    'status': status,
    if (incompleteDetails != null)
      'incomplete_details': incompleteDetails!.toJson(),
    'model': model,
    if (previousResponseId != null) 'previous_response_id': previousResponseId,
    if (instructions != null) 'instructions': instructions,
    'output': output.map((e) => e.toJson()).toList(),
    if (error != null) 'error': error!.toJson(),
    'tools': tools.map((e) => e.toJson()).toList(),
    'tool_choice': toolChoice.toJson()['tool_choice'],
    'truncation': truncation.toJson(),
    'parallel_tool_calls': parallelToolCalls,
    'text': text.toJson(),
    'top_p': topP,
    'presence_penalty': presencePenalty,
    'frequency_penalty': frequencyPenalty,
    'top_logprobs': topLogprobs,
    'temperature': temperature,
    if (reasoning != null) 'reasoning': reasoning!.toJson(),
    if (usage != null) 'usage': usage!.toJson(),
    if (maxOutputTokens != null) 'max_output_tokens': maxOutputTokens,
    if (maxToolCalls != null) 'max_tool_calls': maxToolCalls,
    'store': store,
    'background': background,
    'service_tier': serviceTier,
    'metadata': metadata,
    if (safetyIdentifier != null) 'safety_identifier': safetyIdentifier,
    if (promptCacheKey != null) 'prompt_cache_key': promptCacheKey,
  };
}

/// Incomplete response details
class IncompleteDetails {
  final String reason;

  IncompleteDetails({required this.reason});

  factory IncompleteDetails.fromJson(Map<String, dynamic> json) {
    return IncompleteDetails(reason: json['reason'] as String);
  }

  Map<String, dynamic> toJson() => {'reason': reason};
}

/// Error in response
class Error {
  final String code;
  final String message;
  final String? param;
  final ErrorType errorType;

  Error({
    required this.code,
    required this.message,
    this.param,
    required this.errorType,
  });

  factory Error.fromJson(Map<String, dynamic> json) {
    return Error(
      code: json['code'] as String,
      message: json['message'] as String,
      param: json['param'] as String?,
      errorType: ErrorType.fromJson(json['type'] as String),
    );
  }

  Map<String, dynamic> toJson() => {
    'code': code,
    'message': message,
    if (param != null) 'param': param,
    'type': errorType.toJson(),
  };
}

/// Text field in response
class TextField {
  final TextFormatOutput format;
  final Verbosity? verbosity;

  TextField({required this.format, this.verbosity});

  factory TextField.fromJson(Map<String, dynamic> json) {
    return TextField(
      format: TextFormatOutput.fromJson(json['format'] as Map<String, dynamic>),
      verbosity: json['verbosity'] != null
          ? Verbosity.fromJson(json['verbosity'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'format': format.toJson(),
    if (verbosity != null) 'verbosity': verbosity!.toJson(),
  };
}

/// Text format output
class TextFormatOutput {
  final TextFormatType type;
  final String? name;
  final String? description;
  final Map<String, dynamic>? schema;
  final bool? strict;

  TextFormatOutput({
    required this.type,
    this.name,
    this.description,
    this.schema,
    this.strict,
  });

  factory TextFormatOutput.fromJson(Map<String, dynamic> json) {
    return TextFormatOutput(
      type: TextFormatType.fromJson(json['type'] as String),
      name: json['name'] as String?,
      description: json['description'] as String?,
      schema: json['schema'] as Map<String, dynamic>?,
      strict: json['strict'] as bool?,
    );
  }

  Map<String, dynamic> toJson() => {
    'type': type.toJson(),
    if (name != null) 'name': name,
    if (description != null) 'description': description,
    if (schema != null) 'schema': schema,
    if (strict != null) 'strict': strict,
  };
}

/// Reasoning output
class ReasoningOutput {
  final ReasoningEffort? effort;
  final ReasoningSummary? summary;

  ReasoningOutput({this.effort, this.summary});

  factory ReasoningOutput.fromJson(Map<String, dynamic> json) {
    return ReasoningOutput(
      effort: json['effort'] != null
          ? ReasoningEffort.fromJson(json['effort'] as String)
          : null,
      summary: json['summary'] != null
          ? ReasoningSummary.fromJson(json['summary'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
    if (effort != null) 'effort': effort!.toJson(),
    if (summary != null) 'summary': summary!.toJson(),
  };
}

/// Token usage
class Usage {
  final int inputTokens;
  final int outputTokens;
  final int totalTokens;
  final InputTokensDetails inputTokensDetails;
  final OutputTokensDetails outputTokensDetails;

  Usage({
    required this.inputTokens,
    required this.outputTokens,
    required this.totalTokens,
    required this.inputTokensDetails,
    required this.outputTokensDetails,
  });

  factory Usage.fromJson(Map<String, dynamic> json) {
    return Usage(
      inputTokens: json['input_tokens'] as int,
      outputTokens: json['output_tokens'] as int,
      totalTokens: json['total_tokens'] as int,
      inputTokensDetails: InputTokensDetails.fromJson(
        json['input_tokens_details'] as Map<String, dynamic>,
      ),
      outputTokensDetails: OutputTokensDetails.fromJson(
        json['output_tokens_details'] as Map<String, dynamic>,
      ),
    );
  }

  Map<String, dynamic> toJson() => {
    'input_tokens': inputTokens,
    'output_tokens': outputTokens,
    'total_tokens': totalTokens,
    'input_tokens_details': inputTokensDetails.toJson(),
    'output_tokens_details': outputTokensDetails.toJson(),
  };
}

/// Input tokens details
class InputTokensDetails {
  final int cachedTokens;

  InputTokensDetails({required this.cachedTokens});

  factory InputTokensDetails.fromJson(Map<String, dynamic> json) {
    return InputTokensDetails(cachedTokens: json['cached_tokens'] as int);
  }

  Map<String, dynamic> toJson() => {'cached_tokens': cachedTokens};
}

/// Output tokens details
class OutputTokensDetails {
  final int reasoningTokens;

  OutputTokensDetails({required this.reasoningTokens});

  factory OutputTokensDetails.fromJson(Map<String, dynamic> json) {
    return OutputTokensDetails(
      reasoningTokens: json['reasoning_tokens'] as int,
    );
  }

  Map<String, dynamic> toJson() => {'reasoning_tokens': reasoningTokens};
}

ToolChoiceParam _toolChoiceFromJson(dynamic json) {
  if (json is String) {
    return SimpleToolChoice(ToolChoice.fromJson(json));
  } else if (json is Map<String, dynamic>) {
    final type = json['type'] as String?;
    if (type == 'function') {
      return SpecificFunctionChoice(name: json['name'] as String);
    } else if (type == 'allowed_tools') {
      return AllowedToolsChoice(
        tools: (json['tools'] as List<dynamic>)
            .map((e) => SpecificTool.fromJson(e as Map<String, dynamic>))
            .toList(),
        mode: ToolChoice.fromJson(json['mode'] as String),
      );
    }
  }
  return SimpleToolChoice(ToolChoice.auto);
}
