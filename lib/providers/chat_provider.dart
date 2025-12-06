import 'dart:async';
import 'package:flutter/material.dart';
import '../models/message.dart';
import '../models/room.dart';
import '../services/firestore_service.dart';
import '../services/local_storage_service.dart';

class ChatProvider extends ChangeNotifier {
  final FirestoreService _firestoreService = FirestoreService();
  final LocalStorageService _localStorageService = LocalStorageService();

  List<Message> _messages = [];
  int _memberCount = 0;
  bool _isSending = false;
  bool _isLoadingMore = false;
  String? _error;

  List<Message> get messages => _messages;
  int get memberCount => _memberCount;
  bool get isSending => _isSending;
  bool get isLoadingMore => _isLoadingMore;
  String? get error => _error;

  late StreamSubscription _messagesSubscription;
  late StreamSubscription _memberCountSubscription;

  void initializeChat(Room room) {
    _listenToMessages(room.id);
    _listenToMemberCount(room.id);
    _loadLocalMessages(room.id);
  }

  void _listenToMessages(String roomId) {
    _messagesSubscription = 
        _firestoreService.getMessagesStream(roomId).listen((messages) {
      _messages = messages;
      _localStorageService.saveMessagesForRoom(roomId, messages);
      notifyListeners();
    });
  }

  void _listenToMemberCount(String roomId) {
    _memberCountSubscription = 
        _firestoreService.getRoomMemberCountStream(roomId).listen((count) {
      _memberCount = count;
      notifyListeners();
    });
  }

  Future<void> _loadLocalMessages(String roomId) async {
    try {
      final messages = await _localStorageService.getMessagesForRoom(roomId);
      if (messages.isNotEmpty && _messages.isEmpty) {
        _messages = messages;
        notifyListeners();
      }
    } catch (e) {
      // Silently fail
    }
  }

  Future<void> sendMessage(
    String roomId,
    String userId,
    String userName,
    String text,
  ) async {
    final trimmedText = text.trim();
    if (trimmedText.isEmpty) return;

    _isSending = true;
    _error = null;
    notifyListeners();

    try {
      await _firestoreService.sendMessage(
        roomId,
        userId,
        userName,
        trimmedText,
      );
      _isSending = false;
      notifyListeners();
    } catch (e) {
      _error = 'Failed to send message: $e';
      _isSending = false;
      notifyListeners();
    }
  }

  Future<void> loadMoreMessages(String roomId) async {
    if (_isLoadingMore || _messages.isEmpty) return;

    _isLoadingMore = true;
    notifyListeners();

    try {
      final olderMessages = await _firestoreService.getMessagesPaginated(
        roomId,
        limit: 20,
        beforeDate: _messages.last.timestamp,
      );

      if (olderMessages.isNotEmpty) {
        _messages.addAll(olderMessages);
        notifyListeners();
      }
    } catch (e) {
      // Silently fail
    } finally {
      _isLoadingMore = false;
      notifyListeners();
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  void reset() {
    _messages = [];
    _memberCount = 0;
    _isSending = false;
    _isLoadingMore = false;
    _error = null;
    _messagesSubscription.cancel();
    _memberCountSubscription.cancel();
  }

  @override
  void dispose() {
    _messagesSubscription.cancel();
    _memberCountSubscription.cancel();
    super.dispose();
  }
}
