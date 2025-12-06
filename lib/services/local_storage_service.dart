import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/user.dart';
import '../models/message.dart';

class LocalStorageService {
  static const String _userPrefix = 'user_';
  static const String _messagesPrefix = 'messages_';
  static const String _roomCodePrefix = 'room_code_';

  // save user for a room
  Future<void> saveUserForRoom(String roomId, User user) async {
    final prefs = await SharedPreferences.getInstance();
    final key = '$_userPrefix$roomId';
    await prefs.setString(key, jsonEncode(user.toMap()));
  }

  // get user for a room
  Future<User?> getUserForRoom(String roomId) async {
    final prefs = await SharedPreferences.getInstance();
    final key = '$_userPrefix$roomId';
    final data = prefs.getString(key);
    if (data != null) {
      return User.fromMap(jsonDecode(data));
    }
    return null;
  }

  // save messages for a room
  Future<void> saveMessagesForRoom(String roomId, List<Message> messages) async {
    final prefs = await SharedPreferences.getInstance();
    final key = '$_messagesPrefix$roomId';
    final data = messages.map((m) => m.toLocalMap()).toList();
    await prefs.setString(key, jsonEncode(data));
  }

  // get messages for a room
  Future<List<Message>> getMessagesForRoom(String roomId) async {
    final prefs = await SharedPreferences.getInstance();
    final key = '$_messagesPrefix$roomId';
    final data = prefs.getString(key);
    if (data != null) {
      final list = jsonDecode(data) as List;
      return list.map((m) => Message.fromLocalMap(m as Map<String, dynamic>)).toList();
    }
    return [];
  }

  // save room code for a room
  Future<void> saveRoomCode(String roomId, String code) async {
    final prefs = await SharedPreferences.getInstance();
    final key = '$_roomCodePrefix$roomId';
    await prefs.setString(key, code);
  }

  // get room code
  Future<String?> getRoomCode(String roomId) async {
    final prefs = await SharedPreferences.getInstance();
    final key = '$_roomCodePrefix$roomId';
    return prefs.getString(key);
  }

  // clear all data for a room
  Future<void> clearRoomData(String roomId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('$_userPrefix$roomId');
    await prefs.remove('$_messagesPrefix$roomId');
    await prefs.remove('$_roomCodePrefix$roomId');
  }
}
