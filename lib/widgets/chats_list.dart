import 'package:flutter/material.dart';

import '../models/chat.dart';
import '../widgets/chat_item.dart';

class ChatsList extends StatelessWidget {
  final List<Chat> chats;
  final Future Function() refreshMethod;

  const ChatsList({
    required this.chats,
    required this.refreshMethod,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return chats.isEmpty
        ? Center(
            child: LayoutBuilder(
              builder: (ctx, constraints) {
                return Column(
                  children: [
                    SizedBox(
                      height: constraints.maxHeight * 0.1,
                    ),
                    SizedBox(
                      height: constraints.maxHeight * 0.5,
                      child: const Image(
                        fit: BoxFit.cover,
                        image: AssetImage(
                          'lib/assets/waiting.png',
                        ),
                      ),
                    ),
                    SizedBox(
                      height: constraints.maxHeight * 0.1,
                    ),
                    SizedBox(
                      height: constraints.maxHeight * 0.3,
                      child: const Text(
                        'You have no chats yet!',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          )
        : SizedBox(
            child: GlowingOverscrollIndicator(
              axisDirection: AxisDirection.down,
              color: Theme.of(context).primaryColor,
              child: ListView(
                children: chats
                    .map((chat) => Column(
                          children: [
                            const SizedBox(
                              height: 10,
                            ),
                            ChatItem(
                              chatId: chat.chatId!,
                              topic: chat.topic,
                              firstMessage: chat.firstMessage,
                              refreshMethod: refreshMethod,
                            ),
                          ],
                        ))
                    .toList(),
              ),
            ),
          );
  }
}
