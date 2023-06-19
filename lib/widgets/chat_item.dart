import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/chat_provider.dart';
import '../screens/chat_screen.dart';
import '../models/message.dart';
import '../db/chats_db.dart';

class ChatItem extends StatelessWidget {
  final int chatId;
  final String topic;
  final String firstMessage;
  final Future Function() refreshMethod;

  const ChatItem({
    required this.chatId,
    required this.topic,
    required this.firstMessage,
    required this.refreshMethod,
    super.key,
  });

  void enterChat(ctx) async {
    List<Message> loadedMessages =
        await ChatsDb.instance.loadChatMessages(chatId);
    Provider.of<ChatProvider>(ctx, listen: false).loadMessages(loadedMessages);

    Navigator.of(ctx).pushNamed(ChatScreen.routeName, arguments: {
      'topic': topic,
      'message': firstMessage,
      'refreshMethod': refreshMethod,
      'newChat': false,
      'chatId': chatId,
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => enterChat(context),
      child: Card(
        elevation: 5,
        margin: const EdgeInsets.all(10),
        child: ListTile(
          title: Text(topic),
          subtitle: Text(firstMessage),
        ),
      ),
    );
  }
}
