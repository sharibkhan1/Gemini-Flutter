// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';
// import 'package:flutter_spinkit/flutter_spinkit.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:gemini/model.dart';
// import 'package:google_generative_ai/google_generative_ai.dart';
// import 'package:intl/intl.dart';
//
// void main() {
//   runApp(const MyApp());
// }
//
// class MyApp extends StatefulWidget {
//   const MyApp({Key? key}) : super(key: key);
//
//   @override
//   State<MyApp> createState() => _MyAppState();
// }
//
// class _MyAppState extends State<MyApp> {
//   bool _isDarkMode = false;
//   TextEditingController TextPrompt = TextEditingController();
//   static const apikey = 'AIzaSyCXEzm9eZHuUJjG8cXJLwQCfvQR5Z2Xx0U';
//   final model = GenerativeModel(model: "gemini-pro", apiKey: apikey);
//   List<ModelMessage> prompt = [];
//   bool _isTyping = false; // Typing state
//   bool _showScrollToBottomButton = false;
//
//   ScrollController _scrollController = ScrollController();
//
//   void _toggleTheme() {
//     setState(() {
//       _isDarkMode = !_isDarkMode;
//     });
//   }
//   @override
//   void initState() {
//     super.initState();
//     _scrollController.addListener(_scrollListener);
//   }
//
//   @override
//   void dispose() {
//     _scrollController.removeListener(_scrollListener);
//     _scrollController.dispose();
//     super.dispose();
//   }
//
//   void _scrollListener() {
//     if (_scrollController.position.pixels ==
//         _scrollController.position.maxScrollExtent) {
//       setState(() {
//         _showScrollToBottomButton = false;
//       });
//     } else {
//       setState(() {
//         _showScrollToBottomButton = true;
//       });
//     }
//   }
//
//   void _scrollToBottom() {
//     _scrollController.animateTo(
//       _scrollController.position.maxScrollExtent,
//       duration: Duration(milliseconds: 300),
//       curve: Curves.easeInOut,
//     );
//   }
//
//   Future<void> sendMessage() async {
//     final message = TextPrompt.text;
//     setState(() {
//       TextPrompt.clear();
//       prompt.add(
//         ModelMessage(isPrompt: true, message: message, time: DateTime.now()),
//       );
//       _isTyping = true; // Bot starts typing
//     });
//
//     final content = [Content.text(message)];
//     final response = await model.generateContent(content);
//     setState(() {
//       prompt.add(
//         ModelMessage(
//             isPrompt: false, message: response.text ?? '', time: DateTime.now()),
//       );
//       _isTyping = false; // Bot stops typing
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       theme: _isDarkMode ? ThemeData.dark() : ThemeData.light(),
//       home: Scaffold(
//         backgroundColor: _isDarkMode ? Color(0xff222222) : Colors.white,
//         appBar: AppBar(
//           leading: const Padding(
//             padding: EdgeInsets.only(left: 10.0), // Adjust the value to set the desired space
//             child: Image(
//               image: AssetImage("assets/360_F_446386956_DiOrdcxDFWKWFuzVUCugstxz0zOGMHnA-removebg-preview.png"),
//               color: Colors.white,
//               width: 50,
//             ),
//           ),
//           title: Text(
//             'CHAT BOT',
//             style: TextStyle(color:_isDarkMode? Colors.white : Color(0xffECEFF1),fontWeight: FontWeight.bold),
//           ),
//           backgroundColor:_isDarkMode? Color(0xff333333):Color(0xff1E3A5F),
//           elevation: 3,
//           titleSpacing: 16,
//           actions: [
//             IconButton(
//               icon: _isDarkMode
//                   ? Icon(Icons.light_mode, color: Colors.white, size: 24)
//                   : Icon(Icons.dark_mode, color: Colors.white, size: 24),
//               onPressed: _toggleTheme,
//             ),
//           ],
//
//         ),
//
//         body: Stack(
//           children: [
//             Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Column(
//                 children: [
//                   Expanded(
//                     child: ListView.builder(
//                       controller: _scrollController,
//                       itemCount: _isTyping ? prompt.length + 1 : prompt.length,
//                       itemBuilder: (context, index) {
//                         if (index == prompt.length) {
//                           // Show typing indicator when bot is typing
//                           return CustomTypingIndicator();
//                         }
//                         final message = prompt[index];
//                         return messageCont(
//                           isPrompt: message.isPrompt,
//                           message: message.message,
//                           date: DateFormat('hh:mm a').format(message.time),
//                         );
//                       },
//                     ),
//                   ),
//                   Row(
//                     children: [
//                       Expanded(
//                         flex: 32,
//                         child: TextField(
//                           autocorrect: true,
//                           controller: TextPrompt,
//                           style: TextStyle(
//                               color: _isDarkMode? Colors.white :Colors.black, fontWeight: FontWeight.w700),
//                           decoration: InputDecoration(
//                             filled: true,
//                             fillColor:_isDarkMode? Color(0xff333333) : Colors.white,
//                             contentPadding: EdgeInsets.symmetric(vertical: 18, horizontal: 20), // Adjust content padding
//                             border: OutlineInputBorder(
//                                 borderRadius: BorderRadius.circular(50)),
//                             hintText: 'How can I help you....',
//                           ),
//                         ),
//                       ),
//                       Spacer(),
//                       GestureDetector(
//                         onTap: () {
//                           FocusManager.instance.primaryFocus?.unfocus(); // Close the keyboard
//                           sendMessage();
//                         },
//                         child: CircleAvatar(
//                           radius: 32,
//                           backgroundColor:_isDarkMode? Color(0xff333333) : Color(0xffEF9A9A),
//                           child: Icon(
//                             Icons.send,
//                             color: _isDarkMode?Colors.white:Color(0xff1E3A5F),
//                             size: 30,
//                           ),
//                         ),
//                       )
//                     ],
//                   )
//                 ],
//               ),
//             ),
//             Positioned(
//               bottom: 80,
//               left: 160,
//               child: _showScrollToBottomButton
//                   ? FloatingActionButton(
//                 onPressed: _scrollToBottom,
//                 mini: true,
//                 backgroundColor:_isDarkMode?Color(0xff222222): Color(0xffEF9A9A),
//                 child: Icon(Icons.arrow_downward),
//               )
//                   : SizedBox(),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Container messageCont(
//       {required final bool isPrompt,
//         required String message,
//         required String date}) {
//     return Container(
//       width: double.infinity,
//       margin: EdgeInsets.symmetric(vertical: 15).copyWith(
//         left: isPrompt ? 80 : 15,
//         right: isPrompt ? 15 : 80,
//       ),
//       padding: const EdgeInsets.all(15),
//       decoration: BoxDecoration(
//         color: isPrompt ? _isDarkMode?Color(0xff333333): Color(0xffEF9A9A) : Color(0xffECEFF1),
//         borderRadius:isPrompt? BorderRadius.only(topRight: Radius.circular(30),topLeft: Radius.circular(30),bottomLeft: Radius.circular(30)):BorderRadius.only(topRight: Radius.circular(20),topLeft: Radius.circular(20),bottomRight: Radius.circular(20)),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             message,
//             style: TextStyle(
//               fontWeight: isPrompt ? FontWeight.bold : FontWeight.normal,
//               fontSize: 18,
//               color: isPrompt ? Color(0xffECEFF1) : Color(0xff1E3A5F),
//             ),
//           ),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.end,
//             children: [
//               Text(
//                 date,
//                 style: TextStyle(
//                   fontWeight:FontWeight.normal ,
//                   fontSize: 14,
//                   color: isPrompt ? Color(0xffECEFF1) : Color(0xff1E3A5F),
//                 ),
//               ),
//             ],
//           )
//         ],
//       ),
//     );
//   }
// }
//
// class CustomTypingIndicator extends StatefulWidget {
//   @override
//   State<CustomTypingIndicator> createState() => _CustomTypingIndicatorState();
// }
//
// class _CustomTypingIndicatorState extends State<CustomTypingIndicator> {
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.only(left: 8.0,right: 8),
//       child: Container(
//         margin: EdgeInsets.symmetric(vertical: 15),
//         padding: EdgeInsets.all(15),
//         decoration: BoxDecoration(
//           color:  Color(0xff1E3A5F),
//           borderRadius: BorderRadius.circular(20),
//         ),
//         child: Row(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Text(
//               "AI is typing",
//               style: TextStyle(color: Colors.white, fontSize: 18),
//             ),
//             SizedBox(width: 10),
//             SpinKitThreeBounce(
//               color: Colors.white,
//               size: 20.0,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
