import 'package:flutter/material.dart';

import '../db/chats_db.dart';
import '../widgets/start_chat.dart';
import '../models/chat.dart';
import '../widgets/chats_list.dart';

class ChatsScreen extends StatefulWidget {
  const ChatsScreen({super.key});

  @override
  State<ChatsScreen> createState() => _ChatsScreenState();
}

class _ChatsScreenState extends State<ChatsScreen> {
  late List<Chat> chats;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();

    refreshChats();
  }

  @override
  void dispose() {
    ChatsDb.instance.close();

    super.dispose();
  }

  Future refreshChats() async {
    setState(() => _isLoading = true);

    chats = await ChatsDb.instance.loadChats();

    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    void _startChatOptions(BuildContext ctx) {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (_) => StartChat(refreshMethod: refreshChats),
      );
    }

    return Scaffold(
        appBar: AppBar(),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        floatingActionButton: FloatingActionButton(
          onPressed: () => _startChatOptions(context),
          backgroundColor: Theme.of(context).primaryColor,
          foregroundColor: Colors.white,
          child: const Icon(
            Icons.chat,
          ),
        ),
        body: _isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : ChatsList(chats: chats, refreshMethod: refreshChats));
  }
}
