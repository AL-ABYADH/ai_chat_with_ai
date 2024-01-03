import 'dart:async';
import 'dart:io';

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
        '''Continue the following chat. The topic of the chat is "$topic". Keep it very casual and informal. Respond to the current message with only one short message. If the chat has not got into the topic, make sure you mention the topic. Don't agree the whole time. Make sure you keep the conversation exciting.
      ${_getChatHistory('bot_1')} Me: $_currentMessage <-- This is the current message
      You:
    ''';

    String bot2Message = _sendTo == SendTo.bot2
        ? ''
        : '''Continue the following chat. The topic of the chat is "$topic". Keep it casual and very informal. Respond to the current message with only one short message. If the chat has not got into the topic, make sure you mention the topic. Don't agree the whole time. Make sure you keep the conversation exciting.
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
    } else {
      await _sendToBot1(bot2Message, openAI, topic);
    }

    if (_stop) return;
    await start(firstMessage: _currentMessage, topic: topic);
  }

  Future<String> _sendToBot2(bot1Message, bot2Message, openAI, topic) async {
    print('\n&&&&&&&&&&&&&&&&&called send to bot 2&&&&&&&&&&&&&&&&&&&\n');
    try {
      final request = ChatCompleteText(messages: [
        Messages(role: Role.user, content: bot1Message),
      ], maxToken: 200, model: GptTurboChatModel());

      const r = RetryOptions(maxAttempts: 100);

      print('\n===============started sending to bot 2==================\n');
      final response = await r.retry(
        () {
          print(
              '\n+++++++++++++++++++++tried sending to bot 2+++++++++++++++++++++++\n');
          return openAI
              .onChatCompletion(request: request)
              .timeout(const Duration(seconds: 30));
        },
        retryIf: (e) => e is SocketException || e is TimeoutException,
      );
      print('\n-----------------finished sending to bot 2----------------\n');

      if (_stop) return bot2Message;

      _currentMessage = '';

      for (var element in response!.choices) {
        _currentMessage = _currentMessage + (element.message?.content)!;
      }

      _sendTo = SendTo.bot1;

      bot2Message =
          '''Continue the following chat. The topic of the chat is "$topic". Keep your messages short, casual, and very informal. Respond to the current message with only one short message. If the chat has not got into the topic, make sure you mention the topic. Don't agree the whole time. Make sure you keep the conversation exciting.
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
      print("error: $err");
      if (err.toString().contains('status code :429')) {
        await Future.delayed(const Duration(seconds: 20));
      }
    }

    return bot2Message;
  }

  Future<void> _sendToBot1(bot2Message, openAI, topic) async {
    print('\n&&&&&&&&&&&&&&&&&called send to bot 1&&&&&&&&&&&&&&&&&&&\n');
    try {
      final request = ChatCompleteText(messages: [
        Messages(role: Role.user, content: bot2Message),
      ], maxToken: 200, model: GptTurboChatModel());

      const r = RetryOptions(maxAttempts: 100);

      print('\n================started sending to bot 1=================\n');
      final response = await r.retry(
        () {
          print(
              '\n+++++++++++++++++++++tried sending to bot 1+++++++++++++++++++++++\n');
          return openAI
              .onChatCompletion(request: request)
              .timeout(const Duration(seconds: 30));
        },
        retryIf: (e) => e is SocketException || e is TimeoutException,
      );
      print(
          '\n--------------------finished sending to bot 1---------------------\n');

      if (_stop) return;

      _currentMessage = '';

      for (var element in response!.choices) {
        _currentMessage = _currentMessage + (element.message?.content)!;
      }

      _sendTo = SendTo.bot2;
    } catch (err) {
      print("error: $err");
      if (err.toString().contains('status code :429')) {
        await Future.delayed(const Duration(seconds: 20));
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
