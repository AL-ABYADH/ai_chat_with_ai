import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/message.dart';
import '../models/chat.dart';

class ChatsDb {
  static final ChatsDb instance = ChatsDb._init();

  static Database? _database;

  ChatsDb._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('chats.db');

    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    const primaryKeyType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const foreignKeyType = 'INTEGER';
    const stringType = 'TEXT';

    const foreignKeyConstraint =
        'FOREIGN KEY (${MessageFields.chatId}) REFERENCES $chatsTable(${ChatFields.chatId})';
    const chatPartnerCheck =
        'CHECK (${MessageFields.chatPartner} IN (\'bot_1\', \'bot_2\'))';

    await db.execute(
      '''
      CREATE TABLE $chatsTable (
        ${ChatFields.chatId} $primaryKeyType,
        ${ChatFields.topic} $stringType,
        ${ChatFields.firstMessage} $stringType
      )
      ''',
    );

    await db.execute(
      '''
      CREATE TABLE $messagesTable (
        ${MessageFields.messageId} $primaryKeyType,
        ${MessageFields.chatId} $foreignKeyType,
        ${MessageFields.content} $stringType,
        ${MessageFields.chatPartner} $stringType,
        $foreignKeyConstraint,
        $chatPartnerCheck
      )
      ''',
    );
  }

  Future<Chat> saveChat(Chat chat) async {
    final db = await instance.database;

    final chatId = await db.insert(chatsTable, chat.toJson());
    return chat.copy(chatId: chatId);
  }

  Future<List<Chat>> loadChats() async {
    final db = await instance.database;

    final result =
        await db.query(chatsTable, orderBy: '${ChatFields.chatId} ASC');
    return result.map((json) => Chat.fromJson(json)).toList();
  }

  Future<int> deleteChat(int chatId) async {
    final db = await instance.database;

    return await db.delete(
      chatsTable,
      where: '${ChatFields.chatId} = ?',
      whereArgs: [chatId],
    );
  }

  Future<void> saveMessages(List<Message> messages) async {
    final db = await instance.database;

    for (Message message in messages) {
      await db.insert(messagesTable, message.toJson());
    }
  }

  Future<List<Message>> loadChatMessages(int chatId) async {
    final db = await instance.database;

    final result = await db.query(messagesTable,
        where: '${MessageFields.chatId} = ?',
        whereArgs: [chatId],
        orderBy: '${MessageFields.messageId} ASC');

    final loadedMessages =
        result.map((json) => Message.fromJson(json)).toList();

    return loadedMessages;
  }

  void clearTables() async {
    final db = await instance.database;

    await db.delete(chatsTable);
    await db.delete(messagesTable);
  }

  void checkTable() async {
    final db = await instance.database;

    final result = await db.rawQuery(
        'SELECT * FROM $messagesTable WHERE ${MessageFields.chatId} = 9');

    for (Map r in result) {
      print(r[MessageFields.content]);
    }
  }

  Future close() async {
    final db = await instance.database;

    db.close();
  }
}
