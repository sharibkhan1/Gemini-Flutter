import 'package:flutter/material.dart';
import 'package:gemini/providers/chat_provider.dart';
import 'package:provider/provider.dart';

class MessageWidget extends StatefulWidget {
  final bool isPrompt;
  final String message;
  final String date;

  const MessageWidget({
    Key? key,
    required this.isPrompt,
    required this.message,
    required this.date,
  }) : super(key: key);

  @override
  State<MessageWidget> createState() => _MessageWidgetState();
}

class _MessageWidgetState extends State<MessageWidget> {

  @override
  Widget build(BuildContext context) {
    final chatProvider = Provider.of<ChatProvider>(context);

    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(vertical: 15).copyWith(
        left: widget.isPrompt ? 80 : 15,
        right: widget.isPrompt ? 15 : 80,
      ),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color:chatProvider.isDarkMode?(widget.isPrompt ? Color(0xff333333):Colors.white) :(widget.isPrompt ?  Colors.white:Color(0xff333333)),
        borderRadius: widget.isPrompt
            ? BorderRadius.only(
          topRight: Radius.circular(30),
          topLeft: Radius.circular(30),
          bottomLeft: Radius.circular(30),
        )
            : BorderRadius.only(
          topRight: Radius.circular(20),
          topLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),

      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.message,
            style: TextStyle(
              fontWeight: widget.isPrompt ? FontWeight.bold : FontWeight.normal,
              fontSize: 18,
              color:chatProvider.isDarkMode? (widget.isPrompt ? Colors.white:Color(0xff333333)):(widget.isPrompt ?Color(0xff333333):Colors.white),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                widget.date,
                style: TextStyle(
                  fontWeight: FontWeight.normal,
                  fontSize: 14,
                  color: widget.isPrompt&&chatProvider.isDarkMode  ? Colors.white.withOpacity(0.7) : Colors.black.withOpacity(0.7),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
