import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:gemini/message_model.dart';

class ChatProvider extends ChangeNotifier {
  bool _isDarkMode = false;
  bool _isTyping = false;
  bool _showScrollToBottomButton = false;
  List<ModelMessage> _prompt = [];
  List<String> _chatTitles = [];
  int _currentChatIndex = 0;
  final ScrollController _scrollController = ScrollController();

  ChatProvider() {
    _scrollController.addListener(_scrollListener);
    _loadChatTitles();
    if (_currentChatIndex != -1) {
      _loadMessages(_currentChatIndex);
    }
  }

  bool get isDarkMode => _isDarkMode;
  bool get isTyping => _isTyping;
  bool get showScrollToBottomButton => _showScrollToBottomButton;
  List<ModelMessage> get prompt => _prompt;
  List<String> get chatTitles => _chatTitles;
  int get currentChatIndex => _currentChatIndex;
  ScrollController get scrollController => _scrollController;

  Future<void> _loadChatTitles() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _chatTitles = prefs.getStringList('chatTitles') ?? [];
    notifyListeners();
  }

  Future<void> _saveChatTitles() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('chatTitles', _chatTitles);
  }

  Future<void> _saveMessages(int chatIndex) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> messagesJson = _prompt.map((msg) => jsonEncode(msg.toMap())).toList();
    await prefs.setStringList('chatMessages_$chatIndex', messagesJson);
  }

  Future<void> _loadMessages(int chatIndex) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? messagesJson = prefs.getStringList('chatMessages_$chatIndex');
    if (messagesJson != null) {
      _prompt = messagesJson.map((msgJson) => ModelMessage.fromMap(jsonDecode(msgJson))).toList();
    } else {
      _prompt.clear();
    }
    notifyListeners();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
      _showScrollToBottomButton = false;
    } else {
      _showScrollToBottomButton = true;
    }
    notifyListeners();
  }

  void addChatTitle(String title) {
    _chatTitles.add(title);
    _saveChatTitles();
    notifyListeners();
  }

  void removeChatTitle(int index) async {
    if (index >= 0 && index < _chatTitles.length) {
      _chatTitles.removeAt(index);
      await _deleteMessages(index);
      _saveChatTitles();

      if (_chatTitles.isEmpty) {
        _currentChatIndex = -1;
        _prompt.clear();
      } else if (_currentChatIndex >= _chatTitles.length) {
        _currentChatIndex = _chatTitles.length - 1;
      }
      _loadMessages(_currentChatIndex);
      notifyListeners();
    }
  }

  Future<void> _deleteMessages(int chatIndex) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('chatMessages_$chatIndex');
    _prompt.clear();

    for (int i = chatIndex + 1; i <= _chatTitles.length; i++) {
      List<String>? messagesJson = prefs.getStringList('chatMessages_$i');
      if (messagesJson != null) {
        await prefs.setStringList('chatMessages_${i - 1}', messagesJson);
        await prefs.remove('chatMessages_$i');
      }
    }
  }

  void renameChatTitle(int index, String newTitle) {
    if (index >= 0 && index < _chatTitles.length && newTitle.length <= 12) {
      _chatTitles[index] = newTitle;
      _saveChatTitles();
      notifyListeners();
    }
  }

  void setCurrentChatIndex(int index) {
    _currentChatIndex = index;
    _loadMessages(_currentChatIndex);
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
    _saveMessages(_currentChatIndex);
    _isTyping = true;
    notifyListeners();

    String ngrokUrl = "https://a148-35-240-157-197.ngrok-free.app/generate";
    Map<String, dynamic> query = {'query': message};

    try {
      final response = await http.post(
        Uri.parse(ngrokUrl),
        headers: <String, String>{'Content-Type': 'application/json; charset=UTF-8'},
        body: jsonEncode(query),
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        if (responseData != null && responseData['result'] != null) {
          _prompt.add(ModelMessage(
            isPrompt: false,
            message: responseData['result'],
            time: DateTime.now(),
          ));
        } else {
          _prompt.add(ModelMessage(
            isPrompt: false,
            message: 'Received unexpected response from server',
            time: DateTime.now(),
          ));
        }
      } else {
        _prompt.add(ModelMessage(
          isPrompt: false,
          message: 'Failed to get response from server',
          time: DateTime.now(),
        ));
      }
    } catch (error) {
      _prompt.add(ModelMessage(
        isPrompt: false,
        message: 'An error occurred: $error',
        time: DateTime.now(),
      ));
    }

    _isTyping = false;
    notifyListeners();
    _saveMessages(_currentChatIndex);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }
}
