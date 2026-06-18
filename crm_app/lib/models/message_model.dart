class Message {
  final String id;
  final String senderId;
  final String senderName;
  final String recipientId;
  final String? projectId;
  final String messageText;
  final bool isBroadcast;
  final DateTime createdAt;
  final DateTime? readAt;

  Message({
    required this.id,
    required this.senderId,
    required this.senderName,
    required this.recipientId,
    this.projectId,
    required this.messageText,
    required this.isBroadcast,
    required this.createdAt,
    this.readAt,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id'] as String,
      senderId: json['sender_id'] as String,
      senderName: json['sender_name'] as String? ?? 'Unknown',
      recipientId: json['recipient_id'] as String,
      projectId: json['project_id'] as String?,
      messageText: json['message_text'] as String,
      isBroadcast: json['is_broadcast'] as bool? ?? false,
      createdAt: DateTime.parse(json['created_at'] as String),
      readAt: json['read_at'] != null
          ? DateTime.parse(json['read_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'sender_id': senderId,
      'sender_name': senderName,
      'recipient_id': recipientId,
      'project_id': projectId,
      'message_text': messageText,
      'is_broadcast': isBroadcast,
      'created_at': createdAt.toIso8601String(),
      'read_at': readAt?.toIso8601String(),
    };
  }

  bool get isRead => readAt != null;
}
