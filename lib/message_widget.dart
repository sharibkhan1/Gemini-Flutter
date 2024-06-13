import 'package:flutter/material.dart';

class MessageWidget extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(vertical: 15).copyWith(
        left: isPrompt ? 80 : 15,
        right: isPrompt ? 15 : 80,
      ),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: isPrompt ? Color(0xff333333) : Color(0xffEF9A9A),
        borderRadius: isPrompt
            ? BorderRadius.only(topRight: Radius.circular(30), topLeft: Radius.circular(30), bottomLeft: Radius.circular(30))
            : BorderRadius.only(topRight: Radius.circular(20), topLeft: Radius.circular(20), bottomRight: Radius.circular(20)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            message,
            style: TextStyle(
              fontWeight: isPrompt ? FontWeight.bold : FontWeight.normal,
              fontSize: 18,
              color: isPrompt ? Color(0xffECEFF1) : Color(0xff1E3A5F),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                date,
                style: TextStyle(
                  fontWeight: FontWeight.normal,
                  fontSize: 14,
                  color: isPrompt ? Color(0xffECEFF1) : Color(0xff1E3A5F),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
