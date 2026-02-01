import 'content.dart';
import 'items.dart';
import 'responses.dart';

/// Abstract base class for streaming events
abstract class StreamingEvent {
  String get type;
  Map<String, dynamic> toJson();
}

/// Response created event
class ResponseCreatedEvent implements StreamingEvent {
  @override
  final String type = 'response.created';
  final int sequenceNumber;
  final ResponseResource response;

  ResponseCreatedEvent({required this.sequenceNumber, required this.response});

  factory ResponseCreatedEvent.fromJson(Map<String, dynamic> json) {
    return ResponseCreatedEvent(
      sequenceNumber: json['sequence_number'] as int,
      response: ResponseResource.fromJson(
        json['response'] as Map<String, dynamic>,
      ),
    );
  }

  @override
  Map<String, dynamic> toJson() => {
    'type': type,
    'sequence_number': sequenceNumber,
    'response': response.toJson(),
  };
}

/// Response queued event
class ResponseQueuedEvent implements StreamingEvent {
  @override
  final String type = 'response.queued';
  final int sequenceNumber;
  final ResponseResource response;

  ResponseQueuedEvent({required this.sequenceNumber, required this.response});

  factory ResponseQueuedEvent.fromJson(Map<String, dynamic> json) {
    return ResponseQueuedEvent(
      sequenceNumber: json['sequence_number'] as int,
      response: ResponseResource.fromJson(
        json['response'] as Map<String, dynamic>,
      ),
    );
  }

  @override
  Map<String, dynamic> toJson() => {
    'type': type,
    'sequence_number': sequenceNumber,
    'response': response.toJson(),
  };
}

/// Response in progress event
class ResponseInProgressEvent implements StreamingEvent {
  @override
  final String type = 'response.in_progress';
  final int sequenceNumber;
  final ResponseResource response;

  ResponseInProgressEvent({
    required this.sequenceNumber,
    required this.response,
  });

  factory ResponseInProgressEvent.fromJson(Map<String, dynamic> json) {
    return ResponseInProgressEvent(
      sequenceNumber: json['sequence_number'] as int,
      response: ResponseResource.fromJson(
        json['response'] as Map<String, dynamic>,
      ),
    );
  }

  @override
  Map<String, dynamic> toJson() => {
    'type': type,
    'sequence_number': sequenceNumber,
    'response': response.toJson(),
  };
}

/// Response completed event
class ResponseCompletedEvent implements StreamingEvent {
  @override
  final String type = 'response.completed';
  final int sequenceNumber;
  final ResponseResource response;

  ResponseCompletedEvent({
    required this.sequenceNumber,
    required this.response,
  });

  factory ResponseCompletedEvent.fromJson(Map<String, dynamic> json) {
    return ResponseCompletedEvent(
      sequenceNumber: json['sequence_number'] as int,
      response: ResponseResource.fromJson(
        json['response'] as Map<String, dynamic>,
      ),
    );
  }

  @override
  Map<String, dynamic> toJson() => {
    'type': type,
    'sequence_number': sequenceNumber,
    'response': response.toJson(),
  };
}

/// Response failed event
class ResponseFailedEvent implements StreamingEvent {
  @override
  final String type = 'response.failed';
  final int sequenceNumber;
  final ResponseResource response;

  ResponseFailedEvent({required this.sequenceNumber, required this.response});

  factory ResponseFailedEvent.fromJson(Map<String, dynamic> json) {
    return ResponseFailedEvent(
      sequenceNumber: json['sequence_number'] as int,
      response: ResponseResource.fromJson(
        json['response'] as Map<String, dynamic>,
      ),
    );
  }

  @override
  Map<String, dynamic> toJson() => {
    'type': type,
    'sequence_number': sequenceNumber,
    'response': response.toJson(),
  };
}

/// Response incomplete event
class ResponseIncompleteEvent implements StreamingEvent {
  @override
  final String type = 'response.incomplete';
  final int sequenceNumber;
  final ResponseResource response;

  ResponseIncompleteEvent({
    required this.sequenceNumber,
    required this.response,
  });

  factory ResponseIncompleteEvent.fromJson(Map<String, dynamic> json) {
    return ResponseIncompleteEvent(
      sequenceNumber: json['sequence_number'] as int,
      response: ResponseResource.fromJson(
        json['response'] as Map<String, dynamic>,
      ),
    );
  }

  @override
  Map<String, dynamic> toJson() => {
    'type': type,
    'sequence_number': sequenceNumber,
    'response': response.toJson(),
  };
}

/// Output item added event
class OutputItemAddedEvent implements StreamingEvent {
  @override
  final String type = 'response.output_item.added';
  final int sequenceNumber;
  final int outputIndex;
  final Item item;

  OutputItemAddedEvent({
    required this.sequenceNumber,
    required this.outputIndex,
    required this.item,
  });

  factory OutputItemAddedEvent.fromJson(Map<String, dynamic> json) {
    return OutputItemAddedEvent(
      sequenceNumber: json['sequence_number'] as int,
      outputIndex: json['output_index'] as int,
      item: itemFromJson(json['item'] as Map<String, dynamic>),
    );
  }

  @override
  Map<String, dynamic> toJson() => {
    'type': type,
    'sequence_number': sequenceNumber,
    'output_index': outputIndex,
    'item': item.toJson(),
  };
}

/// Output item done event
class OutputItemDoneEvent implements StreamingEvent {
  @override
  final String type = 'response.output_item.done';
  final int sequenceNumber;
  final int outputIndex;
  final Item item;

  OutputItemDoneEvent({
    required this.sequenceNumber,
    required this.outputIndex,
    required this.item,
  });

  factory OutputItemDoneEvent.fromJson(Map<String, dynamic> json) {
    return OutputItemDoneEvent(
      sequenceNumber: json['sequence_number'] as int,
      outputIndex: json['output_index'] as int,
      item: itemFromJson(json['item'] as Map<String, dynamic>),
    );
  }

  @override
  Map<String, dynamic> toJson() => {
    'type': type,
    'sequence_number': sequenceNumber,
    'output_index': outputIndex,
    'item': item.toJson(),
  };
}

/// Output text delta event
class OutputTextDeltaEvent implements StreamingEvent {
  @override
  final String type = 'response.output_text.delta';
  final int sequenceNumber;
  final String itemId;
  final int outputIndex;
  final int contentIndex;
  final String delta;
  final List<LogProb>? logprobs;
  final String? obfuscation;

  OutputTextDeltaEvent({
    required this.sequenceNumber,
    required this.itemId,
    required this.outputIndex,
    required this.contentIndex,
    required this.delta,
    this.logprobs,
    this.obfuscation,
  });

  factory OutputTextDeltaEvent.fromJson(Map<String, dynamic> json) {
    return OutputTextDeltaEvent(
      sequenceNumber: json['sequence_number'] as int,
      itemId: json['item_id'] as String,
      outputIndex: json['output_index'] as int,
      contentIndex: json['content_index'] as int,
      delta: json['delta'] as String,
      logprobs: (json['logprobs'] as List<dynamic>?)
          ?.map((e) => LogProb.fromJson(e as Map<String, dynamic>))
          .toList(),
      obfuscation: json['obfuscation'] as String?,
    );
  }

  @override
  Map<String, dynamic> toJson() => {
    'type': type,
    'sequence_number': sequenceNumber,
    'item_id': itemId,
    'output_index': outputIndex,
    'content_index': contentIndex,
    'delta': delta,
    if (logprobs != null) 'logprobs': logprobs!.map((e) => e.toJson()).toList(),
    if (obfuscation != null) 'obfuscation': obfuscation,
  };
}

/// Output text done event
class OutputTextDoneEvent implements StreamingEvent {
  @override
  final String type = 'response.output_text.done';
  final int sequenceNumber;
  final String itemId;
  final int outputIndex;
  final int contentIndex;
  final String text;
  final List<LogProb>? logprobs;

  OutputTextDoneEvent({
    required this.sequenceNumber,
    required this.itemId,
    required this.outputIndex,
    required this.contentIndex,
    required this.text,
    this.logprobs,
  });

  factory OutputTextDoneEvent.fromJson(Map<String, dynamic> json) {
    return OutputTextDoneEvent(
      sequenceNumber: json['sequence_number'] as int,
      itemId: json['item_id'] as String,
      outputIndex: json['output_index'] as int,
      contentIndex: json['content_index'] as int,
      text: json['text'] as String,
      logprobs: (json['logprobs'] as List<dynamic>?)
          ?.map((e) => LogProb.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  @override
  Map<String, dynamic> toJson() => {
    'type': type,
    'sequence_number': sequenceNumber,
    'item_id': itemId,
    'output_index': outputIndex,
    'content_index': contentIndex,
    'text': text,
    if (logprobs != null) 'logprobs': logprobs!.map((e) => e.toJson()).toList(),
  };
}

/// Content part added event
class ContentPartAddedEvent implements StreamingEvent {
  @override
  final String type = 'response.content_part.added';
  final int sequenceNumber;
  final String itemId;
  final int outputIndex;
  final int contentIndex;
  final OutputContent part;

  ContentPartAddedEvent({
    required this.sequenceNumber,
    required this.itemId,
    required this.outputIndex,
    required this.contentIndex,
    required this.part,
  });

  factory ContentPartAddedEvent.fromJson(Map<String, dynamic> json) {
    return ContentPartAddedEvent(
      sequenceNumber: json['sequence_number'] as int,
      itemId: json['item_id'] as String,
      outputIndex: json['output_index'] as int,
      contentIndex: json['content_index'] as int,
      part: outputContentFromJson(json['part'] as Map<String, dynamic>),
    );
  }

  @override
  Map<String, dynamic> toJson() => {
    'type': type,
    'sequence_number': sequenceNumber,
    'item_id': itemId,
    'output_index': outputIndex,
    'content_index': contentIndex,
    'part': part.toJson(),
  };
}

/// Content part done event
class ContentPartDoneEvent implements StreamingEvent {
  @override
  final String type = 'response.content_part.done';
  final int sequenceNumber;
  final String itemId;
  final int outputIndex;
  final int contentIndex;
  final OutputContent part;

  ContentPartDoneEvent({
    required this.sequenceNumber,
    required this.itemId,
    required this.outputIndex,
    required this.contentIndex,
    required this.part,
  });

  factory ContentPartDoneEvent.fromJson(Map<String, dynamic> json) {
    return ContentPartDoneEvent(
      sequenceNumber: json['sequence_number'] as int,
      itemId: json['item_id'] as String,
      outputIndex: json['output_index'] as int,
      contentIndex: json['content_index'] as int,
      part: outputContentFromJson(json['part'] as Map<String, dynamic>),
    );
  }

  @override
  Map<String, dynamic> toJson() => {
    'type': type,
    'sequence_number': sequenceNumber,
    'item_id': itemId,
    'output_index': outputIndex,
    'content_index': contentIndex,
    'part': part.toJson(),
  };
}

/// Function call arguments delta event
class FunctionCallArgumentsDeltaEvent implements StreamingEvent {
  @override
  final String type = 'response.function_call_arguments.delta';
  final int sequenceNumber;
  final String itemId;
  final int outputIndex;
  final String delta;
  final String? obfuscation;

  FunctionCallArgumentsDeltaEvent({
    required this.sequenceNumber,
    required this.itemId,
    required this.outputIndex,
    required this.delta,
    this.obfuscation,
  });

  factory FunctionCallArgumentsDeltaEvent.fromJson(Map<String, dynamic> json) {
    return FunctionCallArgumentsDeltaEvent(
      sequenceNumber: json['sequence_number'] as int,
      itemId: json['item_id'] as String,
      outputIndex: json['output_index'] as int,
      delta: json['delta'] as String,
      obfuscation: json['obfuscation'] as String?,
    );
  }

  @override
  Map<String, dynamic> toJson() => {
    'type': type,
    'sequence_number': sequenceNumber,
    'item_id': itemId,
    'output_index': outputIndex,
    'delta': delta,
    if (obfuscation != null) 'obfuscation': obfuscation,
  };
}

/// Function call arguments done event
class FunctionCallArgumentsDoneEvent implements StreamingEvent {
  @override
  final String type = 'response.function_call_arguments.done';
  final int sequenceNumber;
  final String itemId;
  final int outputIndex;
  final String arguments;

  FunctionCallArgumentsDoneEvent({
    required this.sequenceNumber,
    required this.itemId,
    required this.outputIndex,
    required this.arguments,
  });

  factory FunctionCallArgumentsDoneEvent.fromJson(Map<String, dynamic> json) {
    return FunctionCallArgumentsDoneEvent(
      sequenceNumber: json['sequence_number'] as int,
      itemId: json['item_id'] as String,
      outputIndex: json['output_index'] as int,
      arguments: json['arguments'] as String,
    );
  }

  @override
  Map<String, dynamic> toJson() => {
    'type': type,
    'sequence_number': sequenceNumber,
    'item_id': itemId,
    'output_index': outputIndex,
    'arguments': arguments,
  };
}

/// Error event
class ErrorEvent implements StreamingEvent {
  @override
  final String type = 'error';
  final int sequenceNumber;
  final ErrorPayload error;

  ErrorEvent({required this.sequenceNumber, required this.error});

  factory ErrorEvent.fromJson(Map<String, dynamic> json) {
    return ErrorEvent(
      sequenceNumber: json['sequence_number'] as int,
      error: ErrorPayload.fromJson(json['error'] as Map<String, dynamic>),
    );
  }

  @override
  Map<String, dynamic> toJson() => {
    'type': type,
    'sequence_number': sequenceNumber,
    'error': error.toJson(),
  };
}

/// Error payload
class ErrorPayload {
  final String errorType;
  final String? code;
  final String message;
  final String? param;
  final Map<String, String>? headers;

  ErrorPayload({
    required this.errorType,
    this.code,
    required this.message,
    this.param,
    this.headers,
  });

  factory ErrorPayload.fromJson(Map<String, dynamic> json) {
    return ErrorPayload(
      errorType: json['type'] as String,
      code: json['code'] as String?,
      message: json['message'] as String,
      param: json['param'] as String?,
      headers: (json['headers'] as Map<String, dynamic>?)?.map(
        (k, v) => MapEntry(k, v as String),
      ),
    );
  }

  Map<String, dynamic> toJson() => {
    'type': errorType,
    if (code != null) 'code': code,
    'message': message,
    if (param != null) 'param': param,
    if (headers != null) 'headers': headers,
  };
}

/// Stream done marker
class StreamDoneEvent implements StreamingEvent {
  @override
  final String type = '[DONE]';

  @override
  Map<String, dynamic> toJson() => {'type': type};
}

/// Factory for streaming event deserialization
StreamingEvent streamingEventFromJson(Map<String, dynamic> json) {
  final type = json['type'] as String;
  switch (type) {
    case 'response.created':
      return ResponseCreatedEvent.fromJson(json);
    case 'response.queued':
      return ResponseQueuedEvent.fromJson(json);
    case 'response.in_progress':
      return ResponseInProgressEvent.fromJson(json);
    case 'response.completed':
      return ResponseCompletedEvent.fromJson(json);
    case 'response.failed':
      return ResponseFailedEvent.fromJson(json);
    case 'response.incomplete':
      return ResponseIncompleteEvent.fromJson(json);
    case 'response.output_item.added':
      return OutputItemAddedEvent.fromJson(json);
    case 'response.output_item.done':
      return OutputItemDoneEvent.fromJson(json);
    case 'response.output_text.delta':
      return OutputTextDeltaEvent.fromJson(json);
    case 'response.output_text.done':
      return OutputTextDoneEvent.fromJson(json);
    case 'response.content_part.added':
      return ContentPartAddedEvent.fromJson(json);
    case 'response.content_part.done':
      return ContentPartDoneEvent.fromJson(json);
    case 'response.function_call_arguments.delta':
      return FunctionCallArgumentsDeltaEvent.fromJson(json);
    case 'response.function_call_arguments.done':
      return FunctionCallArgumentsDoneEvent.fromJson(json);
    case 'error':
      return ErrorEvent.fromJson(json);
    case '[DONE]':
      return StreamDoneEvent();
    default:
      throw ArgumentError('Unknown streaming event type: $type');
  }
}
