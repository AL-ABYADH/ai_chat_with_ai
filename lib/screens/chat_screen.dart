import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../db/chats_db.dart';
import '../models/chat.dart';
import '../widgets/chat_list.dart';
import '../providers/chat_provider.dart';
import '../models/message.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});
  static const routeName = '/chat-screen';

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  var _isChatting = true;
  var _newChat = true;
  var _goBack = false;
  var _rebuildCount = 0;

  @override
  Widget build(BuildContext context) {
    _rebuildCount += 1;
    final chatData = ModalRoute.of(context)!.settings.arguments as Map;
    final firstMessage = chatData['message'];
    final topic = chatData['topic'];
    final int? chatId = chatData['chatId'];

    // Only set the value with the first run of the build method
    if (_rebuildCount == 1) {
      _newChat = chatData['newChat'];
      _isChatting = _newChat;
    }

    final mediaQuery = MediaQuery.of(context);
    final appBar = AppBar(
      title: Text(chatData['topic']),
    );

    void showLoadingDialog(String message) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(message),
                const CircularProgressIndicator(),
              ],
            ),
          );
        },
      );
    }

    void startChat({bool continueChat = true}) async {
      setState(() {
        _isChatting = true;
      });
      await Provider.of<ChatProvider>(context, listen: false).start(
        firstMessage: continueChat ? null : firstMessage,
        topic: topic,
      );
      setState(() {
        _isChatting = false;
      });
      Navigator.of(context).pop();
      if (_goBack) {
        Provider.of<ChatProvider>(context, listen: false).clear();
        Navigator.of(context).pop();
      }
    }

    void pauseChat() {
      Provider.of<ChatProvider>(context, listen: false).stop();
      showLoadingDialog('Pausing chat...');
    }

    Future<void> saveChat() async {
      Navigator.of(context).pop();

      final List<Message> messagesWithChatId;

      if (_newChat) {
        // Save the new chat to the database and save the messages using its id
        final chat =
            Chat(topic: chatData['topic'], firstMessage: chatData['message']);

        final savedChat = await ChatsDb.instance.saveChat(chat);

        messagesWithChatId = Provider.of<ChatProvider>(context, listen: false)
            .newMessages
            .map((message) => message.copy(chatId: savedChat.chatId))
            .toList();
      } else {
        // Save the messages using the id of the old chat
        messagesWithChatId = Provider.of<ChatProvider>(context, listen: false)
            .newMessages
            .map((message) => message.copy(chatId: chatId))
            .toList();
      }

      await ChatsDb.instance.saveMessages(messagesWithChatId);

      if (_isChatting) {
        _goBack = true;
        pauseChat();
      } else {
        Navigator.of(context).pop();
      }

      // Refresh the chats list
      chatData['refreshMethod']();
    }

    void discardChat() {
      if (_isChatting) {
        _goBack = true;
        pauseChat();
      } else {
        Navigator.of(context).pop();

        // Clear the chat screen
        Provider.of<ChatProvider>(context, listen: false).clear();
      }
    }

    if (_newChat && _rebuildCount == 1) {
      Future.delayed(const Duration(milliseconds: 500),
          () => startChat(continueChat: false));
    }

    return WillPopScope(
      onWillPop: () async {
        if (Provider.of<ChatProvider>(context, listen: false)
            .newMessages
            .isNotEmpty) {
          await showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                content: const Text('Save chat or discard it?'),
                actions: [
                  TextButton(
                    child: const Text('Cancel'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      discardChat();
                    },
                    child: const Text('Discard'),
                  ),
                  TextButton(
                    onPressed: saveChat,
                    child: const Text('Save'),
                  ),
                ],
              );
            },
          );
        } else {
          discardChat();
        }

        return false;
      },
      child: Scaffold(
        appBar: appBar,
        body: Column(
          children: [
            const Expanded(
              child: ChatList(),
            ),
            _isChatting
                ? ElevatedButton(
                    onPressed: pauseChat, child: const Text('Pause Chat'))
                : ElevatedButton(
                    onPressed: startChat, child: const Text('Continue Chat')),
            const SizedBox(
              width: 10,
            ),
          ],
        ),
      ),
    );
  }
}
