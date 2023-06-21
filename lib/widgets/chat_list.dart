import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/chat_provider.dart';
import './message_bubble.dart';
import '../widgets/Typing.dart';

class ChatList extends StatefulWidget {
  final bool isChatting;
  const ChatList({required this.isChatting, super.key});

  @override
  State<ChatList> createState() => _ChatListState();
}

class _ChatListState extends State<ChatList> {
  final ScrollController _controller = ScrollController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final messagesData = Provider.of<ChatProvider>(context);
    final messages = messagesData.messages;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _controller.animateTo(
        _controller.position.maxScrollExtent,
        duration: const Duration(milliseconds: 500),
        curve: Curves.ease,
      );
    });

    return Column(
      children: [
        Expanded(
          child: ListView.builder(
              controller: _controller,
              itemCount: messages.length,
              itemBuilder: (ctx, index) {
                return MessageBubble(
                  message: messages[index],
                );
              }),
        ),
        if (widget.isChatting && messages.isNotEmpty)
          SizedBox(
            height: 40,
            child: Typing(
                direction: messages[messages.length - 1].chatPartner == 'bot_1'
                    ? 'left'
                    : 'right'),
          )
      ],
    );
  }
}
