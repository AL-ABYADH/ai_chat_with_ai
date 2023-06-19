import 'package:flutter/material.dart';

import '../models/message.dart';

class MessageBubble extends StatelessWidget {
  final Message message;

  const MessageBubble({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Wrap(
        alignment: message.chatPartner == 'bot_1'
            ? WrapAlignment.end
            : WrapAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10.0),
            constraints: const BoxConstraints(maxWidth: 300),
            decoration: BoxDecoration(
              borderRadius: message.chatPartner == 'bot_1'
                  ? const BorderRadius.only(
                      bottomLeft: Radius.circular(12),
                      topLeft: Radius.circular(12),
                      topRight: Radius.circular(12),
                    )
                  : const BorderRadius.only(
                      bottomRight: Radius.circular(12),
                      topLeft: Radius.circular(12),
                      topRight: Radius.circular(12),
                    ),
              color: message.chatPartner == 'bot_1'
                  ? Colors.lightBlue
                  : const Color.fromARGB(255, 229, 229, 229),
            ),
            child: Text(
              message.content,
              style: const TextStyle(
                fontSize: 18,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
