import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'providers/chat_provider.dart';
import 'message_widget.dart';
import 'typing_indicator.dart';

class ChatScreen extends StatelessWidget {
  ChatScreen({Key? key}) : super(key: key);

  final TextEditingController textPrompt = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final chatProvider = Provider.of<ChatProvider>(context);
    return Scaffold(
      backgroundColor: chatProvider.isDarkMode ? Color(0xff222222) : Colors.white,
      appBar: AppBar(
        leading: const Padding(
          padding: EdgeInsets.only(left: 10.0),
          child: Image(
            image: AssetImage("assets/360_F_446386956_DiOrdcxDFWKWFuzVUCugstxz0zOGMHnA-removebg-preview.png"),
            color: Colors.white,
            width: 50,
          ),
        ),
        title: Text(
          'CHAT BOT',
          style: TextStyle(color: chatProvider.isDarkMode ? Colors.white : Color(0xffECEFF1), fontWeight: FontWeight.bold),
        ),
        backgroundColor: chatProvider.isDarkMode ? Color(0xff333333) : Color(0xff1E3A5F),
        elevation: 3,
        titleSpacing: 16,
        actions: [
          IconButton(
            icon: chatProvider.isDarkMode
                ? Icon(Icons.light_mode, color: Colors.white, size: 24)
                : Icon(Icons.dark_mode, color: Colors.white, size: 24),
            onPressed: chatProvider.toggleTheme,
          ),
        ],
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    controller: chatProvider.scrollController,
                    itemCount: chatProvider.isTyping ? chatProvider.prompt.length + 1 : chatProvider.prompt.length,
                    itemBuilder: (context, index) {
                      if (index == chatProvider.prompt.length) {
                        return CustomTypingIndicator();
                      }
                      final message = chatProvider.prompt[index];
                      return MessageWidget(
                        isPrompt: message.isPrompt,
                        message: message.message,
                        date: DateFormat('hh:mm a').format(message.time),
                      );
                    },
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      flex: 32,
                      child: TextField(
                        autocorrect: true,
                        controller: textPrompt,
                        style: TextStyle(
                            color: chatProvider.isDarkMode ? Colors.white : Colors.black, fontWeight: FontWeight.w700),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: chatProvider.isDarkMode ? Color(0xff333333) : Colors.white,
                          contentPadding: EdgeInsets.symmetric(vertical: 18, horizontal: 20), // Adjust content padding
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(50)),
                          hintText: 'How can I help you....',
                        ),
                      ),
                    ),
                    Spacer(),
                    GestureDetector(
                      onTap: () {
                        FocusManager.instance.primaryFocus?.unfocus(); // Close the keyboard
                        chatProvider.sendMessage(textPrompt.text);
                        textPrompt.clear();
                      },
                      child: CircleAvatar(
                        radius: 32,
                        backgroundColor: chatProvider.isDarkMode ? Color(0xff333333) : Color(0xffEF9A9A),
                        child: Icon(
                          Icons.send,
                          color: chatProvider.isDarkMode ? Colors.white : Color(0xff1E3A5F),
                          size: 30,
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
          Positioned(
            bottom: 80,
            left: 160,
            child: chatProvider.showScrollToBottomButton
                ? FloatingActionButton(
              onPressed: chatProvider.scrollToBottom,
              mini: true,
              backgroundColor: chatProvider.isDarkMode ? Color(0xff222222) : Color(0xffEF9A9A),
              child: Icon(Icons.arrow_downward),
            )
                : SizedBox(),
          ),
        ],
      ),
    );
  }
}
