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
    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(20)),
        color: Theme.of(context).secondaryHeaderColor,
      ),
      margin: const EdgeInsets.symmetric(horizontal: 10),
      child: Dismissible(
        onDismissed: (direction) {
          ChatsDb.instance.deleteChat(chatId);
          refreshMethod();
        },
        key: ValueKey(chatId),
        direction: DismissDirection.endToStart,
        confirmDismiss: (direction) {
          return showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
              title: Text(
                'Confirm Deletion',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              content: const Text('Do you want to delete this chat?'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(ctx).pop(false);
                  },
                  child: Text(
                    'Cancel',
                    style: TextStyle(color: Theme.of(context).primaryColor),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(ctx).pop(true);
                  },
                  child: Text(
                    'Delete',
                    style: TextStyle(color: Theme.of(context).primaryColor),
                  ),
                ),
              ],
            ),
          );
        },
        background: Container(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(20)),
            color: Theme.of(context).colorScheme.error,
          ),
          alignment: Alignment.centerRight,
          child: const Icon(
            Icons.delete,
            color: Colors.white,
            size: 40,
          ),
        ),
        child: GestureDetector(
          onTap: () => enterChat(context),
          child: ListTile(
            title: Text(
              topic,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            subtitle: Text(firstMessage),
          ),
        ),
      ),
    );
  }
}
