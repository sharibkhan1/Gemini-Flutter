import 'package:flutter/material.dart';
import 'package:gemini/drawerrr.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:gemini/providers/chat_provider.dart';
import 'package:gemini/message_widget.dart';
import 'package:gemini/typing_indicator.dart';
import 'dart:ui';
class ChatScreen extends StatefulWidget {
  ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController textPrompt = TextEditingController();
  bool isDrawerOpen = false;

  void toggleDrawer() {
    setState(() {
      isDrawerOpen = !isDrawerOpen;
    });
  }

  void createNewChat(ChatProvider chatProvider) {
    chatProvider.addChatTitle('New Chat');
    chatProvider.setCurrentChatIndex(chatProvider.chatTitles.length - 1);
  }

  @override
  Widget build(BuildContext context) {
    final chatProvider = Provider.of<ChatProvider>(context);

    return Scaffold(
      backgroundColor: chatProvider.isDarkMode ? Color(0xff222222) : Colors.white,
      appBar: AppBar(
        leading: Padding(
          padding: EdgeInsets.only(left: 10.0),
          child: Image(
            image: AssetImage("assets/360_F_446386956_DiOrdcxDFWKWFuzVUCugstxz0zOGMHnA-removebg-preview - Copy.png"), // Replace with your image path
            color:chatProvider.isDarkMode? Colors.white:Color(0xff222222),
            width: 50,
          ),
        ),
        title: Text(
          'CHAT BOT',
          style: TextStyle(
            color: chatProvider.isDarkMode ? Colors.white : Color(0xff222222),
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: chatProvider.isDarkMode ? Color(0xff333333) : Colors.white,
        elevation: 3,
        titleSpacing: 16,
        actions: [
          IconButton(
            icon: chatProvider.isDarkMode
                ? Icon(Icons.dark_mode, color: Colors.white, size: 24)
                : Icon(Icons.light_mode, color: Color(0xff222222), size: 24),
            onPressed: chatProvider.toggleTheme,
          ),
          IconButton(
            icon: isDrawerOpen
                ? Icon(Icons.cancel, size: 30, color: Colors.red)
                : Icon(Icons.add, size: 30, color:chatProvider.isDarkMode ?Colors.white: Color(0xff222222)),
            focusColor: Colors.cyan,
            onPressed: () {
              toggleDrawer();
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              "assets/afda2a254d37c66ce039b7f91ad9742b.jpg", // Replace with your image path
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: chatProvider.chatTitles.isEmpty
                ? Center(
              child: Column(
                children: [
                  SizedBox(height:100,),
                  Image(image:AssetImage("assets/360_F_446386956_DiOrdcxDFWKWFuzVUCugstxz0zOGMHnA-removebg-preview - Copy.png",),fit: BoxFit.cover,width: 300,color: chatProvider.isDarkMode?Colors.black:Colors.white,),
                  SizedBox(height: 20,),
                  ElevatedButton(
                    onPressed: () {
                      createNewChat(chatProvider);
                    },
                    child: Text('Start a New Chat',style: TextStyle(color: chatProvider.isDarkMode?Colors.white:Colors.brown),),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 40.0),
                      textStyle: TextStyle(fontSize: 24),
                      backgroundColor:chatProvider.isDarkMode? Colors.black:Colors.white
                    ),
                  ),
                ],
              ),
            )
                : Column(
              children: [
                Expanded(
                  child: chatProvider.prompt.isEmpty
                      ? Center(child:
                          Text('No Chat '),
                      )
                      : ListView.builder(
                    controller: chatProvider.scrollController,
                    itemCount: chatProvider.isTyping
                        ? chatProvider.prompt.length + 1
                        : chatProvider.prompt.length,
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
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(50),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              color: chatProvider.isDarkMode ? Color(0xff333333).withOpacity(0.3) : Colors.white.withOpacity(0.3),
                            ),
                            child: TextField(
                              autocorrect: true,
                              controller: textPrompt,
                              style: TextStyle(
                                color: chatProvider.isDarkMode ? Colors.white : Colors.black,
                                fontWeight: FontWeight.w700,
                              ),
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.transparent, // Important for backdrop filter
                                contentPadding: EdgeInsets.symmetric(vertical: 18, horizontal: 20),
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(50)),
                                hintText: 'How can I help you....',
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 10), // Adjust spacing as needed
                    GestureDetector(
                      onTap: () {
                        FocusManager.instance.primaryFocus?.unfocus(); // Close the keyboard
                        chatProvider.sendMessage(textPrompt.text);
                        textPrompt.clear();
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                          child: CircleAvatar(
                            radius: 30,
                            backgroundColor: chatProvider.isDarkMode ? Color(0xff333333) : Colors.white,
                            child: IconButton(
                              icon: Icon(
                                Icons.send,
                                color: chatProvider.isDarkMode ? Colors.white : Color(0xff1E3A5F),
                                size: 32,
                              ),
                              onPressed: () {
                                FocusManager.instance.primaryFocus?.unfocus(); // Close the keyboard
                                chatProvider.sendMessage(textPrompt.text);
                                textPrompt.clear();
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

              ],
            ),
          ),
          if (isDrawerOpen)
            GestureDetector(
              onTap: () {
                toggleDrawer(); // Close drawer when tapped outside
              },
              child: Container(
                color: Colors.black.withOpacity(0.1), // Semi-transparent background
              ),
            ),
          AnimatedContainer(
            duration: Duration(milliseconds: 300),
            transform: Matrix4.translationValues(
              isDrawerOpen ? 0 : -MediaQuery.of(context).size.width * 0.7,
              0,
              0,
            ),
            child: CustomDrawer(), // Add the custom drawer here
          ),
          Positioned(
            bottom: 80,
            left: 160,
            child: chatProvider.showScrollToBottomButton
                ? FloatingActionButton(
              onPressed: chatProvider.scrollToBottom,
              mini: true,
              backgroundColor: chatProvider.isDarkMode ? Color(0xff222222) : Colors.white,
              child: Icon(Icons.arrow_downward,color: chatProvider.isDarkMode ?Colors.white:Color(0xff222222),),
            )
                : SizedBox(),
          ),
        ],
      ),
    );
  }
}
