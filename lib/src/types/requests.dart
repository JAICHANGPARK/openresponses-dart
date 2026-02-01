import 'content.dart';
import 'enums.dart';
import 'items.dart';
import 'tools.dart';

/// Input can be a simple string or a list of items
class Input {
  final String? single;
  final List<Item>? items;

  Input({this.single, this.items}) {
    if (single == null && items == null) {
      throw ArgumentError('Either single or items must be provided');
    }
    if (single != null && items != null) {
      throw ArgumentError('Cannot provide both single and items');
    }
  }

  factory Input.single(String text) => Input(single: text);
  factory Input.items(List<Item> items) => Input(items: items);

  factory Input.fromJson(dynamic json) {
    if (json is String) {
      return Input(single: json);
    } else if (json is List) {
      return Input(
        items: json
            .map((e) => itemFromJson(e as Map<String, dynamic>))
            .toList(),
      );
    }
    throw ArgumentError('Invalid input format');
  }

  dynamic toJson() => single ?? items?.map((e) => e.toJson()).toList();
}

/// Text format for output
class TextFormat {
  final TextFormatType type;
  final String? name;
  final String? description;
  final Map<String, dynamic>? schema;
  final bool? strict;

  TextFormat({
    required this.type,
    this.name,
    this.description,
    this.schema,
    this.strict,
  });

  factory TextFormat.text() => TextFormat(type: TextFormatType.text);
  factory TextFormat.jsonObject() =>
      TextFormat(type: TextFormatType.jsonObject);
  factory TextFormat.jsonSchema({
    required String name,
    String? description,
    Map<String, dynamic>? schema,
    bool? strict,
  }) => TextFormat(
    type: TextFormatType.jsonSchema,
    name: name,
    description: description,
    schema: schema,
    strict: strict,
  );

  factory TextFormat.fromJson(Map<String, dynamic> json) {
    return TextFormat(
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

/// Text parameter configuration
class TextParam {
  final TextFormat? format;
  final Verbosity? verbosity;

  TextParam({this.format, this.verbosity});

  factory TextParam.fromJson(Map<String, dynamic> json) {
    return TextParam(
      format: json['format'] != null
          ? TextFormat.fromJson(json['format'] as Map<String, dynamic>)
          : null,
      verbosity: json['verbosity'] != null
          ? Verbosity.fromJson(json['verbosity'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
    if (format != null) 'format': format!.toJson(),
    if (verbosity != null) 'verbosity': verbosity!.toJson(),
  };
}

/// Stream options
class StreamOptions {
  final bool? includeObfuscation;

  StreamOptions({this.includeObfuscation});

  factory StreamOptions.fromJson(Map<String, dynamic> json) {
    return StreamOptions(
      includeObfuscation: json['include_obfuscation'] as bool?,
    );
  }

  Map<String, dynamic> toJson() => {
    if (includeObfuscation != null) 'include_obfuscation': includeObfuscation,
  };
}

/// Reasoning configuration
class ReasoningConfig {
  final ReasoningEffort? effort;
  final ReasoningSummary? summary;

  ReasoningConfig({this.effort, this.summary});

  factory ReasoningConfig.fromJson(Map<String, dynamic> json) {
    return ReasoningConfig(
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

/// Create response request body
class CreateResponseBody {
  final String? model;
  final Input? input;
  final String? previousResponseId;
  final List<IncludeOption>? include;
  final List<Tool>? tools;
  final ToolChoiceParam? toolChoice;
  final Map<String, String>? metadata;
  final TextParam? text;
  final double? temperature;
  final double? topP;
  final double? presencePenalty;
  final double? frequencyPenalty;
  final bool? parallelToolCalls;
  bool? stream;
  final StreamOptions? streamOptions;
  final bool? background;
  final int? maxOutputTokens;
  final int? maxToolCalls;
  final ReasoningConfig? reasoning;
  final String? safetyIdentifier;
  final String? promptCacheKey;
  final Truncation? truncation;
  final String? instructions;
  final bool? store;
  final ServiceTier? serviceTier;
  final int? topLogprobs;

  CreateResponseBody({
    this.model,
    this.input,
    this.previousResponseId,
    this.include,
    this.tools,
    this.toolChoice,
    this.metadata,
    this.text,
    this.temperature,
    this.topP,
    this.presencePenalty,
    this.frequencyPenalty,
    this.parallelToolCalls,
    this.stream,
    this.streamOptions,
    this.background,
    this.maxOutputTokens,
    this.maxToolCalls,
    this.reasoning,
    this.safetyIdentifier,
    this.promptCacheKey,
    this.truncation,
    this.instructions,
    this.store,
    this.serviceTier,
    this.topLogprobs,
  });

  factory CreateResponseBody.fromJson(Map<String, dynamic> json) {
    return CreateResponseBody(
      model: json['model'] as String?,
      input: json['input'] != null ? Input.fromJson(json['input']) : null,
      previousResponseId: json['previous_response_id'] as String?,
      include: (json['include'] as List<dynamic>?)
          ?.map((e) => IncludeOption.fromJson(e as String))
          .toList(),
      tools: (json['tools'] as List<dynamic>?)
          ?.map((e) => toolFromJson(e as Map<String, dynamic>))
          .toList(),
      toolChoice: json['tool_choice'] != null
          ? _toolChoiceFromJson(json['tool_choice'])
          : null,
      metadata: (json['metadata'] as Map<String, dynamic>?)?.map(
        (k, v) => MapEntry(k, v as String),
      ),
      text: json['text'] != null
          ? TextParam.fromJson(json['text'] as Map<String, dynamic>)
          : null,
      temperature: (json['temperature'] as num?)?.toDouble(),
      topP: (json['top_p'] as num?)?.toDouble(),
      presencePenalty: (json['presence_penalty'] as num?)?.toDouble(),
      frequencyPenalty: (json['frequency_penalty'] as num?)?.toDouble(),
      parallelToolCalls: json['parallel_tool_calls'] as bool?,
      stream: json['stream'] as bool?,
      streamOptions: json['stream_options'] != null
          ? StreamOptions.fromJson(
              json['stream_options'] as Map<String, dynamic>,
            )
          : null,
      background: json['background'] as bool?,
      maxOutputTokens: json['max_output_tokens'] as int?,
      maxToolCalls: json['max_tool_calls'] as int?,
      reasoning: json['reasoning'] != null
          ? ReasoningConfig.fromJson(json['reasoning'] as Map<String, dynamic>)
          : null,
      safetyIdentifier: json['safety_identifier'] as String?,
      promptCacheKey: json['prompt_cache_key'] as String?,
      truncation: json['truncation'] != null
          ? Truncation.fromJson(json['truncation'] as String)
          : null,
      instructions: json['instructions'] as String?,
      store: json['store'] as bool?,
      serviceTier: json['service_tier'] != null
          ? ServiceTier.fromJson(json['service_tier'] as String)
          : null,
      topLogprobs: json['top_logprobs'] as int?,
    );
  }

  Map<String, dynamic> toJson() => {
    if (model != null) 'model': model,
    if (input != null) 'input': input!.toJson(),
    if (previousResponseId != null) 'previous_response_id': previousResponseId,
    if (include != null) 'include': include!.map((e) => e.toJson()).toList(),
    if (tools != null) 'tools': tools!.map((e) => e.toJson()).toList(),
    if (toolChoice != null) ...toolChoice!.toJson(),
    if (metadata != null) 'metadata': metadata,
    if (text != null) 'text': text!.toJson(),
    if (temperature != null) 'temperature': temperature,
    if (topP != null) 'top_p': topP,
    if (presencePenalty != null) 'presence_penalty': presencePenalty,
    if (frequencyPenalty != null) 'frequency_penalty': frequencyPenalty,
    if (parallelToolCalls != null) 'parallel_tool_calls': parallelToolCalls,
    if (stream != null) 'stream': stream,
    if (streamOptions != null) 'stream_options': streamOptions!.toJson(),
    if (background != null) 'background': background,
    if (maxOutputTokens != null) 'max_output_tokens': maxOutputTokens,
    if (maxToolCalls != null) 'max_tool_calls': maxToolCalls,
    if (reasoning != null) 'reasoning': reasoning!.toJson(),
    if (safetyIdentifier != null) 'safety_identifier': safetyIdentifier,
    if (promptCacheKey != null) 'prompt_cache_key': promptCacheKey,
    if (truncation != null) 'truncation': truncation!.toJson(),
    if (instructions != null) 'instructions': instructions,
    if (store != null) 'store': store,
    if (serviceTier != null) 'service_tier': serviceTier!.toJson(),
    if (topLogprobs != null) 'top_logprobs': topLogprobs,
  };
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
  throw ArgumentError('Invalid tool_choice format');
}
