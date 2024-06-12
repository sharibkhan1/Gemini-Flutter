import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gemini/model.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

// class _MyAppState extends State<MyApp> {
//   TextEditingController promptController = TextEditingController();
//   static const apikey= 'AIzaSyCXEzm9eZHuUJjG8cXJLwQCfvQR5Z2Xx0U';
//   final model = GenerativeModel(model: "gemini-pro", apiKey: apikey);
//   List<ModelMessage> prompt =[];
// //  final isPrompt = false;
//   Future<void> sendMessage() async{
//     final message = promptController.text;
//     setState(() {
//       promptController.clear();
//       prompt.add(
//         ModelMessage(isPrompt: true, message: message, time: DateTime.now(),),
//       );
//     });
//
//
//     final content = [Content.text(message)];
//     final response = await model.generateContent(content);
//     setState(() {
//       prompt.add(
//         ModelMessage(isPrompt: false, message: response.text ?? '', time: DateTime.now(),),
//       );
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         backgroundColor: Colors.blue[100],
//         appBar: AppBar(
//           elevation: 3,
//           backgroundColor: Colors.blue[100],
//           title: Text('AI BOT'),
//         ),

//         body: Column(
//           children: [
//             Expanded(child:ListView.builder(
//               itemCount: prompt.length,
//                 itemBuilder:(context,index){
//                 final message = prompt[index];
//                   return
//                     UserPrompt(isPrompt: message.isPrompt, message: message.message, index: index, );
//                 })),
//             Padding(
//               padding: EdgeInsets.all(25),
//               child: Row(
//                 children: [
//                   Expanded(
//                     flex: 32,
//                     child: TextField(
//                       controller: promptController,
//                       style: TextStyle(
//                         color: Colors.black,
//                         fontSize: 20,
//                       ),
//                       decoration: InputDecoration(
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(20),
//                         ),
//                         hintText: 'afasf',
//                       ),
//                     ),
//                   ),
//                   Spacer(),
//                   GestureDetector(onTap: (){
//                     sendMessage();
//                   },
//                   child: CircleAvatar(
//                     radius: 29,
//                     backgroundColor: Colors.green,
//                     child: Icon(
//                       Icons.send,
//                       color: Colors.white,
//                       size: 32,
//                     ),
//                   ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Container UserPrompt({required final bool isPrompt,required String message, required int index,}) {
//     return Container(
//                   width: double.infinity,
//                   margin: EdgeInsets.symmetric(vertical: 15).copyWith(
//                     left: isPrompt ?80:15 ,right :isPrompt? 15:80,
//                   ),
//                   padding: const EdgeInsets.all(15),
//                   decoration: BoxDecoration(
//                     color: isPrompt? Colors.green:Colors.grey,
//                     borderRadius: BorderRadius.circular(20),
//                   ),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(message,style: TextStyle(fontWeight: isPrompt? FontWeight.bold : FontWeight.normal,
//                       fontSize: 18,
//                         color: isPrompt?Colors.white:Colors.black,
//                       ),),
//                     ],
//                   ),
//                 );
//   }
// }
class _MyAppState extends State<MyApp> {

  TextEditingController TextPrompt = TextEditingController();
  static const apikey= 'AIzaSyCXEzm9eZHuUJjG8cXJLwQCfvQR5Z2Xx0U';
  final model = GenerativeModel(model: "gemini-pro", apiKey: apikey);
  List<ModelMessage> prompt =[];
//  final isPrompt = false;
  Future<void> sendMessage() async{
    final message = TextPrompt.text;
    setState(() {
      TextPrompt.clear();
      prompt.add(
        ModelMessage(isPrompt: true, message: message, time: DateTime.now(),),
      );
    });


    final content = [Content.text(message)];
    final response = await model.generateContent(content);
    setState(() {
      prompt.add(
        ModelMessage(isPrompt: false, message: response.text ?? '', time: DateTime.now(),),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
          backgroundColor: Colors.blue[100],
          appBar: AppBar(
            title: Text('Ai BOt'),
            backgroundColor: Colors.blue,
            elevation: 3,
          ),
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Expanded(
                    child:ListView.builder(
                    itemCount: prompt.length,
                      itemBuilder: (context, index) {
                      final message = prompt[index];
                      return messageCont(isPrompt: message.isPrompt, message: message.message, index: index);
                      },

                )),
                Row(children:[
                  Expanded(
                    flex: 32,
                    child:TextField(
                    controller: TextPrompt,
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w700
                    ),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20)
                      ),
                      hintText:'type',
                    ),
                  ),
                  ),
                  Spacer(),
                  GestureDetector(
                    onTap: (){
                      sendMessage();
                    },
                    child: CircleAvatar(
                      radius: 32,
                      backgroundColor: Colors.green,
                      child: Icon(
                        Icons.send,
                        size: 30,
                      ),
                    ),
                  )
                ]
                )
              ],
            ),
          ),
        ),
    );
  }

  Container messageCont({required final bool isPrompt,required String message, required int index,}) {
    return Container(
                  width: double.infinity,
                  margin: EdgeInsets.symmetric(vertical: 15).copyWith(
                    left: isPrompt ?80:15 ,right :isPrompt? 15:80,
                  ),
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: isPrompt? Colors.green:Colors.grey,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(message,style: TextStyle(fontWeight: isPrompt? FontWeight.bold : FontWeight.normal,
                      fontSize: 18,
                        color: isPrompt?Colors.white:Colors.black,
                      ),),
                    ],
                  ),
                );
  }
// }
}