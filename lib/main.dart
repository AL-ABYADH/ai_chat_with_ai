import 'package:flutter/material.dart';
import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:human_or_bot/screens/chats_screen.dart';
import 'package:provider/provider.dart';

import './screens/chat_screen.dart';
import 'providers/chat_provider.dart';

void main() async {
  await dotenv.load(fileName: "lib/.env");
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  static final openAI = OpenAI.instance.build(
    token: dotenv.env['API_KEY_1'],
    baseOption: HttpSetup(receiveTimeout: const Duration(seconds: 6000)),
  );

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: ChatProvider(),
      builder: (context, child) => MaterialApp(
        title: 'Bot to Bot',
        home: const ChatsScreen(),
        routes: {
          ChatScreen.routeName: (ctx) => const ChatScreen(),
        },
      ),
    );
  }
}
