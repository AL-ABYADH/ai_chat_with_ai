import 'package:flutter/material.dart';

import '../screens/chat_screen.dart';

class StartChat extends StatefulWidget {
  final Future Function() refreshMethod;

  const StartChat({
    required this.refreshMethod,
    super.key,
  });

  @override
  State<StartChat> createState() => _StartChatState();
}

class _StartChatState extends State<StartChat> {
  final _titleInput = TextEditingController();
  final _amountInput = TextEditingController();

  void _submitData() {
    if (_amountInput.text.isEmpty) return;
    final topic = _titleInput.text;
    final message = _amountInput.text;

    if (topic.isEmpty || message.isEmpty) {
      return;
    }

    Navigator.of(context).pop();
    Navigator.of(context).pushNamed(ChatScreen.routeName, arguments: {
      'topic': topic,
      'message': message,
      'refreshMethod': widget.refreshMethod,
      'newChat': true,
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Card(
        elevation: 5,
        child: Container(
          padding: EdgeInsets.only(
            top: 10,
            left: 10,
            right: 10,
            bottom: MediaQuery.of(context).viewInsets.bottom + 10,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              TextField(
                cursorColor: Theme.of(context).primaryColor,
                controller: _titleInput,
                decoration: InputDecoration(
                  labelText: 'Chat Topic',
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  floatingLabelStyle: TextStyle(
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ),
              TextField(
                cursorColor: Theme.of(context).primaryColor,
                controller: _amountInput,
                decoration: InputDecoration(
                  labelText: 'First Message',
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  floatingLabelStyle: TextStyle(
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                onSubmitted: (_) => _submitData(),
              ),
              const SizedBox(height: 10),
              TextButton(
                onPressed: _submitData,
                child: const Text(
                  'Start Chat',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
