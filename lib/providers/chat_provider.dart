import 'package:flutter/material.dart';
import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
import 'package:retry/retry.dart';

import '../main.dart';
import '../models/message.dart';

class ChatProvider with ChangeNotifier {
  List<Message> _messages = [];

  final List<Message> newMessages = [];

  var _stop = false;

  var _currentMessage = '';

  var _sendTo = SendTo.bot2;

  Future<void> start({
    required String topic,
    String? firstMessage,
  }) async {
    _stop = false;

    _currentMessage = firstMessage ?? _currentMessage;

    final OpenAI openAI = MyApp.openAI;

    String bot1Message =
        '''You're in a chatting app, and I'll be chatting with you. The topic of the chat is "$topic". Keep it very casual and informal. Respond to the current message with only one short message.
      ${_getChatHistory('bot_1')} Me: $_currentMessage <-- This is the current message
      You:
    ''';

    String bot2Message = _sendTo == SendTo.bot2
        ? ''
        : '''You are in a chatting app, and I'll be chatting with you. The topic of the chat is "$topic". Keep it casual and very informal. Respond to the current message with only one short message.
      ${_getChatHistory('bot_2')} Me: $_currentMessage <-- This is the current message
      You:
    ''';

    var message = Message(content: _currentMessage, chatPartner: 'bot_1');
    if (_messages.isNotEmpty) {
      if (_messages[_messages.length - 1].content != message.content) {
        _messages.add(message);
        newMessages.add(message);
      }
    } else {
      _messages.add(message);
      newMessages.add(message);
    }

    notifyListeners();
    if (_sendTo == SendTo.bot2) {
      bot2Message = await _sendToBot2(bot1Message, bot2Message, openAI, topic);
    }

    if (_stop) return;
    await _sendToBot1(bot2Message, openAI, topic);

    if (_stop) return;
    await start(firstMessage: _currentMessage, topic: topic);
  }

  Future<String> _sendToBot2(bot1Message, bot2Message, openAI, topic) async {
    try {
      final request = ChatCompleteText(
        messages: [
          Map.of({"role": "user", "content": bot1Message})
        ],
        maxToken: 200,
        model: ChatModel.gptTurbo0301,
      );

      const r = RetryOptions(maxAttempts: 100);

      final response = await r
          .retry(() => openAI.onChatCompletion(request: request))
          .timeout(const Duration(seconds: 50));

      if (_stop) return bot2Message;

      _currentMessage = '';

      for (var element in response!.choices) {
        _currentMessage = _currentMessage + (element.message?.content)!;
      }

      _sendTo = SendTo.bot1;

      bot2Message =
          '''You are in a chatting app, and I'll be chatting with you. The topic of the chat is "$topic". Keep your messages short, casual, and very informal. Respond to the current message with only one short message.
      ${_getChatHistory('bot_2')} Me: $_currentMessage <-- This is the current message
      You:
    ''';

      var message = Message(content: _currentMessage, chatPartner: 'bot_2');
      if (_messages[_messages.length - 1].content != message.content) {
        _messages.add(message);
        newMessages.add(message);
      }

      notifyListeners();
    } catch (err) {
      print(err);

      if (!_stop) {
        start(topic: topic);
      }
    }

    return bot2Message;
  }

  Future<void> _sendToBot1(bot2Message, openAI, topic) async {
    try {
      final request = ChatCompleteText(
        messages: [
          Map.of({"role": "user", "content": bot2Message})
        ],
        maxToken: 200,
        model: ChatModel.gptTurbo0301,
      );

      const r = RetryOptions(maxAttempts: 100);

      final response = await r
          .retry(() => openAI.onChatCompletion(request: request))
          .timeout(const Duration(seconds: 50));

      if (_stop) return;

      _currentMessage = '';

      for (var element in response!.choices) {
        _currentMessage = _currentMessage + (element.message?.content)!;
      }

      _sendTo = SendTo.bot2;
    } catch (err) {
      print(err);

      if (!_stop) {
        start(topic: topic);
      }
    }

    return;
  }

  String _getChatHistory(String bot) {
    String history = '';
    for (Message message in _messages) {
      history = bot == 'bot_1'
          ? "$history ${(message.chatPartner == 'bot_1' ? 'Me: ${message.content}' : 'You: ${message.content}')}\n"
          : "$history ${(message.chatPartner == 'bot_1' ? 'You: ${message.content}' : 'Me: ${message.content}')}\n";
    }
    return history;
  }

  void loadMessages(List<Message> loadedMessages) {
    _messages = loadedMessages;
    Message lastMessage = loadedMessages[loadedMessages.length - 1];
    _currentMessage = lastMessage.content;
    _sendTo = lastMessage.chatPartner == 'bot_1' ? SendTo.bot2 : SendTo.bot1;
    notifyListeners();
  }

  void stop() {
    _stop = true;
  }

  void clear() {
    _messages.clear();
    newMessages.clear();
    _currentMessage = '';
    _sendTo = SendTo.bot2;
    notifyListeners();
  }

  List<Message> get messages {
    return [..._messages];
  }
}

enum SendTo {
  bot1,
  bot2,
}
