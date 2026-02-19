class MessageModel {
  final String messageId;
  final String userId;
  final String messageText;
  final String sender;
  final DateTime timestamp;
  final String? intent;
  final bool isResolved;

  MessageModel({
    required this.messageId,
    required this.userId,
    required this.messageText,
    required this.sender,
    required this.timestamp,
    this.intent,
    this.isResolved = false,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) => MessageModel(
        messageId: json['messageId'] as String,
        userId: json['userId'] as String,
        messageText: json['messageText'] as String,
        sender: json['sender'] as String,
        timestamp: DateTime.parse(json['timestamp'] as String),
        intent: json['intent'] as String?,
        isResolved: json['isResolved'] as bool? ?? false,
      );

  Map<String, dynamic> toJson() => {
        'messageId': messageId,
        'userId': userId,
        'messageText': messageText,
        'sender': sender,
        'timestamp': timestamp.toIso8601String(),
        'intent': intent,
        'isResolved': isResolved,
      };
}
