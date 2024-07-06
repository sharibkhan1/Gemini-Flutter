// import 'package:shared_preferences/shared_preferences.dart';
//
// class ChatHelper {
//   static const String _chatKeyPrefix = 'saved_chat_';
//
//   // Save chat message to SharedPreferences
//   static Future<void> saveChat(String chatMessage) async {
//     final prefs = await SharedPreferences.getInstance();
//     int chatNumber = (prefs.getInt('chat_count') ?? 0) + 1; // Increment chat number
//     await prefs.setString('$_chatKeyPrefix$chatNumber', chatMessage);
//     await prefs.setInt('chat_count', chatNumber);
//   }
//
//   // Load all saved chats from SharedPreferences
//   static Future<List<String>> loadChats() async {
//     final prefs = await SharedPreferences.getInstance();
//     int chatCount = prefs.getInt('chat_count') ?? 0;
//     List<String> chats = [];
//     for (int i = 1; i <= chatCount; i++) {
//       String? chatMessage = prefs.getString('$_chatKeyPrefix$i');
//       if (chatMessage != null) {
//         chats.add(chatMessage);
//       }
//     }
//     return chats;
//   }
// }
