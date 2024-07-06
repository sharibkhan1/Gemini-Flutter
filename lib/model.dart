
import 'package:gemini/message_model.dart';

class Chat {
  final String title;
  final List<ModelMessage> messages;

  Chat({
    required this.title,
    required this.messages,
  });
}
