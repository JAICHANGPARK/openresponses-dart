import 'enums.dart';

/// Abstract base class for input content
abstract class InputContent {
  String get type;
  Map<String, dynamic> toJson();
}

/// Text input content
class InputTextContent implements InputContent {
  @override
  final String type = 'input_text';
  final String text;

  InputTextContent({required this.text});

  factory InputTextContent.fromJson(Map<String, dynamic> json) {
    return InputTextContent(text: json['text'] as String);
  }

  @override
  Map<String, dynamic> toJson() => {'type': type, 'text': text};
}

/// Image input content
class InputImageContent implements InputContent {
  @override
  final String type = 'input_image';
  final String? imageUrl;
  final ImageDetail detail;

  InputImageContent({this.imageUrl, this.detail = ImageDetail.auto});

  factory InputImageContent.fromJson(Map<String, dynamic> json) {
    return InputImageContent(
      imageUrl: json['image_url'] as String?,
      detail: ImageDetail.fromJson(json['detail'] as String? ?? 'auto'),
    );
  }

  @override
  Map<String, dynamic> toJson() => {
    'type': type,
    if (imageUrl != null) 'image_url': imageUrl,
    'detail': detail.toJson(),
  };
}

/// File input content
class InputFileContent implements InputContent {
  @override
  final String type = 'input_file';
  final String? filename;
  final String? fileData;
  final String? fileUrl;

  InputFileContent({this.filename, this.fileData, this.fileUrl});

  factory InputFileContent.fromJson(Map<String, dynamic> json) {
    return InputFileContent(
      filename: json['filename'] as String?,
      fileData: json['file_data'] as String?,
      fileUrl: json['file_url'] as String?,
    );
  }

  @override
  Map<String, dynamic> toJson() => {
    'type': type,
    if (filename != null) 'filename': filename,
    if (fileData != null) 'file_data': fileData,
    if (fileUrl != null) 'file_url': fileUrl,
  };
}

/// Video input content
class InputVideoContent implements InputContent {
  @override
  final String type = 'input_video';
  final String videoUrl;

  InputVideoContent({required this.videoUrl});

  factory InputVideoContent.fromJson(Map<String, dynamic> json) {
    return InputVideoContent(videoUrl: json['video_url'] as String);
  }

  @override
  Map<String, dynamic> toJson() => {'type': type, 'video_url': videoUrl};
}

/// Factory for input content deserialization
InputContent inputContentFromJson(Map<String, dynamic> json) {
  final type = json['type'] as String;
  switch (type) {
    case 'input_text':
      return InputTextContent.fromJson(json);
    case 'input_image':
      return InputImageContent.fromJson(json);
    case 'input_file':
      return InputFileContent.fromJson(json);
    case 'input_video':
      return InputVideoContent.fromJson(json);
    default:
      throw ArgumentError('Unknown input content type: $type');
  }
}

/// Abstract base class for output content
abstract class OutputContent {
  String get type;
  Map<String, dynamic> toJson();
}

/// Text output content
class OutputTextContent implements OutputContent {
  @override
  final String type = 'output_text';
  final String text;
  final List<Annotation>? annotations;
  final List<LogProb>? logprobs;

  OutputTextContent({required this.text, this.annotations, this.logprobs});

  factory OutputTextContent.fromJson(Map<String, dynamic> json) {
    return OutputTextContent(
      text: json['text'] as String,
      annotations: (json['annotations'] as List<dynamic>?)
          ?.map((e) => Annotation.fromJson(e as Map<String, dynamic>))
          .toList(),
      logprobs: (json['logprobs'] as List<dynamic>?)
          ?.map((e) => LogProb.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  @override
  Map<String, dynamic> toJson() => {
    'type': type,
    'text': text,
    if (annotations != null)
      'annotations': annotations!.map((e) => e.toJson()).toList(),
    if (logprobs != null) 'logprobs': logprobs!.map((e) => e.toJson()).toList(),
  };
}

/// Refusal content
class RefusalContent implements OutputContent {
  @override
  final String type = 'refusal';
  final String refusal;

  RefusalContent({required this.refusal});

  factory RefusalContent.fromJson(Map<String, dynamic> json) {
    return RefusalContent(refusal: json['refusal'] as String);
  }

  @override
  Map<String, dynamic> toJson() => {'type': type, 'refusal': refusal};
}

/// Plain text content
class TextContent implements OutputContent {
  @override
  final String type = 'text';
  final String text;

  TextContent({required this.text});

  factory TextContent.fromJson(Map<String, dynamic> json) {
    return TextContent(text: json['text'] as String);
  }

  @override
  Map<String, dynamic> toJson() => {'type': type, 'text': text};
}

/// Summary text content
class SummaryTextContent implements OutputContent {
  @override
  final String type = 'summary_text';
  final String text;

  SummaryTextContent({required this.text});

  factory SummaryTextContent.fromJson(Map<String, dynamic> json) {
    return SummaryTextContent(text: json['text'] as String);
  }

  @override
  Map<String, dynamic> toJson() => {'type': type, 'text': text};
}

/// Reasoning text content
class ReasoningTextContent implements OutputContent {
  @override
  final String type = 'reasoning_text';
  final String text;

  ReasoningTextContent({required this.text});

  factory ReasoningTextContent.fromJson(Map<String, dynamic> json) {
    return ReasoningTextContent(text: json['text'] as String);
  }

  @override
  Map<String, dynamic> toJson() => {'type': type, 'text': text};
}

/// Factory for output content deserialization
OutputContent outputContentFromJson(Map<String, dynamic> json) {
  final type = json['type'] as String;
  switch (type) {
    case 'output_text':
      return OutputTextContent.fromJson(json);
    case 'refusal':
      return RefusalContent.fromJson(json);
    case 'text':
      return TextContent.fromJson(json);
    case 'summary_text':
      return SummaryTextContent.fromJson(json);
    case 'reasoning_text':
      return ReasoningTextContent.fromJson(json);
    default:
      throw ArgumentError('Unknown output content type: $type');
  }
}

/// URL citation annotation
class Annotation {
  final String type;
  final String url;
  final String title;
  final int startIndex;
  final int endIndex;

  Annotation({
    required this.type,
    required this.url,
    required this.title,
    required this.startIndex,
    required this.endIndex,
  });

  factory Annotation.fromJson(Map<String, dynamic> json) {
    return Annotation(
      type: json['type'] as String,
      url: json['url'] as String,
      title: json['title'] as String,
      startIndex: json['start_index'] as int,
      endIndex: json['end_index'] as int,
    );
  }

  Map<String, dynamic> toJson() => {
    'type': type,
    'url': url,
    'title': title,
    'start_index': startIndex,
    'end_index': endIndex,
  };
}

/// Log probability
class LogProb {
  final String token;
  final double logprob;
  final List<int> bytes;
  final List<TopLogProb> topLogprobs;

  LogProb({
    required this.token,
    required this.logprob,
    required this.bytes,
    required this.topLogprobs,
  });

  factory LogProb.fromJson(Map<String, dynamic> json) {
    return LogProb(
      token: json['token'] as String,
      logprob: (json['logprob'] as num).toDouble(),
      bytes: (json['bytes'] as List<dynamic>).cast<int>(),
      topLogprobs: (json['top_logprobs'] as List<dynamic>)
          .map((e) => TopLogProb.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
    'token': token,
    'logprob': logprob,
    'bytes': bytes,
    'top_logprobs': topLogprobs.map((e) => e.toJson()).toList(),
  };
}

/// Top log probability
class TopLogProb {
  final String token;
  final double logprob;
  final List<int> bytes;

  TopLogProb({required this.token, required this.logprob, required this.bytes});

  factory TopLogProb.fromJson(Map<String, dynamic> json) {
    return TopLogProb(
      token: json['token'] as String,
      logprob: (json['logprob'] as num).toDouble(),
      bytes: (json['bytes'] as List<dynamic>).cast<int>(),
    );
  }

  Map<String, dynamic> toJson() => {
    'token': token,
    'logprob': logprob,
    'bytes': bytes,
  };
}
