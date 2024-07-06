import 'dart:convert';

class ModelMessage {
  final bool isPrompt;
  final String message;
  final DateTime time;

  ModelMessage({
    required this.isPrompt,
    required this.message,
    required this.time,
  });

  Map<String, dynamic> toMap() {
    return {
      'isPrompt': isPrompt,
      'message': message,
      'time': time.toIso8601String(), // Serialize DateTime to ISO 8601 string
    };
  }

  factory ModelMessage.fromMap(Map<String, dynamic> map) {
    return ModelMessage(
      isPrompt: map['isPrompt'],
      message: map['message'],
      time: DateTime.parse(map['time']), // Deserialize ISO 8601 string to DateTime
    );
  }
}
