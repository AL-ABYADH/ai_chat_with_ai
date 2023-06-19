class Message {
  late final int? messageId;
  late final int? chatId;
  final String content;
  final String chatPartner;

  Message({
    this.messageId,
    this.chatId,
    required this.content,
    required this.chatPartner,
  });

  Map<String, Object?> toJson() => {
        MessageFields.messageId: messageId,
        MessageFields.chatId: chatId,
        MessageFields.content: content,
        MessageFields.chatPartner: chatPartner,
      };

  static Message fromJson(Map<String, Object?> json) => Message(
        messageId: json[MessageFields.chatId] as int?,
        chatId: json[MessageFields.chatId] as int,
        content: json[MessageFields.content] as String,
        chatPartner: json[MessageFields.chatPartner] as String,
      );

  Message copy({
    int? messageId,
    int? chatId,
    String? content,
    String? chatPartner,
  }) =>
      Message(
        messageId: messageId ?? this.messageId,
        chatId: chatId ?? this.chatId,
        content: content ?? this.content,
        chatPartner: chatPartner ?? this.chatPartner,
      );
}

const messagesTable = 'messages';

class MessageFields {
  static const messageId = 'message_id';
  static const chatId = 'chat_id';
  static const content = 'content';
  static const chatPartner = 'chat_partner';
}
