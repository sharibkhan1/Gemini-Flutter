import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/chat_provider.dart';
import 'chat_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ChatProvider(),
      child: Consumer<ChatProvider>(
        builder: (context, chatProvider, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: chatProvider.isDarkMode ? ThemeData.dark() : ThemeData.light(),
            home: ChatScreen(),
          );
        },
      ),
    );
  }
}
