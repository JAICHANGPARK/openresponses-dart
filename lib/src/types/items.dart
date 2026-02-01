import 'content.dart';
import 'enums.dart';

/// Abstract base class for items
abstract class Item {
  String get type;
  String? get id;
  Map<String, dynamic> toJson();
}

/// Message item
class MessageItem implements Item {
  @override
  final String type = 'message';
  @override
  final String? id;
  final MessageRole role;
  final List<OutputContent> content;
  final MessageStatus? status;

  MessageItem({
    this.id,
    required this.role,
    required this.content,
    this.status,
  });

  factory MessageItem.fromJson(Map<String, dynamic> json) {
    return MessageItem(
      id: json['id'] as String?,
      role: MessageRole.fromJson(json['role'] as String),
      content: (json['content'] as List<dynamic>)
          .map((e) => outputContentFromJson(e as Map<String, dynamic>))
          .toList(),
      status: json['status'] != null
          ? MessageStatus.fromJson(json['status'] as String)
          : null,
    );
  }

  @override
  Map<String, dynamic> toJson() => {
    'type': type,
    if (id != null) 'id': id,
    'role': role.toJson(),
    'content': content.map((e) => e.toJson()).toList(),
    if (status != null) 'status': status!.toJson(),
  };
}

/// Function call item
class FunctionCallItem implements Item {
  @override
  final String type = 'function_call';
  @override
  final String? id;
  final String callId;
  final String name;
  final String arguments;
  final FunctionCallStatus status;

  FunctionCallItem({
    this.id,
    required this.callId,
    required this.name,
    required this.arguments,
    this.status = FunctionCallStatus.inProgress,
  });

  factory FunctionCallItem.fromJson(Map<String, dynamic> json) {
    return FunctionCallItem(
      id: json['id'] as String?,
      callId: json['call_id'] as String,
      name: json['name'] as String,
      arguments: json['arguments'] as String,
      status: FunctionCallStatus.fromJson(json['status'] as String),
    );
  }

  @override
  Map<String, dynamic> toJson() => {
    'type': type,
    if (id != null) 'id': id,
    'call_id': callId,
    'name': name,
    'arguments': arguments,
    'status': status.toJson(),
  };
}

/// Function call output item
class FunctionCallOutputItem implements Item {
  @override
  final String type = 'function_call_output';
  @override
  final String? id;
  final String callId;
  final FunctionOutput output;
  final FunctionCallOutputStatus status;

  FunctionCallOutputItem({
    this.id,
    required this.callId,
    required this.output,
    this.status = FunctionCallOutputStatus.completed,
  });

  factory FunctionCallOutputItem.fromJson(Map<String, dynamic> json) {
    final outputData = json['output'];
    FunctionOutput output;
    if (outputData is String) {
      output = StringOutput(outputData);
    } else if (outputData is List) {
      output = ContentOutput(
        outputData
            .map((e) => inputContentFromJson(e as Map<String, dynamic>))
            .toList(),
      );
    } else {
      throw ArgumentError('Invalid output format');
    }

    return FunctionCallOutputItem(
      id: json['id'] as String?,
      callId: json['call_id'] as String,
      output: output,
      status: FunctionCallOutputStatus.fromJson(json['status'] as String),
    );
  }

  @override
  Map<String, dynamic> toJson() => {
    'type': type,
    if (id != null) 'id': id,
    'call_id': callId,
    'output': output.toJson(),
    'status': status.toJson(),
  };
}

/// Reasoning item
class ReasoningItem implements Item {
  @override
  final String type = 'reasoning';
  @override
  final String? id;
  final List<InputContent>? content;
  final List<InputContent> summary;
  final String? encryptedContent;

  ReasoningItem({
    this.id,
    this.content,
    required this.summary,
    this.encryptedContent,
  });

  factory ReasoningItem.fromJson(Map<String, dynamic> json) {
    return ReasoningItem(
      id: json['id'] as String?,
      content: (json['content'] as List<dynamic>?)
          ?.map((e) => inputContentFromJson(e as Map<String, dynamic>))
          .toList(),
      summary: (json['summary'] as List<dynamic>)
          .map((e) => inputContentFromJson(e as Map<String, dynamic>))
          .toList(),
      encryptedContent: json['encrypted_content'] as String?,
    );
  }

  @override
  Map<String, dynamic> toJson() => {
    'type': type,
    if (id != null) 'id': id,
    if (content != null) 'content': content!.map((e) => e.toJson()).toList(),
    'summary': summary.map((e) => e.toJson()).toList(),
    if (encryptedContent != null) 'encrypted_content': encryptedContent,
  };
}

/// Item reference
class ItemReference implements Item {
  @override
  final String type = 'item_reference';
  @override
  final String id;

  ItemReference({required this.id});

  factory ItemReference.fromJson(Map<String, dynamic> json) {
    return ItemReference(id: json['id'] as String);
  }

  @override
  Map<String, dynamic> toJson() => {'type': type, 'id': id};
}

/// Abstract class for function output
abstract class FunctionOutput {
  Map<String, dynamic> toJson();
}

/// String-based function output
class StringOutput implements FunctionOutput {
  final String value;

  StringOutput(this.value);

  @override
  Map<String, dynamic> toJson() => {'output': value};
}

/// Content-based function output
class ContentOutput implements FunctionOutput {
  final List<InputContent> content;

  ContentOutput(this.content);

  @override
  Map<String, dynamic> toJson() => {
    'output': content.map((e) => e.toJson()).toList(),
  };
}

/// Factory for item deserialization
Item itemFromJson(Map<String, dynamic> json) {
  final type = json['type'] as String;
  switch (type) {
    case 'message':
      return MessageItem.fromJson(json);
    case 'function_call':
      return FunctionCallItem.fromJson(json);
    case 'function_call_output':
      return FunctionCallOutputItem.fromJson(json);
    case 'reasoning':
      return ReasoningItem.fromJson(json);
    case 'item_reference':
      return ItemReference.fromJson(json);
    default:
      throw ArgumentError('Unknown item type: $type');
  }
}

/// Extension for creating items easily
extension ItemFactory on Item {
  static MessageItem userMessage(String content) => MessageItem(
    role: MessageRole.user,
    content: [OutputTextContent(text: content)],
  );

  static MessageItem assistantMessage(String content) => MessageItem(
    role: MessageRole.assistant,
    content: [OutputTextContent(text: content)],
  );

  static MessageItem systemMessage(String content) => MessageItem(
    role: MessageRole.system,
    content: [OutputTextContent(text: content)],
  );

  static MessageItem developerMessage(String content) => MessageItem(
    role: MessageRole.developer,
    content: [OutputTextContent(text: content)],
  );

  static ItemReference reference(String id) => ItemReference(id: id);
}
