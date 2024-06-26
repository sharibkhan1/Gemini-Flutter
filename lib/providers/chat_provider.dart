import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:gemini/message_model.dart';
import 'package:http/http.dart' as http;

class ChatProvider extends ChangeNotifier {
  bool _isDarkMode = false;
  bool _isTyping = false;
  bool _showScrollToBottomButton = false;
  List<ModelMessage> _prompt = [];
  final ScrollController _scrollController = ScrollController();

  ChatProvider() {
    _scrollController.addListener(_scrollListener);
  }

  bool get isDarkMode => _isDarkMode;
  bool get isTyping => _isTyping;
  bool get showScrollToBottomButton => _showScrollToBottomButton;
  List<ModelMessage> get prompt => _prompt;
  ScrollController get scrollController => _scrollController;

  void _scrollListener() {
    if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
      _showScrollToBottomButton = false;
    } else {
      _showScrollToBottomButton = true;
    }
    notifyListeners();
  }

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }

  void scrollToBottom() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  Future<void> sendMessage(String message) async {
    _prompt.add(ModelMessage(isPrompt: true, message: message, time: DateTime.now()));
    _isTyping = true;
    notifyListeners();

    String ngrokUrl = "https://f243-34-148-183-75.ngrok-free.app/generate";
    Map<String, dynamic> query = {
      'query': message,
    };

    final response = await http.post(
      Uri.parse(ngrokUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(query),
    );

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      _prompt.add(ModelMessage(
        isPrompt: false,
        message: responseData['Answer'],
        time: DateTime.now(),
      ));
    } else {
      _prompt.add(ModelMessage(
        isPrompt: false,
        message: 'Failed to get response from server',
        time: DateTime.now(),
      ));
    }

    _isTyping = false;
    notifyListeners();
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }
}
