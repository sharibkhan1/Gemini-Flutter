import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class CustomTypingIndicator extends StatelessWidget {
  const CustomTypingIndicator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 8),
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 15),
        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Color(0xff1E3A5F),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "AI is typing",
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
            SizedBox(width: 10),
            SpinKitThreeBounce(
              color: Colors.white,
              size: 20.0,
            ),
          ],
        ),
      ),
    );
  }
}
