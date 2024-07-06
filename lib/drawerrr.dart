import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:gemini/providers/chat_provider.dart';
import 'dart:ui';

class CustomDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final chatProvider = Provider.of<ChatProvider>(context);

    return ClipRRect(
      borderRadius: BorderRadius.only(topRight:Radius.circular(40)),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaY: 15,sigmaX: 15),
        child: Container(
          width: MediaQuery.of(context).size.width * 0.7,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.4),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 5,
                spreadRadius: 2,
              ),
            ],
          ),
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Container(
                  margin: EdgeInsets.only(top: 30, left: 30, right: 30,bottom: 60),
                  height: 60,
                  child: ElevatedButton.icon(
                    style: ButtonStyle(
                      backgroundColor:chatProvider.isDarkMode? MaterialStateProperty.all(Color(0xff333333)):MaterialStateProperty.all(Colors.white),
                    ),
                    onPressed: () {
                      chatProvider.addChatTitle('New Chat ');
                    },
                    icon: Icon(Icons.add, color:chatProvider.isDarkMode? Colors.white:Colors.black,size: 30,),
                    label: Text(
                      "New Chat",
                      style: TextStyle(
                        color: Colors.brown,
                        fontSize: 20
                      ),
                    ),
                  ),
                ),
              ),
              chatProvider.chatTitles.isEmpty
                  ? Center(
                child: Text(
                  'No Chat',
                  style: TextStyle(fontSize: 18,color: chatProvider.isDarkMode?Colors.black:Colors.white),
                ),
              )
                  : ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: chatProvider.chatTitles.length,
                itemBuilder: (context, index) {
                  final hasMessages =
                      chatProvider.prompt.isNotEmpty && chatProvider.currentChatIndex == index;

                  return GestureDetector(
                    onTap: () {
                      chatProvider.setCurrentChatIndex(index); // Set current chat index here
                    },
                    child: Container(
                      color: chatProvider.currentChatIndex == index ? Color(0xff333333) : Colors.transparent,
                      child: ListTile(
                        title: Text(chatProvider.chatTitles[index],style: TextStyle(color: Colors.white),),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(Icons.edit,color: Colors.brown,),
                              onPressed: () {
                                _showRenameDialog(context, chatProvider, index);
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.delete,color: Colors.red,),
                              onPressed: () {
                                chatProvider.removeChatTitle(index);
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showRenameDialog(BuildContext context, ChatProvider chatProvider, int index) {
    TextEditingController renameController = TextEditingController(text: chatProvider.chatTitles[index]);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        icon: Icon(Icons.drive_file_rename_outline_outlined),
        iconColor: Colors.red,
        title: Text('Rename Chat'),
        content: TextField(
          maxLength: 12,
          controller: renameController,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            hintText: 'Enter new name',
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: Text('Cancel'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: Text('Rename'),
            onPressed: () {
              String newName = renameController.text.trim();
              if (newName.isNotEmpty) {
                chatProvider.renameChatTitle(index, newName);
              }
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }
}
