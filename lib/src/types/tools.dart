import 'enums.dart';

/// Abstract base class for tools
abstract class Tool {
  String get type;
  Map<String, dynamic> toJson();
}

/// Function tool
class FunctionTool implements Tool {
  @override
  final String type = 'function';
  final String name;
  final String? description;
  final Map<String, dynamic>? parameters;
  final bool? strict;

  FunctionTool({
    required this.name,
    this.description,
    this.parameters,
    this.strict,
  });

  factory FunctionTool.fromJson(Map<String, dynamic> json) {
    return FunctionTool(
      name: json['name'] as String,
      description: json['description'] as String?,
      parameters: json['parameters'] as Map<String, dynamic>?,
      strict: json['strict'] as bool?,
    );
  }

  @override
  Map<String, dynamic> toJson() => {
    'type': type,
    'name': name,
    if (description != null) 'description': description,
    if (parameters != null) 'parameters': parameters,
    if (strict != null) 'strict': strict,
  };

  /// Builder pattern for convenience
  FunctionTool withDescription(String desc) => FunctionTool(
    name: name,
    description: desc,
    parameters: parameters,
    strict: strict,
  );

  FunctionTool withParameters(Map<String, dynamic> params) => FunctionTool(
    name: name,
    description: description,
    parameters: params,
    strict: strict,
  );

  FunctionTool withStrict(bool value) => FunctionTool(
    name: name,
    description: description,
    parameters: parameters,
    strict: value,
  );
}

/// Tool choice parameter
abstract class ToolChoiceParam {
  Map<String, dynamic> toJson();
}

/// Simple tool choice (auto, none, required)
class SimpleToolChoice implements ToolChoiceParam {
  final ToolChoice choice;

  SimpleToolChoice(this.choice);

  @override
  Map<String, dynamic> toJson() => {'tool_choice': choice.toJson()};
}

/// Specific function tool choice
class SpecificFunctionChoice implements ToolChoiceParam {
  final String name;

  SpecificFunctionChoice({required this.name});

  @override
  Map<String, dynamic> toJson() => {
    'tool_choice': {'type': 'function', 'name': name},
  };
}

/// Allowed tools choice
class AllowedToolsChoice implements ToolChoiceParam {
  final List<SpecificTool> tools;
  final ToolChoice mode;

  AllowedToolsChoice({required this.tools, this.mode = ToolChoice.auto});

  @override
  Map<String, dynamic> toJson() => {
    'tool_choice': {
      'type': 'allowed_tools',
      'tools': tools.map((e) => e.toJson()).toList(),
      'mode': mode.toJson(),
    },
  };
}

/// Specific tool reference
class SpecificTool {
  final String type;
  final String name;

  SpecificTool({required this.type, required this.name});

  factory SpecificTool.fromJson(Map<String, dynamic> json) {
    return SpecificTool(
      type: json['type'] as String,
      name: json['name'] as String,
    );
  }

  Map<String, dynamic> toJson() => {'type': type, 'name': name};
}

/// Factory for tool deserialization
Tool toolFromJson(Map<String, dynamic> json) {
  final type = json['type'] as String;
  switch (type) {
    case 'function':
      return FunctionTool.fromJson(json);
    default:
      throw ArgumentError('Unknown tool type: $type');
  }
}
