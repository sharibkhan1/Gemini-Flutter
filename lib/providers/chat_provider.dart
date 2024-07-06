import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:gemini/message_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatProvider extends ChangeNotifier {
  // Member variables
  bool _isDarkMode = false; // Indicates current theme mode
  bool _isTyping = false; // Indicates if user is typing
  bool _showScrollToBottomButton = false; // Controls visibility of scroll to bottom button
  List<ModelMessage> _prompt = []; // List of messages in the chat
  List<String> _chatTitles = []; // Titles of saved chats
  int _currentChatIndex = 0; // Index of the currently selected chat
  final ScrollController _scrollController = ScrollController(); // Controller for scrolling chat view

  // Constructor
  ChatProvider() {
    _scrollController.addListener(_scrollListener); // Initialize scroll listener
    _loadChatTitles(); // Load chat titles from SharedPreferences
    if (_currentChatIndex != -1) {
      _loadMessages(_currentChatIndex); // Load messages if a chat is selected
    }
  }

  // Getters
  bool get isDarkMode => _isDarkMode; // Getter for dark mode status
  bool get isTyping => _isTyping; // Getter for typing status
  bool get showScrollToBottomButton => _showScrollToBottomButton; // Getter for scroll to bottom button visibility
  List<ModelMessage> get prompt => _prompt; // Getter for messages list
  List<String> get chatTitles => _chatTitles; // Getter for chat titles
  int get currentChatIndex => _currentChatIndex; // Getter for current chat index
  ScrollController get scrollController => _scrollController; // Getter for scroll controller

  // Methods to load and save chat titles
  Future<void> _loadChatTitles() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _chatTitles = prefs.getStringList('chatTitles') ?? []; // Load chat titles from SharedPreferences
    notifyListeners();
  }

  Future<void> _saveChatTitles() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('chatTitles', _chatTitles); // Save chat titles to SharedPreferences
  }

  // Methods to load and save messages for a chat
  Future<void> _saveMessages(int chatIndex) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> messagesJson = _prompt.map((msg) => jsonEncode(msg.toMap())).toList();
    await prefs.setStringList('chatMessages_$chatIndex', messagesJson); // Save messages to SharedPreferences
  }

  Future<void> _loadMessages(int chatIndex) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? messagesJson = prefs.getStringList('chatMessages_$chatIndex');
    if (messagesJson != null) {
      _prompt = messagesJson.map((msgJson) => ModelMessage.fromMap(jsonDecode(msgJson))).toList();
    } else {
      _prompt.clear(); // Clear messages if none found for the chatIndex
    }
    notifyListeners();
  }

  // Listener for scroll controller to show/hide scroll to bottom button
  void _scrollListener() {
    if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
      _showScrollToBottomButton = false; // Hide button when scrolled to bottom
    } else {
      _showScrollToBottomButton = true; // Show button otherwise
    }
    notifyListeners();
  }

  // Method to add a new chat title
  void addChatTitle(String title) {
    _chatTitles.add(title); // Add new chat title
    _saveChatTitles(); // Save updated chat titles
    notifyListeners();
  }

  // Method to remove a chat title by index
  void removeChatTitle(int index) async {
    if (index >= 0 && index < _chatTitles.length) {
      _chatTitles.removeAt(index); // Remove chat title at given index
      await _deleteMessages(index); // Delete messages associated with this chat title
      _saveChatTitles(); // Save updated chat titles

      // Adjust currentChatIndex and load messages for the new current chat
      if (_chatTitles.isEmpty) {
        _currentChatIndex = -1;
        _prompt.clear();
      } else if (_currentChatIndex >= _chatTitles.length) {
        _currentChatIndex = _chatTitles.length - 1;
      }
      _loadMessages(_currentChatIndex); // Load messages for the new current chat index
      notifyListeners();
    }
  }

  // Method to delete messages associated with a chat title index
  Future<void> _deleteMessages(int chatIndex) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('chatMessages_$chatIndex'); // Remove messages from SharedPreferences
    _prompt.clear(); // Clear messages list in memory

    // Shift messages associated with indices greater than chatIndex
    for (int i = chatIndex + 1; i <= _chatTitles.length; i++) {
      List<String>? messagesJson = prefs.getStringList('chatMessages_$i');
      if (messagesJson != null) {
        await prefs.setStringList('chatMessages_${i - 1}', messagesJson);
        await prefs.remove('chatMessages_$i');
      }
    }
  }

  // Method to rename a chat title
  void renameChatTitle(int index, String newTitle) {
    if (index >= 0 && index < _chatTitles.length && newTitle.length <= 12) {
      _chatTitles[index] = newTitle; // Update chat title at given index
      _saveChatTitles(); // Save updated chat titles
      notifyListeners();
    }
  }

  // Method to set the current chat index and load messages for the selected chat
  void setCurrentChatIndex(int index) {
    _currentChatIndex = index; // Set current chat index
    _loadMessages(_currentChatIndex); // Load messages for the selected chat
    notifyListeners();
  }

  // Method to toggle between light and dark themes
  void toggleTheme() {
    _isDarkMode = !_isDarkMode; // Toggle dark mode
    notifyListeners();
  }

  // Method to scroll to the bottom of the chat
  void scrollToBottom() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  // Method to simulate sending a message and receiving a response
  Future<void> sendMessage(String message) async {
    _prompt.add(ModelMessage(isPrompt: true, message: message, time: DateTime.now())); // Add user message to prompt
    _saveMessages(_currentChatIndex); // Save messages after adding the new one
    _isTyping = true; // Set typing status
    notifyListeners();

    // Simulate API call or any asynchronous operation
    await Future.delayed(Duration(seconds: 1));

    // Example response handling
    _prompt.add(ModelMessage(
      isPrompt: false,
      message: 'Server Error', // Replace with actual response handling
      time: DateTime.now(),
    ));

    _isTyping = false; // Clear typing status
    notifyListeners();
    _saveMessages(_currentChatIndex); // Save messages after receiving the response
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener); // Remove scroll listener
    _scrollController.dispose(); // Dispose of scroll controller
    super.dispose();
  }
}
