import 'package:flutter/material.dart';
import 'package:gemini/message_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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

    final response = await http.get(Uri.parse('http://192.168.0.106:5000/api?Query=$message'));
    final responseData = json.decode(response.body);

    _prompt.add(ModelMessage(
        isPrompt: false,
        message: responseData['Answer'],
        time: DateTime.now()
    ));
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
