class Chat {
  final int? chatId;
  final String topic;
  final String firstMessage;

  Chat({
    this.chatId,
    required this.topic,
    required this.firstMessage,
  });

  Map<String, Object?> toJson() => {
        ChatFields.chatId: chatId,
        ChatFields.topic: topic,
        ChatFields.firstMessage: firstMessage,
      };

  static Chat fromJson(Map<String, Object?> json) => Chat(
        chatId: json[ChatFields.chatId] as int?,
        topic: json[ChatFields.topic] as String,
        firstMessage: json[ChatFields.firstMessage] as String,
      );

  Chat copy({
    int? chatId,
    String? topic,
    String? firstMessage,
  }) =>
      Chat(
        chatId: chatId ?? this.chatId,
        topic: topic ?? this.topic,
        firstMessage: firstMessage ?? this.firstMessage,
      );
}

const chatsTable = 'chats';

class ChatFields {
  static const chatId = 'chat_id';
  static const topic = 'topic';
  static const firstMessage = 'first_message';
}
