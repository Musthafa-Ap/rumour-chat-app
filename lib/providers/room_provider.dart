import 'package:flutter/material.dart';
import '../models/room.dart';
import '../services/firestore_service.dart';

class RoomProvider extends ChangeNotifier {
  final FirestoreService _firestoreService = FirestoreService();
  
  Room? _currentRoom;
  bool _joinLoading = false;
  bool _createLoading = false;
  String? _error;

  Room? get currentRoom => _currentRoom;
  bool get joinLoading => _joinLoading;
  bool get createLoading => _createLoading;
  String? get error => _error;

  Future<void> joinRoom(String code) async {
    _joinLoading = true;
    _error = null;
    notifyListeners();

    try {
      final code_ = code.trim().toUpperCase();
      if (code_.isEmpty) {
        _error = 'Please enter a room code';
        _joinLoading = false;
        notifyListeners();
        return;
      }

      final room = await _firestoreService.getRoomByCode(code_);
      
      if (room != null) {
        _currentRoom = room;
        _joinLoading = false;
        notifyListeners();
      } else {
        _error = 'Room not found. Please check the code.';
        _joinLoading = false;
        notifyListeners();
      }
    } catch (e) {
      _error = 'Error joining room: $e';
      _joinLoading = false;
      notifyListeners();
    }
  }

  Future<void> createRoom() async {
    _createLoading = true;
    _error = null;
    notifyListeners();

    try {
      final room = await _firestoreService.createRoom();
      _currentRoom = room;
      _createLoading = false;
      notifyListeners();
    } catch (e) {
      _error = 'Error creating room: $e';
      _createLoading = false;
      notifyListeners();
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  void reset() {
    _currentRoom = null;
    _joinLoading = false;
    _createLoading = false;
    _error = null;
    notifyListeners();
  }
}
