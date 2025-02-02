enum MessageRole { user, assistant, system }

enum MessageType { text, image }

class AIMessage {
  final String content;
  final MessageRole role;
  final MessageType type;
  final String? imageUrl;
  final DateTime timestamp;
  final Map<String, dynamic>? metadata;

   AIMessage({
    required this.content,
    required this.role,
    this.type = MessageType.text,
    this.imageUrl,
    this.metadata,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();

  factory AIMessage.user(String content) {
    return AIMessage(
      content: content,
      role: MessageRole.user,
    );
  }

  factory AIMessage.assistant(String content) {
    return AIMessage(
      content: content,
      role: MessageRole.assistant,
    );
  }

  factory AIMessage.system(String content) {
    return AIMessage(
      content: content,
      role: MessageRole.system,
    );
  }

  factory AIMessage.image({
    required String prompt,
    required String imageUrl,
    MessageRole role = MessageRole.assistant,
    Map<String, dynamic>? metadata,
  }) {
    return AIMessage(
      content: prompt,
      role: role,
      type: MessageType.image,
      imageUrl: imageUrl,
      metadata: metadata,
    );
  }

  AIMessage copyWith({
    String? content,
    MessageRole? role,
    MessageType? type,
    String? imageUrl,
    DateTime? timestamp,
    Map<String, dynamic>? metadata,
  }) {
    return AIMessage(
      content: content ?? this.content,
      role: role ?? this.role,
      type: type ?? this.type,
      imageUrl: imageUrl ?? this.imageUrl,
      timestamp: timestamp ?? this.timestamp,
      metadata: metadata ?? this.metadata,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'content': content,
      'role': role.toString(),
      'type': type.toString(),
      'timestamp': timestamp.toIso8601String(),
      if (imageUrl != null) 'imageUrl': imageUrl,
      if (metadata != null) 'metadata': metadata,
    };
  }

  factory AIMessage.fromJson(Map<String, dynamic> json) {
    return AIMessage(
      content: json['content'] as String,
      role: MessageRole.values.firstWhere(
        (e) => e.toString() == json['role'],
        orElse: () => MessageRole.user,
      ),
      type: MessageType.values.firstWhere(
        (e) => e.toString() == json['type'],
        orElse: () => MessageType.text,
      ),
      imageUrl: json['imageUrl'] as String?,
      timestamp: DateTime.parse(json['timestamp'] as String),
      metadata: json['metadata'] as Map<String, dynamic>?,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AIMessage &&
        other.content == content &&
        other.role == role &&
        other.type == type &&
        other.timestamp == timestamp &&
        other.imageUrl == imageUrl &&
        other.metadata == metadata;
  }

  @override
  int get hashCode {
    return Object.hash(
      content,
      role,
      type,
      timestamp,
      imageUrl,
      metadata,
    );
  }
}
